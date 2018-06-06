//
//  AnimationView.m
//  CartoonWorld
//
//  Created by dundun on 2018/6/1.
//  Copyright © 2018年 顿顿. All rights reserved.
//

#import "AnimationView.h"

@interface AnimationView()

@end

@implementation AnimationView

+ (void)animationWithImageName:(NSString *)imageName atView:(UIView *)supview startingFrame:(CGRect)start endFrame:(CGRect)end
{
    AnimationView *view = [[AnimationView alloc] init];
    view.frame = start;
    [supview addSubview:view];
    
    view.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [UIView animateWithDuration:1.0f delay:0.5 usingSpringWithDamping:0.5f initialSpringVelocity:15.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        view.frame = end;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            view.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
}

@end
