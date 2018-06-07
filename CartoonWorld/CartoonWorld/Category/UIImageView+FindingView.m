//
//  UIImageView+FindingView.m
//  CartoonWorld
//
//  Created by dundun on 2018/6/7.
//  Copyright © 2018年 顿顿. All rights reserved.
//

#import "UIImageView+FindingView.h"

@implementation UIImageView (FindingView)

// 寻找导航条下的那个线
+ (UIImageView *)findingSeparationLineWithView:(UIView *)view
{
    if ([view isKindOfClass:[UIImageView class]] && view.height <= 1.0) {
        return (UIImageView *)view;
    }
    
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findingSeparationLineWithView:subview];
        if (imageView) {
            return imageView;
        }
    }
    
    return nil;
}

@end
