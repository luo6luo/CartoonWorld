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
         withMethod:@selector(versionNotLessThan11_addSubview:)
         error:nil];
    } else {
        [NSClassFromString(@"UINavigationItemButtonView")
         jr_swizzleMethod:@selector(addSubview:)
         withMethod:@selector(versionLessThan11_addSubview:)
         error:nil];
    }
}

// 版本大于等于11
- (void)versionNotLessThan11_addSubview:(UIView *)view
{
    view.alpha = 0;
    if ([view isKindOfClass:[UIButton class]]) {
        UIButton *button = (id)view;
        [button setTitle:@"" forState:UIControlStateNormal];
    }
    [self versionNotLessThan11_addSubview:view];
}

// 版本小于11
- (void)versionLessThan11_addSubview:(UIView *)view
{
    view.alpha = 0;
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (id)view;
        label.text = @"";
    }
    [self versionLessThan11_addSubview:view];
}

@end
