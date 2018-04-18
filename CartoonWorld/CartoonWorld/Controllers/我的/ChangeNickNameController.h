//
//  ChangeNickNameController.h
//  CartoonWorld
//
//  Created by dundun on 2017/11/29.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeNickNameController : UITableViewController

@property (nonatomic, copy) void(^nickNameChangedBlock)(NSString *newNickName);

@end
