//
//  ZhongErViewController.m
//  二次元境
//
//  Created by HecH on 15-11-18.
//  Copyright (c) 2015年 CK. All rights reserved.
//

#import "ZEDPageController.h"
#import "ZEDChildController.h"

@interface ZEDPageController ()

@property (nonatomic, strong) NSMutableArray *childControllers; // 子视图控制器
@property (nonatomic, strong) NSMutableArray *downFinished;     // 是否请求过网络请求

@end

@implementation ZEDPageController

- (void)viewDidLoad
{
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
    NSArray *urls = @[ ZED_Essence_URL, ZED_Colleague_URL, ZED_Source_URL, ZED_COS_URL, ZED_Debunk_URL ];
    NSArray *types = @[ @"精华", @"同人", @"资源", @"cos", @"吐槽" ];
    
    self.childControllers = [NSMutableArray array];
    for (int i = 0; i < urls.count; i++) {
        ZEDChildController * childController = [[ZEDChildController alloc] initWithType:types[i] url:urls[i]];
        childController.title = types[i];
        [self.childControllers addObject:childController];
    }
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
    if ([self.downFinished[indexPage] boolValue] == NO) {
        ZEDChildController *childController = self.childControllers[indexPage];
        [childController downloadData];
        [self.downFinished replaceObjectAtIndex:indexPage withObject:@(YES)];
    }
}

@end
