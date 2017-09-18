//
//  ShuoKanViewController.m
//  二次元境
//
//  Created by HecH on 15-11-18.
//  Copyright (c) 2015年 CK. All rights reserved.
//

#import "ShuoKanViewController.h"
#import "LatestVC.h"
#import "HotestVC.h"

@interface ShuoKanViewController ()

@property (nonatomic, strong) NSArray *childControllers;    // 子视图控制器
@property (nonatomic, strong) NSMutableArray *downFinished; // 是否请求过网络请求

@end

@implementation ShuoKanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BACK_WHITE;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - Page menu controller data source

- (NSArray *)addChildControllersToPageMenu
{
    LatestVC * latestVC = [[LatestVC alloc] init];
    HotestVC * hotestVC = [[HotestVC alloc] init];
    latestVC.title = @"最新";
    hotestVC.title = @"最热";
    self.childControllers = [[NSMutableArray alloc] initWithArray:@[latestVC, hotestVC]];
    
    return self.childControllers;
}

- (NSDictionary *)setupPageMenuWithOptions
{
    NSDictionary *options = @{
      DZROptionMenuHeight: @(64),
      DZROptionItemWidth: @(60.0),
      DZROptionIndicatorWidth: @(35.0),
      DZROptionIndicatorHeight: @(2.0),
      DZROptionItemTopMargin: @(20.0),
      DZROptionIndicatorTopToItem: @(50.0),
      DZROptionItemsSpace: @(0.0),
      DZROptionMenuColor: COLOR_PINK,
      DZROptionControllersScrollViewColor: COLOR_BACK_WHITE,
      DZROptionSelectorItemTitleColor: [UIColor whiteColor],
      DZROptionUnselectorItemTitleColor: TEXT_GRAD_COLOR,
      DZROptionIndicatorColor: [UIColor whiteColor],
      DZROptionItemsCenter: @(YES),
      DZROptionCanBounceHorizontal: @(YES),
      DZROptionIndicatorNeedToCutTheRoundedCorners: @(YES)
    };
    
    return options;
}

#pragma mark - Page menu controller delegate

- (void)pageMenu:(UIViewController *)pageMenu willMoveTheChildController:(UIViewController *)childController atIndexPage:(NSInteger)indexPage
{
    
}

- (void)pageMenu:(UIViewController *)pageMenu didMoveTheChildController:(UIViewController *)childController atIndexPage:(NSInteger)indexPage
{
    
    if ([self.downFinished[0] boolValue] == NO && indexPage == 0) {
        LatestVC *vc = self.childControllers[indexPage];
        [vc downloadData];
        [self.downFinished replaceObjectAtIndex:indexPage withObject:@(YES)];
    } else if ([self.downFinished[1] boolValue] == NO && indexPage == 1) {
        HotestVC *vc = self.childControllers[indexPage];
        [vc downloadData];
        [self.downFinished replaceObjectAtIndex:indexPage withObject:@(YES)];
    }
}

@end
