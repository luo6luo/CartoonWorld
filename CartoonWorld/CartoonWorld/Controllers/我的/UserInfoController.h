//
//  UserInfoController.h
//  CartoonWorld
//
//  Created by dundun on 2017/11/20.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoController : UITableViewController

// 是否修改了
@property (nonatomic, copy) void(^handleStatus)(BOOL isHandel);

@end
