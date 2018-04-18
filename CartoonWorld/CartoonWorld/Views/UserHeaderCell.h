//
//  UserHeaderCell.h
//  二次元境
//
//  Created by MS on 15/11/23.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHeaderCell : UITableViewCell

@property (nonatomic, strong) NSString *nickName;     // 昵称
@property (nonatomic, strong) NSData *headerIconData; // 头像
@property (nonatomic, strong) NSString *detail;       // 描述

@end
