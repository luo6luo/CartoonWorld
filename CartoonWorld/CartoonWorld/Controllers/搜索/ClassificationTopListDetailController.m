//
//  ClassificationTopListDetailController.m
//  CartoonWorld
//
//  Created by dundun on 2017/11/2.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "ClassificationTopListDetailController.h"
#import "ComicListController.h"

#import "ClassificationTopLIstTabModel.h"
#import "UIImageView+FindingView.h"

@interface ClassificationTopListDetailController ()

@property (nonatomic, strong) DZRPageMenuController *detailPageMenu;
@property (nonatomic, strong) NSMutableArray *childController;
@property (nonatomic, strong) NSMutableDictionary *childLoadedDataDic;
@property (nonatomic, strong) UIImageView *line; // 导航栏下的分割线

@end

@implementation ClassificationTopListDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BACK_WHITE;
    
    self.childController = [NSMutableArray array];
    self.childLoadedDataDic = [NSMutableDictionary dictionary];
    
    [self setupMenu];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 隐藏导航栏下面的线条
    self.line.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 显示导航栏下面的线条
    self.line.hidden = NO;
}

# pragma mark - Getter

- (UIImageView *)line
{
    if (!_line) {
        _line = [UIImageView findingSeparationLineWithView:self.navigationController.navigationBar];
    }
    return _line;
}

# pragma mark - Set up

- (void)setupMenu
{
    // 创建分页栏
    self.detailPageMenu = [[DZRPageMenuController alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) delegate:self];
    [self.view addSubview:self.detailPageMenu.view];
    
}

# pragma mark - Page menu data source

- (NSArray *)addChildControllersToPageMenu
{
    for (int i = 0; i < self.tapList.count; i++) {
        ClassificationTopLIstTabModel *model = self.tapList[i];
        ComicListController *comicListController = [[ComicListController alloc] init];
        comicListController.argName = model.argName;
        comicListController.argValue = model.argValue;
        comicListController.argCon = model.argCon;
        comicListController.title = model.tabTitle;
        [self.childController addObject:comicListController];
        
        [self.childLoadedDataDic setObject:@(NO) forKey:[NSString stringWithFormat:@"%d", i]];
    }
    return self.childController;
}

- (NSDictionary *)setupPageMenuWithOptions
{
    NSDictionary *options = @{
      DZROptionMenuHeight: @(40),
      DZROptionIndicatorWidth: @(55.0),
      DZROptionIndicatorHeight: @(2.0),
      DZROptionItemTopMargin: @(10),
      DZROptionItemWidth: @(70),
      DZROptionIndicatorTopToMenu: @(30),
      DZROptionItemsSpace: @(0.0),
      DZROptionCurrentPage: @(0),
      DZROptionMenuColor: COLOR_PINK,
      DZROptionControllersScrollViewColor: COLOR_BACK_GRAY,
      DZROptionSelectorItemTitleColor: COLOR_TEXT_WHITE,
      DZROptionUnselectorItemTitleColor: COLOR_TEXT_UNSELECT,
      DZROptionIndicatorColor: COLOR_TEXT_WHITE,
      DZROptionItemTitleFont: @(FONT_SUBTITLE),
      DZROptionItemsCenter: @(YES),
      DZROptionCanBounceHorizontal: @(YES),
      DZROptionIndicatorNeedToCutTheRoundedCorners: @(YES)
  };
    
    return options;
}

#pragma mark - Page menu controller delegate

- (void)pageMenu:(UIViewController *)pageMenu willMoveTheChildController:(UIViewController *)childController atIndexPage:(NSInteger)indexPage
{
    BOOL isLoadedData = [self.childLoadedDataDic[[NSString stringWithFormat:@"%ld", (long)indexPage]] boolValue];
    if (!isLoadedData) {
        // 加载数据
        ComicListController *childController = self.childController[indexPage];
        [RefreshManager Refreshing:childController.tableView];
        [self.childLoadedDataDic setValue:@(YES) forKey:[NSString stringWithFormat:@"%ld", (long)indexPage]];
    }
}

@end
