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
      @"SearchController",
      @"CartoonHomeController",
      @"MyController"
    ];
    
    // 控制器名
    NSArray * titelArr = @[
      @"搜搜搜",
      @"二次元",
      @"小爷me"
    ];
    
    // 控制器默认图标
    NSArray * imageArr = @[
      @"search_defualt",
      @"home_defualt",
      @"my_defualt"
    ];
    
    // 控制器选中高亮图标
    NSArray * selectArr = @[
      @"search_selected",
      @"home_selected",
      @"my_selected"
    ];
    
    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0; i < 3; i ++) {
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
    self.selectedIndex = 1;
}

@end
