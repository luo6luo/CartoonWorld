//
//  UserModel.h
//  CartoonWorld
//
//  Created by dundun on 2017/11/7.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject<NSCoding>

/**昵称*/
@property (nonatomic, strong) NSString *nickName;
/**描述*/
@property (nonatomic, strong) NSString *descriptionStr;
/**头像*/
@property (nonatomic, strong) NSData *headerIcon;
/**搜索历史(存字符串)*/
@property (nonatomic, strong) NSMutableArray *searchHistory;

/**获取用户对象*/
+ (UserModel *)defaultUser;

/**归档*/
- (void)archive;

@end
