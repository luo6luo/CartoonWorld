//
//  CustomLaunchView.h
//  CartoonWorld
//
//  Created by dundun on 2018/6/7.
//  Copyright © 2018年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLaunchView : UIView

@property (nonatomic, copy) void(^startToUseAppBlock)();

// 加载启动页
- (void)launchView;

@end
