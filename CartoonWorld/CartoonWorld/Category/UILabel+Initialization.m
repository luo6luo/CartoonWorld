//
//  UILabel+Initialization.m
//  二次元境
//
//  Created by dundun on 17/4/13.
//  Copyright © 2017年 MS. All rights reserved.
//

#import "UILabel+Initialization.h"

@implementation UILabel (Initialization)

+ (UILabel *)labelWithText:(NSString *)text
                 textColor:(UIColor *)textColor
                  fontSize:(CGFloat)fontSize
             textAlignment:(NSTextAlignment)textAlignment
{
    
    if (!text) { text = @""; }
    if (!textColor) { textColor = COLOR_TEXT_BLACK; }
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize: fontSize];
    label.textAlignment = textAlignment;
    
    return label;
}

@end
