//
//  UIButton+Initialization.m
//  二次元境
//
//  Created by dundun on 17/4/13.
//  Copyright © 2017年 MS. All rights reserved.
//

#import "UIButton+Initialization.h"

@implementation UIButton (Initialization)

+ (UIButton *)setupWithFrame:(CGRect)frame
             backgroundColor:(UIColor *)backgroundColor
                       title:(NSString *)title
                  titleColor:(UIColor *)titleColor
               titleFontSize:(CGFloat)titleFontSize
{
    
    if (!backgroundColor) {
        backgroundColor = [UIColor whiteColor];
    }
    
    if (!title) {
        title = @"";
    }
    
    if (!titleColor) {
        titleColor = TEXT_COLOR;
    }
    
    if (!titleFontSize) {
        titleFontSize = FONT_SUBTITLE;
    }
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = frame;
    btn.backgroundColor = backgroundColor;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:titleFontSize];
    return btn;
}

@end
