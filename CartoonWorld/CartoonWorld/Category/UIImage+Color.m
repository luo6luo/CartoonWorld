//
//  UIImage+Color.m
//  CartoonWorld
//
//  Created by dundun on 2017/10/9.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

// 设置image颜色
+ (UIImage *)imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
