//
//  UIButton+Initialization.h
//  二次元境
//
//  Created by dundun on 17/4/13.
//  Copyright © 2017年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Initialization)

/**
 *  创建公用按钮，默认才用系统模式
 *
 *  @param frame 按钮相对父视图位置         必填
 *  @param backgroundColor 按钮背景颜色    选填，默认白色
 *  @param title 按钮标题                 选填，默认空
 *  @param titleColor 字体颜色            选填，默认文本字色
 *  @param titleFontSize 字体大小         选填，默认15号，iPad默认17号
 *
 *  @return 返回创建好的按钮
 */
+ (UIButton *)setupWithFrame:(CGRect)frame
             backgroundColor:(UIColor *)backgroundColor
                       title:(NSString *)title
                  titleColor:(UIColor *)titleColor
               titleFontSize:(CGFloat)titleFontSize;

@end
