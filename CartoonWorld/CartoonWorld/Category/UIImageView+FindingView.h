//
//  UIImageView+FindingView.h
//  CartoonWorld
//
//  Created by dundun on 2018/6/7.
//  Copyright © 2018年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (FindingView)

// 寻找导航条下的那个线
+ (UIImageView *)findingSeparationLineWithView:(UIView *)view;

@end
