//
//  UserModel.m
//  CartoonWorld
//
//  Created by dundun on 2017/11/7.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "UserModel.h"

static NSString *kNickName = @"nickName";
static NSString *kDescriptionStr = @"description";
static NSString *kHeaderIcon = @"headerIcon";
static NSString *kSearchHistory = @"searchHistory";

@interface UserModel()

@end

@implementation UserModel

+ (UserModel *)defaultUser
{
    static UserModel *user = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        user = [self unarchive];
        if (!user) {
            user = [[UserModel alloc] init];
        }
    });
    return user;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.nickName = @"兔子";
        self.descriptionStr = @"O(∩_∩)O~~";
        self.headerIcon = UIImageJPEGRepresentation([UIImage imageNamed:@"defaultIcon_header"], 1);
        self.searchHistory = [NSMutableArray array];
    }
    return self;
}

// 归档
- (void)archive
{
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [document stringByAppendingPathComponent:@"user.archiver"];
    
    // 注意此处归档的self是实例对象
    BOOL isSuccess = [NSKeyedArchiver archiveRootObject:self toFile:path];
    
    if (!isSuccess) {
        [AlertManager showInfo:@"保存失败"];
    }
}

// 解归档
+ (instancetype)unarchive
{
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [document stringByAppendingPathComponent:@"user.archiver"];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

# pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.nickName forKey:kNickName];
    [aCoder encodeObject:self.descriptionStr forKey:kDescriptionStr];
    [aCoder encodeObject:self.headerIcon forKey:kHeaderIcon];
    [aCoder encodeObject:self.searchHistory forKey:kSearchHistory];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.nickName = [aDecoder decodeObjectForKey:kNickName];
        self.descriptionStr = [aDecoder decodeObjectForKey:kDescriptionStr];
        self.headerIcon = [aDecoder decodeObjectForKey:kHeaderIcon];
        self.searchHistory = [aDecoder decodeObjectForKey:kSearchHistory];
    }
    return self;
}

@end
