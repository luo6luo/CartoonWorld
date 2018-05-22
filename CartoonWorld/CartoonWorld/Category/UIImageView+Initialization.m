//
//  UIImageView+Initialization.m
//  CartoonWorld
//
//  Created by dundun on 2017/7/14.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "UIImageView+Initialization.h"

@implementation UIImageView (Initialization)

// 创建公共图片视图
+ (UIImageView *)imageViewWithFrame:(CGRect)aFrame image:(NSString *)aImage
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = COLOR_IMAGE_BACK;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    imageView.frame = aFrame;
    
    if (aImage) {
        imageView.image = [UIImage imageNamed:aImage];
    }
    
    return imageView;
}

@end
