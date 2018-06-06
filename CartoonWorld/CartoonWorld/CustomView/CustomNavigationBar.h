//
//  CustomNavigationBar.h
//  CartoonWorld
//
//  Created by dundun on 2017/10/10.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BarType){
    BarTypeMissingNone = 0,
    BarTypeMissingLeftBtn,
    BarTypeMissingRightBtn,
    BarTypeMissingLeftAndRightBtn
};

@interface CustomNavigationBar : UIView

@property (nonatomic, copy) void(^leftBtnClickedBlock)();
@property (nonatomic, copy) void(^rightBtnClickedBlock)();

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *rightImageName;
@property (nonatomic, strong) UIColor *barColor;
@property (nonatomic, assign) CGFloat barAlpha;

// 根据类型创建导航条
- (instancetype)initWithBarType:(BarType)barType;

// 布局
- (void)layoutSelfSubviews;

@end
