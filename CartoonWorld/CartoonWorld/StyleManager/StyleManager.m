//
//  StyleManager.m
//  二次元境
//
//  Created by dundun on 17/4/12.
//  Copyright © 2017年 MS. All rights reserved.
//

#import "StyleManager.h"

@implementation StyleManager

+ (void)setStyle
{
    // tabBar
    [[UITabBar appearance] setTranslucent:NO];
    
    // navigationBar
    [[UINavigationBar appearance] setTranslucent:NO];       // 设置导航栏不透明
    [UINavigationBar appearance].barTintColor = COLOR_PINK; // 设置bar颜色
    [UINavigationBar appearance].tintColor = COLOR_WHITE;   // 设置镂空颜色
    
    //  统一设置返回按钮图片
    UIImage *backImage = [UIImage imageNamed:@"back_button"];
    [UINavigationBar appearance].backIndicatorImage = backImage;
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = backImage;
    
    // status
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; // 设置状态栏样式
    
    // 设置nav标题字体和颜色
    [UINavigationBar appearance].titleTextAttributes = @{
      NSForegroundColorAttributeName:COLOR_WHITE,
      NSFontAttributeName:[UIFont boldSystemFontOfSize:FONT_TITLE]
    };
    
    // 设置tabBarItem选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_PINK}
                                             forState:UIControlStateSelected];
    
    // 设置tabBarItem默认字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TEXT_GRAY}
                                             forState:UIControlStateNormal];
    
    // UIScrollView
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        UITableView.appearance.estimatedSectionHeaderHeight = 0.0;
        UITableView.appearance.estimatedSectionFooterHeight = 0.0;
        UITableView.appearance.estimatedRowHeight = 0.0;
    }
}

@end
