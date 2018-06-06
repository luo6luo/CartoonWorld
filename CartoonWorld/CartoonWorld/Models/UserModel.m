//
//  UserModel.m
//  CartoonWorld
//
//  Created by dundun on 2017/11/7.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "UserModel.h"
#import "DatebaseManager.h"

@interface UserModel()

@end

@implementation UserModel

- (id)copyWithZone:(NSZone *)zone
{
    UserModel *user = [[[self class] allocWithZone:zone] init];
    user.userID = self.userID;
    user.nickName = self.nickName;
    user.descriptionStr = self.descriptionStr;
    user.headerIcon = self.headerIcon;
    user.favorites = self.favorites;
    user.searchHistories = self.searchHistories;
    return user;
}

+ (UserModel *)defaultUser
{
    static UserModel *user = nil;
    static dispatch_once_t once;
    user = [[DatebaseManager defaultDatebaseManager] checkObject:user Key:@"userID" value:@"5466"];
    dispatch_once(&once, ^{
        if (!user) {
            user = [[UserModel alloc] init];
        }
    });
    return user;
}

- (instancetype)init
{
    if (self = [super init]) {
        // 一个账号对应一个id，以id作为主键进行存储和查询，此处假定id = 5466
        UserModel *user = [[DatebaseManager defaultDatebaseManager] checkObject:self Key:@"userID" value:@"5466"];
        
        if (!user) {
            self.userID = 5466;
            self.nickName = @"兔子";
            self.descriptionStr = @"O(∩_∩)O~~";
            self.headerIcon = UIImageJPEGRepresentation([UIImage imageNamed:@"defaultIcon_header"], 1);
            
            [[DatebaseManager defaultDatebaseManager] addObject:self key:@"userID" value:@"5466" completed:nil];
        } else {
            self = user;
        }
    }
    return self;
}

// 设置主键
+ (NSString *)primaryKey
{
    return @"userID";
}

@end
