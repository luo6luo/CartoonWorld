//
//  CustomNavigationBar.h
//  CartoonWorld
//
//  Created by dundun on 2017/10/10.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavigationBar : UIView

@property (nonatomic, copy) void(^leftBtnClickedBlock)();
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *barColor;
@property (nonatomic, assign) CGFloat barAlpha;

// 布局
- (void)layoutSelfSubviews;

@end
