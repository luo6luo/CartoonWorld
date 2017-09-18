//
//  NSString+Adaptive.h
//  CartoonWorld
//
//  Created by dundun on 2017/9/7.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Adaptive)

/**
 自适应文字显示范围

 @param width    显示的宽度
 @param height   显示的高度
 @param fontSize 字体大小
 @return         显示范围
 */
- (CGSize)adaptiveSizeWithWidth:(CGFloat)width
                         height:(CGFloat)height
                       fontSize:(CGFloat)fontSize;

@end
