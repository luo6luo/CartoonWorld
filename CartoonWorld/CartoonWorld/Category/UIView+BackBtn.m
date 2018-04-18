//
//  UIView+BackBtn.m
//  CartoonWorld
//
//  Created by dundun on 2017/9/27.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "UIView+BackBtn.h"
#import <JRSwizzle.h>

@implementation UIView (BackBtn)

+ (void)load
{
    if (@available(iOS 11, *)) {
        [NSClassFromString(@"_UIBackButtonContainerView")
         jr_swizzleMethod:@selector(addSubview:)
         withMethod:@selector(iOS11BackButtonNoTextTrick_addSubview:)
         error:nil];
    }
}
- (void)iOS11BackButtonNoTextTrick_addSubview:(UIView *)view
{
    view.alpha = 0;
    if ([view isKindOfClass:[UIButton class]]) {
        UIButton *button = (id)view;
        [button setTitle:@"" forState:UIControlStateNormal];
    }
    [self iOS11BackButtonNoTextTrick_addSubview:view];
}

@end
