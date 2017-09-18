//
//  UIView+Initialization.h
//  二次元境
//
//  Created by dundun on 17/4/13.
//  Copyright © 2017年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Initialization)

/**
 *  创建公用视图
 *
 *  @param frame 视图相对父视图位置    必填
 *  @param color 视图背景颜色         选填，默认白色
 *
 *  @return 返回创建好的视图
 */
+ (UIView *)setupWithFrame:(CGRect)frame backgroundColor:(UIColor *)color;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign, readonly) CGFloat maxY;
@property (nonatomic, assign, readonly) CGFloat minY;
@property (nonatomic, assign, readonly) CGFloat maxX;
@property (nonatomic, assign, readonly) CGFloat minX;

@end
