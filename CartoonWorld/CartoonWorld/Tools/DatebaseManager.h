//
//  DatebaseManager.h
//  CartoonWorld
//
//  Created by dundun on 2018/5/31.
//  Copyright © 2018年 顿顿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
@class UserModel;

@interface DatebaseManager : NSObject

+ (instancetype)defaultDatebaseManager;

// 检查版本
+ (void)migrationVersion;


/**
 添加数据

 @param obj   需要添加的对象
 @param key   确认该对象是否存在的 key
 @param value 确定该对象是否存在的 value
 @param block 添加完成后
 */
- (void)addObject:(id)obj key:(NSString *)key value:(NSString *)value completed:(void(^)())block;


/**
 删除数据（需确保存在）

 @param obj   需要删除的对象
 @param key   确认该对象是否存在的 key
 @param value 确定该对象是否存在的 value
 @param block 删除完成后
 */
- (void)deleteObject:(id)obj key:(NSString *)key value:(NSString *)value completed:(void(^)())block;


/**
 删除全部

 @param block 删除完成后
 */
- (void)deleteAllObjectCompleted:(void(^)())block;


/**
 修改数据

 @param modifyBlock 修改的代码块
 @param block       修改完成后
 */
- (void)modifyObject:(void(^)())modifyBlock completed:(void(^)())block;


/**
 更具具体信息查询

 @param object  需要查询的对象
 @param key     根据此 key 进行查询
 @param value   key 对应的值
 @return        查询结果
 */
- (id)checkObject:(RLMObject *)object Key:(NSString *)key value:(NSString *)value;

@end
