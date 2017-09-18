//
//  ComicController.m
//  CartoonWorld
//
//  Created by dundun on 2017/7/3.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "ComicController.h"
#import "ComicDetailController.h"
#import "ComicCatalogController.h"
#import "ComicCommentController.h"

#import "ComicHeadView.h"

#import "ComicInfoModel.h"
#import "ComicDetailModel.h"

#import <DZRPageMenuController.h>

typedef NS_ENUM(NSInteger, MainScrollDirection) {
    MainUp = 1,
    MainDown,
    MainOther
};

@interface ComicController ()<UIScrollViewDelegate, DZRPageMenuDelegate, DZRPageMenuDataSource>

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) ComicHeadView *headerView; // 作者（作品）详情
@property (nonatomic, strong) UIImageView *barImage;     // 导航栏背景视图
@property (nonatomic, strong) DZRPageMenuController *pageMenu;           // 菜单栏
@property (nonatomic, strong) ComicDetailController *detailController;   // 详情
@property (nonatomic, strong) ComicCatalogController *catalogController; // 目录
@property (nonatomic, strong) ComicCommentController *commentController; // 评论

// 数据
@property (nonatomic, strong) ComicDetailModel *detailModel;  // 漫画详情
@property (nonatomic, strong) ComicInfoModel *comicInfoModel; // 漫画总详情
@property (nonatomic, strong) NSArray *guessLikeModels; // 猜你喜欢模型
@property (nonatomic, strong) NSArray *chapterList;     // 目录列表
@property (nonatomic, strong) NSArray *otherWorks;      // 其他作品
@property (nonatomic, strong) NSArray *commentModels;   // 评论内容

@property (nonatomic, assign) NSInteger commentPage; // 评论页面
@property (nonatomic, assign) CGFloat lastOffsetY;   // 上次y轴偏移量
@property (nonatomic, assign) BOOL isUp;             // 菜单栏是否顶头
@property (nonatomic, assign) BOOL isScrolling;      // 判断是否正在滚动

// 此处判断几个网络请求是否加载完毕，不论成功与否
@property (nonatomic, assign) BOOL isFinishedLoadComicDetail;  // 漫画详情加载完毕
@property (nonatomic, assign) BOOL isFinishedLoadComicCatalog; // 漫画目录加载完毕
@property (nonatomic, assign) BOOL isFinishedLoadComicComment; // 漫画评论加载完毕
@property (nonatomic, assign) BOOL isFinishedLoadGuessLike;    // 漫画猜你喜欢加载完毕
@property (nonatomic, assign) BOOL isLoadFailure;              // 加载失败

@end

@implementation ComicController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COLOR_BACK_WHITE;
    self.isUp = NO;
    self.isScrolling = NO;
    
    self.barImage = self.navigationController.navigationBar.subviews.firstObject;
    
    self.lastOffsetY = 0;
    self.commentPage = -1;
    
    self.isFinishedLoadComicDetail = NO;
    self.isFinishedLoadComicCatalog = NO;
    self.isFinishedLoadComicComment = NO;
    self.isFinishedLoadGuessLike = NO;
    self.isLoadFailure = NO;
    
    [self loadComicData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setTranslucent:YES];
    self.barImage.alpha = 0;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
    [self.navigationController.navigationBar setTranslucent:NO];
    self.barImage.alpha = 1;
}

# pragma mark - Getter & Setter

- (ComicDetailController *)detailController
{
    if (!_detailController) {
        _detailController = [[ComicDetailController alloc] init];
        _detailController.title = @"详情";
    }
    return _detailController;
}

- (ComicCatalogController *)catalogController
{
    if (!_catalogController) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _catalogController = [[ComicCatalogController alloc] initWithCollectionViewLayout:layout];
        _catalogController.title = @"目录";
        
        WeakSelf(self);
        _catalogController.catalogScrollBlock = ^(CatalogScrollDirection direction) {
            if (direction == CatalogUp && !weakself.isUp) {
                // 上滑动
                weakself.mainScrollView.scrollEnabled = NO;
                weakself.isScrolling = YES;
                [UIView animateWithDuration:0.5 animations:^{
                    [weakself.mainScrollView setContentOffset:CGPointMake(0, HEIGHT_HEADER_COMICDETAIL - 64)];
                } completion:^(BOOL finished) {
//                    [weakself.navigationController.navigationBar setBackgroundImage:[weakself imageWithColor:[COLOR_PINK colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
                    weakself.barImage.alpha = 1;
                    weakself.mainScrollView.scrollEnabled = YES;
                    weakself.isScrolling = NO;
                    weakself.isUp = YES;
                }];
            } else if (direction == CatalogDown && weakself.isUp) {
                // 下滑动
                weakself.mainScrollView.scrollEnabled = NO;
                [UIView animateWithDuration:0.5 animations:^{
                    weakself.barImage.alpha = 0;;
                    [weakself.mainScrollView setContentOffset:CGPointMake(0, 0)];
                } completion:^(BOOL finished) {
                    weakself.isScrolling = NO;
                    weakself.mainScrollView.scrollEnabled = YES;
                    weakself.isUp = NO;
                }];
            }
        };
    }
    return _catalogController;
}

- (ComicCommentController *)commentController
{
    if (!_commentController) {
        _commentController = [[ComicCommentController alloc] init];
        _commentController.title = @"评论";
    }
    return _commentController;
}

- (void)setIsUp:(BOOL)isUp
{
    _isUp = isUp;
    
    self.catalogController.mainViewIsUp = isUp;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *imgae = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgae;
}

