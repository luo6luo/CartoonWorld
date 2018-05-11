//
//  brightnessControlView.h
//  CartoonWorld
//
//  Created by dundun on 2018/5/8.
//  Copyright © 2018年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrightnessControlView : UIView

// 显示控制条
+ (void)showControlBarInView:(UIView *)supview;

// 移除控制条
+ (void)dismissControlBar;

@end
