//
//  UIImageView+Initialization.h
//  CartoonWorld
//
//  Created by dundun on 2017/7/14.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Initialization)

/**
 创建公用图片视图

 @param aFrame 视图位置    必填
 @param aImage 图片的名字  选填
 */
+ (UIImageView *)imageViewWithFrame:(CGRect)aFrame image:(NSString *)aImage;

@end
