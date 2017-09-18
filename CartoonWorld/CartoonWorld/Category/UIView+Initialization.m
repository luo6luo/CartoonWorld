//
//  UIView+Initialization.m
//  二次元境
//
//  Created by dundun on 17/4/13.
//  Copyright © 2017年 MS. All rights reserved.
//

#import "UIView+Initialization.h"

@implementation UIView (Initialization)

+ (UIView *)setupWithFrame:(CGRect)frame backgroundColor:(UIColor *)color
{
    if (!color) {
        color = [UIColor whiteColor];
    }
    
    UIView * view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

# pragma mark - Getter & Setter

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)minY
{
    return CGRectGetMidY(self.frame);
}

- (CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)minX
{
    return CGRectGetMidX(self.frame);
}

@end
