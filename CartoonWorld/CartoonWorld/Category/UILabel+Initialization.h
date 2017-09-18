//
//  UILabel+Initialization.h
//  二次元境
//
//  Created by dundun on 17/4/13.
//  Copyright © 2017年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Initialization)

/**
 * 创建公用label
 *
 * @param text 显示文字             选填（默认空）
 * @param textColor 文字颜色        选填（默认宏设置颜色）
 * @param fontSize 文字大小         必填
 * @param textAlignment 文字对齐方式 必填
 *
 * @return 返回设置好的label
 */
+ (UILabel *)labelWithText:(NSString *)text
                 textColor:(UIColor *)textColor
                  fontSize:(CGFloat)fontSize
             textAlignment:(NSTextAlignment)textAlignment;

@end
