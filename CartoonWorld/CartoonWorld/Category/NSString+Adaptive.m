//
//  NSString+Adaptive.m
//  CartoonWorld
//
//  Created by dundun on 2017/9/7.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "NSString+Adaptive.h"

@implementation NSString (Adaptive)

- (CGSize)adaptiveSizeWithWidth:(CGFloat)width height:(CGFloat)height fontSize:(CGFloat)fontSize
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 换行
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    // 行间距
    [paragraphStyle setLineSpacing:5];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                 NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize textSize = [self boundingRectWithSize:CGSizeMake(width, height)
                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       attributes:attributes
                                          context:nil].size;
    return textSize;
}

@end
