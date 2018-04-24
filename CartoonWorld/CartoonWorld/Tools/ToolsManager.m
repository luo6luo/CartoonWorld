//
//  ToolsManager.m
//  二次元境
//
//  Created by dundun on 17/4/12.
//  Copyright © 2017年 MS. All rights reserved.
//

#import "ToolsManager.h"

@implementation ToolsManager

+ (BOOL)isPad
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return NO;
    }
}

// 判断屏幕方向
+ (ScreenOrientationType)screenOrientation
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == ScreenOrientationTypeVertical) {
        return ScreenOrientationTypeVertical;
    } else if (orientation == ScreenOrientationTypeHorizontal) {
        return ScreenOrientationTypeHorizontal;
    } else {
        return ScreenOrientationTypeUnknown;
    }
}

// 设置界面安全区域
+ (UIEdgeInsets)safeAreaInsetWithNavigationBar:(BOOL)isShow
{
    if ([self screenOrientation] == ScreenOrientationTypeVertical) {
        // 竖屏
        CGFloat safeAreaBottom = iPhoneX ? 34 : 0;
        CGFloat safeAreaTop = isShow == YES ? NAVIGATIONBAR_HEIGHT_V : (iPhoneX ? 44 : 0);
        return UIEdgeInsetsMake(safeAreaTop, 0, safeAreaBottom, 0);
    } else if ([self screenOrientation] == ScreenOrientationTypeHorizontal) {
        // 横屏
        CGFloat safeAreaTop = isShow ? NAVIGATIONBAR_HEIGHT_H : 0;
        CGFloat safeAreaLeftRight = iPhoneX ? 44 : 0;
        CGFloat safeAreaBottom = iPhoneX ? 21 : 0;
        return UIEdgeInsetsMake(safeAreaTop, safeAreaLeftRight, safeAreaBottom, safeAreaLeftRight);
    } else {
        return UIEdgeInsetsZero;
    }
}

@end
