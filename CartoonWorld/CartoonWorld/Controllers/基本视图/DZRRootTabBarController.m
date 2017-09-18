//
//  DZRRootTabBarController.m
//  二次元境
//
//  Created by HecH on 15-11-18.
//  Copyright (c) 2015年 CK. All rights reserved.
//

#import "DZRRootTabBarController.h"

@interface DZRRootTabBarController ()

@end

@implementation DZRRootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabItems];
}

- (void)setupTabItems {
    
    // 类名
    NSArray * classNameArr = @[
      @"ZEDPageController",
      @"SouSouViewController",
      @"CartoonHomeController",
      @"ShuoKanViewController",
      @"XiaoYeViewController"
    ];
    
    // 控制器名
    NSArray * titelArr = @[
      @"中二堆",
      @"搜搜搜",
      @"二次元",
      @"绘图控",
      @"小爷me"
    ];
    
    // 控制器默认图标
    NSArray * imageArr = @[
      @"ZED_defualt",
      @"SSS_defualt",
      @"home_defualt",
      @"HTK_defualt",
      @"XYme_defualt"
    ];
    
    // 控制器选中高亮图标
    NSArray * selectArr = @[
      @"ZED_selected",
      @"SSS_selected",
      @"home_selected",
      @"HTK_selected",
      @"XYme_selected"
    ];
    
    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0; i < 5; i ++) {
        Class class = NSClassFromString(classNameArr[i]);
        UIViewController * vc = [[class alloc] init];
        vc.title = titelArr[i];
        vc.view.backgroundColor = COLOR_BACK_WHITE;
        
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
        vc.tabBarItem.image = [[UIImage imageNamed:imageArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        [arr addObject:nav];
    }

    self.viewControllers = arr;
    self.selectedIndex = 2;
}

@end
