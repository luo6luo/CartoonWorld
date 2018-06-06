//
//  AnimationView.h
//  CartoonWorld
//
//  Created by dundun on 2018/6/1.
//  Copyright © 2018年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationView : UIImageView


/**
 动画

 @param imageName 显示的图片
 @param supview   加载的父视图
 @param start     起始位置
 @param end       终点位置
 */
+ (void)animationWithImageName:(NSString *)imageName
                        atView:(UIView *)supview
                 startingFrame:(CGRect)start
                      endFrame:(CGRect)end;

@end
