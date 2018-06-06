//
//  DatebaseManager.m
//  CartoonWorld
//
//  Created by dundun on 2018/5/31.
//  Copyright © 2018年 顿顿. All rights reserved.
//


/*
 注意项：
 1、object通知并不监听得到object的RLMArray等集合属性成员的变化，需要另外处理
 2、无法多线程共享数据库对象
 3、不要将数据库对象作为参数传递，最好拷贝一份
 4、一个对象从数据库中删除了，他就是非法对象，对他的任何访问都是非法
 */

#import "DatebaseManager.h"
#import "UserModel.h"
#import <RLMRealmConfiguration.h>

static NSString *const kIsExist = @"isExist";

typedef void(^completeBlock)();

@interface DatebaseManager()

@end

@implementation DatebaseManager

+ (instancetype)defaultDatebaseManager
{
    static DatebaseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[DatebaseManager alloc] init];
        }
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

// 检查版本
+ (void)migrationVersion
{
    // 路径
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [document stringByAppendingPathComponent:@"user.realm"];
//    path = @"/Users/dundun/Desktop/datebase/user.realm";
    NSLog(@"%@",path);
    
    // 设置配置
    RLMRealmConfiguration *configuration = [RLMRealmConfiguration defaultConfiguration];
    configuration.fileURL = [NSURL URLWithString:path];
    configuration.schemaVersion = [VERSION floatValue];
    [RLMRealmConfiguration setDefaultConfiguration:configuration];
    
//    if (![GET_USER_DEFAULTS(kIsExist) boolValue]) {
//        // 创建数据库
//        [RLMRealm defaultRealm];
//        SET_USER_DEFAULTS(@(YES), kIsExist);
//    }
    
    CGFloat currentVersion = [VERSION floatValue];
    configuration.migrationBlock = ^(RLMMigration * _Nonnull migration, uint64_t oldSchemaVersion) {
        if (oldSchemaVersion < currentVersion) {
            // 数据迁移
        }
    };
    [RLMRealmConfiguration setDefaultConfiguration:configuration];
    [RLMRealm defaultRealm];
}

// 添加数据
- (void)addObject:(id)obj key:(NSString *)key value:(NSString *)value completed:(completeBlock)block
{
    // 确认存在
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMObject *object = [self checkObject:obj Key:key value:value];
    if (!object) {
        RLMNotificationToken *token = [realm addNotificationBlock:^(RLMNotification  _Nonnull notification, RLMRealm * _Nonnull realm) {
            if (block) {
                block();
            }
        }];
        
        // 添加
        NSError *error = nil;
        [realm refresh];
        [realm transactionWithBlock:^{
            [realm addObject:obj];
        } error:&error];
        
        if (error) {
            [AlertManager showInfo:error.localizedDescription];
        }
        
        [token invalidate];
    }
}

// 删除数据
- (void)deleteObject:(id)obj key:(NSString *)key value:(NSString *)value completed:(completeBlock)block
{
    // 确保存在
    RLMObject *object = [self checkObject:obj Key:key value:value];
    if (object) {
        // 删除
        RLMRealm *realm = [RLMRealm defaultRealm];
        RLMNotificationToken *token = [realm addNotificationBlock:^(RLMNotification  _Nonnull notification, RLMRealm * _Nonnull realm) {
            if (block) {
                block();
            }
        }];
        
        NSError *error = nil;
        [realm refresh];
        [realm transactionWithBlock:^{
            [realm deleteObject:object];
        } error:&error];
        
        if (error) {
            [AlertManager showInfo:error.localizedDescription];
        }
        
        [token invalidate];
    }
}

// 删除全部
- (void)deleteAllObjectCompleted:(completeBlock)block
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMNotificationToken *token = [realm addNotificationBlock:^(RLMNotification  _Nonnull notification, RLMRealm * _Nonnull realm) {
        if (block) {
            block();
        }
    }];
    
    NSError *error = nil;
    [realm refresh];
    [realm transactionWithBlock:^{
        [realm deleteAllObjects];
    } error:&error];
    
    [token invalidate];
}

// 修改数据
- (void)modifyObject:(void(^)())modifyBlock completed:(completeBlock)block
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMNotificationToken *token = [realm addNotificationBlock:^(RLMNotification  _Nonnull notification, RLMRealm * _Nonnull realm) {
        if (block) {
            block();
        }
    }];
    
    [realm refresh];
    [realm beginWriteTransaction];
    modifyBlock();
    [realm commitWriteTransaction];
    [token invalidate];
}

// 更具具体信息查询
- (id)checkObject:(RLMObject *)object Key:(NSString *)key value:(NSString *)value
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm refresh];
    NSString *condition = [NSString stringWithFormat:@"%@ == %@", key, value];
    RLMResults *results = [object.class objectsWhere:condition];
    object = results.count > 0 ? results.firstObject : nil;
    return object;
}

@end