# pragma mark - Download data

- (void)loadComicData
{
    [AlertManager showLoading];
    
    WeakSelf(self);
    
    // 加载详情
    [[NetWorkingManager defualtManager] comicDetailWitComicID:self.comicId success:^(id responseBody) {
        weakself.detailModel = responseBody;
        
        weakself.isFinishedLoadComicDetail = YES;
        [weakself loadSuccess];
    } failure:^(NSError *error) {
        weakself.isFinishedLoadComicDetail = YES;
        
        weakself.isLoadFailure = YES;
        [weakself loadFailure];
    }];
    
    // 加载目录
    [[NetWorkingManager defualtManager] comicCatalogWithcomicID:self.comicId success:^(id responseBody) {
        weakself.comicInfoModel = responseBody[@"comicInfoModel"];
        weakself.chapterList = responseBody[@"chapterList"];
        weakself.otherWorks = responseBody[@"otherWorks"];
        
        
        // 加载评论
        [[NetWorkingManager defualtManager] comicCommentWithComicID:weakself.comicId page:weakself.commentPage threadID:weakself.comicInfoModel.thread_id success:^(id responseBody) {
            weakself.commentModels = responseBody[@"data"];
            
            weakself.isFinishedLoadComicComment = YES;
            [weakself loadSuccess];
        } failure:^(NSError *error) {
            weakself.isFinishedLoadComicComment = YES;
            weakself.isLoadFailure = YES;
            [weakself loadFailure];
        }];
        
        weakself.title = weakself.comicInfoModel.name;
        weakself.isFinishedLoadComicCatalog = YES;
        [weakself loadSuccess];
    
    } failure:^(NSError *error) {
        weakself.isFinishedLoadComicCatalog = YES;
        weakself.isLoadFailure = YES;
        [weakself loadFailure];
    }];
    
    // 猜你喜欢
    [[NetWorkingManager defualtManager] comicGuessLikeWithComicID:self.comicId success:^(id responseBody) {
        weakself.guessLikeModels = responseBody;
        
        weakself.isFinishedLoadGuessLike = YES;
        [weakself loadSuccess];
    } failure:^(NSError *error) {
        weakself.isFinishedLoadGuessLike = YES;
        weakself.isLoadFailure = YES;
        [weakself loadFailure];
    }];
}

// 加载成功
- (void)loadSuccess
{
    if (self.isFinishedLoadComicDetail &&
        self.isFinishedLoadComicCatalog &&
        self.isFinishedLoadComicComment &&
        self.isFinishedLoadGuessLike) {
        
        [self setupSubviews];
        [AlertManager dismissLoadingWithstatus:ShowSuccess];
    }
}

// 加载失败
- (void)loadFailure
{
    if (self.isFinishedLoadComicDetail &&
        self.isFinishedLoadComicCatalog &&
        self.isFinishedLoadComicComment &&
        self.isFinishedLoadGuessLike &&
        self.isLoadFailure) {
        
        [self setupSubviews];
        [AlertManager dismissLoadingWithstatus:ShowFailure];
    }
}

# pragma mark - Set up

- (void)setupSubviews
{
    // 背景主视图
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mainScrollView.backgroundColor = COLOR_BACK_WHITE;
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + HEIGHT_HEADER_COMICDETAIL);
    self.mainScrollView.scrollEnabled = NO;
    self.mainScrollView.bounces = NO;
    self.mainScrollView.delegate = self;
    [self.view addSubview:self.mainScrollView];
    
    // 头视图
    self.headerView = [[ComicHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_HEADER_COMICDETAIL)];
    self.headerView.comicInfoModel = self.comicInfoModel;
    self.headerView.detailModel = self.detailModel;
    [self.mainScrollView addSubview:self.headerView];
    
    // 菜单项
    self.pageMenu = [[DZRPageMenuController alloc] initWithFrame:CGRectMake(0, HEIGHT_HEADER_COMICDETAIL, SCREEN_WIDTH, SCREEN_HEIGHT - 64) delegate:self];
    [self.mainScrollView addSubview:self.pageMenu.view];
}

# pragma mark - Page menu datasource

- (NSDictionary *)setupPageMenuWithOptions
{
    NSDictionary *options = @{
      DZROptionItemTitleFont: @(FONT_SUBTITLE),
      DZROptionMenuHeight: @(44.0),
      DZROptionItemWidth: @(70.0),
      DZROptionIndicatorWidth: @(35.0),
      DZROptionIndicatorHeight: @(2.0),
      DZROptionItemTopMargin: @(10.0),
      DZROptionItemBottomMargin: @(5),
      DZROptionIndicatorTopToItem: @(35.0),
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

- (NSArray *)addChildControllersToPageMenu
{
    // 详情
    self.detailController.comicInfoModel = self.comicInfoModel;
    self.detailController.detailModel = self.detailModel;
    self.detailController.guessLikeModels = self.guessLikeModels;
    
    // 目录
    self.catalogController.dataArr = self.chapterList;
    self.catalogController.mainViewIsUp = self.isUp;
    
    // 评论
    
    return @[self.detailController, self.catalogController, self.commentController];
}

# pragma mark - Page delegate

- (void)pageMenu:(UIViewController *)pageMenu willMoveTheChildController:(UIViewController *)childController atIndexPage:(NSInteger)indexPage
{
    
}

- (void)pageMenu:(UIViewController *)pageMenu didMoveTheChildController:(UIViewController *)childController atIndexPage:(NSInteger)indexPage
{
    
}

@end
