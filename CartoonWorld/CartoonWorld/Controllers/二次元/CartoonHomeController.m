//
//  ErCiYuanViewController.m
//  二次元境
//
//  Created by HecH on 15-11-18.
//  Copyright (c) 2015年 CK. All rights reserved.
//

#import "CartoonHomeController.h"
#import "RecommendController.h"
#import "VIPController.h"
#import "SubscriptionController.h"

@interface CartoonHomeController ()

@property (nonatomic, strong) NSArray *childControllers;    // 子视图控制器

@end

@implementation CartoonHomeController

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
    UICollectionViewFlowLayout *recommendFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    RecommendController * recommendVC = [[RecommendController alloc] initWithCollectionViewLayout:recommendFlowLayout];
    recommendVC.title = @"推荐";
    
    UICollectionViewFlowLayout *VIPFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    VIPController * vipVC = [[VIPController alloc] initWithCollectionViewLayout:VIPFlowLayout];
    vipVC.title = @"VIP";
    
    SubscriptionController *subscriptionVC = [[SubscriptionController alloc] initWithStyle:UITableViewStylePlain];
    subscriptionVC.title = @"订阅";
    
    self.childControllers = @[ recommendVC, vipVC, subscriptionVC];
    
    return self.childControllers;
}

- (NSDictionary *)setupPageMenuWithOptions
{
    NSDictionary *options = @{
      DZROptionMenuHeight: @(NAVIGATIONBAR_HEIGHT_V),
      DZROptionItemWidth: @(60.0),
      DZROptionIndicatorWidth: @(35.0),
      DZROptionIndicatorHeight: @(2.0),
      DZROptionItemTopMargin: @(STATUSBAR_HEIGHT),
      DZROptionIndicatorTopToMenu: @(STATUSBAR_HEIGHT + 30),
      DZROptionItemsSpace: @(0.0),
      DZROptionCurrentPage: @(0),
      DZROptionMenuColor: COLOR_PINK,
      DZROptionControllersScrollViewColor: COLOR_BACK_GRAY,
      DZROptionSelectorItemTitleColor: [UIColor whiteColor],
      DZROptionUnselectorItemTitleColor: COLOR_TEXT_UNSELECT,
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
    if (indexPage == 0) {
        RecommendController *vc = self.childControllers[indexPage];
        if (!vc.isFinishedDownload) {
            [RefreshManager Refreshing:vc.collectionView];
            vc.isFinishedDownload = YES;
        }
    } else if (indexPage == 1) {
        VIPController *vc = self.childControllers[indexPage];
        if (!vc.isFinishedDownload) {
            [RefreshManager Refreshing:vc.collectionView];
            vc.isFinishedDownload = YES;
        }
    } else {
        SubscriptionController *vc = self.childControllers[indexPage];
        if (!vc.isFinishedDownload) {
            [RefreshManager Refreshing:vc.tableView];
            vc.isFinishedDownload = YES;
        }
    }
}

@end
