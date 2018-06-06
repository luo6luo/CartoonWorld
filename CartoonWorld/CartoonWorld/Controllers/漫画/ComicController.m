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
#import "CustomNavigationBar.h"

#import "ComicModel.h"
#import "UserModel.h"
#import "ComicInfoModel.h"
#import "ComicDetailModel.h"

#import "AnimationView.h"
#import "DatebaseManager.h"

#import <DZRPageMenuController.h>

@interface ComicController ()<UIScrollViewDelegate, DZRPageMenuDelegate, DZRPageMenuDataSource>

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) ComicHeadView *headerView; // 作者（作品）详情
@property (nonatomic, strong) CustomNavigationBar *navigationBar;        // 自定义导航栏
@property (nonatomic, strong) DZRPageMenuController *pageMenu;           // 菜单栏
@property (nonatomic, strong) ComicDetailController *detailController;   // 详情
@property (nonatomic, strong) ComicCatalogController *catalogController; // 目录
@property (nonatomic, strong) ComicCommentController *commentController; // 评论

@property (nonatomic, assign) NSInteger commentPage; // 评论页面
@property (nonatomic, assign) CGFloat lastOffsetY;   // 上次y轴偏移量
@property (nonatomic, assign) BOOL isUp;             // 菜单栏是否顶头
@property (nonatomic, assign) BOOL isScrolling;      // 判断是否正在滚动
@property (nonatomic, assign) BOOL isFavorite;       // 是否被收藏

// 数据
@property (nonatomic, strong) ComicDetailModel *detailModel;  // 漫画详情
@property (nonatomic, strong) ComicInfoModel *comicInfoModel; // 漫画总详情
@property (nonatomic, strong) NSArray *guessLikeModels; // 猜你喜欢模型
@property (nonatomic, strong) NSArray *chapterList;     // 目录列表
@property (nonatomic, strong) NSArray *otherWorks;      // 其他作品
@property (nonatomic, strong) NSArray *commentModels;   // 评论内容

// 此处判断几个网络请求是否加载完毕，不论成功与否
@property (nonatomic, assign) BOOL isFinishedLoadComicDetail;  // 漫画详情加载完毕
@property (nonatomic, assign) BOOL isFinishedLoadComicCatalog; // 漫画目录加载完毕
@property (nonatomic, assign) BOOL isFinishedLoadComicComment; // 漫画评论加载完毕
@property (nonatomic, assign) BOOL isFinishedLoadGuessLike;    // 漫画猜你喜欢加载完毕
@property (nonatomic, assign) BOOL isLoadFailure;              // 加载失败

// 判断是否为初次加载子视图
@property (nonatomic, strong) NSMutableDictionary *isFirstShow;

@end

@implementation ComicController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COLOR_BACK_WHITE;
    self.isUp = NO;
    self.isScrolling = NO;
    
    self.lastOffsetY = 0;
    self.commentPage = -1;
    
    self.isFinishedLoadComicDetail = NO;
    self.isFinishedLoadComicCatalog = NO;
    self.isFinishedLoadComicComment = NO;
    self.isFinishedLoadGuessLike = NO;
    self.isLoadFailure = NO;
    
    self.isFirstShow = [NSMutableDictionary dictionary];
    [self.isFirstShow setObject:@(NO) forKey:@"comment"];
    
    [self setupSubviews];
    [self loadComicData];
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

# pragma mark - Getter & Setter

- (ComicDetailController *)detailController
{
    if (!_detailController) {
        _detailController = [[ComicDetailController alloc] init];
        _detailController.rootController = self;
        _detailController.title = @"详情";
        
        WeakSelf(self);
        _detailController.scrollBlock = ^(ScrollDirection direction) {
            if (direction == ScrollUp && !weakself.isUp) {
                // 上滑动
                [weakself scrollToUp];
            } else if (direction == ScrollDown && weakself.isUp) {
                // 下滑动
                [weakself scrollToDown];
            }
        };
    }
    return _detailController;
}

- (ComicCatalogController *)catalogController
{
    if (!_catalogController) {
        _catalogController = [[ComicCatalogController alloc] init];
        _catalogController.rootController = self;
        _catalogController.title = @"目录";
        
        WeakSelf(self);
        _catalogController.scrollBlock = ^(ScrollDirection direction) {
            if (direction == ScrollUp && !weakself.isUp) {
                // 上滑动
                [weakself scrollToUp];
            } else if (direction == ScrollDown && weakself.isUp) {
                // 下滑动
                [weakself scrollToDown];
            }
        };
    }
    return _catalogController;
}

- (ComicCommentController *)commentController
{
    if (!_commentController) {
        _commentController = [[ComicCommentController alloc] init];
        _commentController.rootController = self;
        _commentController.title = @"评论";
        
        WeakSelf(self);
        _commentController.scrollBlock = ^(ScrollDirection direction) {
            if (direction == ScrollUp && !weakself.isUp) {
                // 上滑动
                [weakself scrollToUp];
            } else if (direction == ScrollDown && weakself.isUp) {
                // 下滑动
                [weakself scrollToDown];
            }
        };
    }
    return _commentController;
}

- (CustomNavigationBar *)navigationBar
{
    if (!_navigationBar) {
        BarType barType = self.model ? BarTypeMissingNone : BarTypeMissingRightBtn;
        _navigationBar = [[CustomNavigationBar alloc] initWithBarType:barType];
        ComicModel *model = [[DatebaseManager defaultDatebaseManager] checkObject:self.model Key:@"comicId" value:[NSString stringWithFormat:@"%ld",self.model.comicId]];
        if (model) {
            // 已经收藏
            _navigationBar.rightImageName = @"favorite";
            self.isFavorite = YES;
        } else {
            _navigationBar.rightImageName = @"unfavorite";
            self.isFavorite = NO;
        }
        
        // 点击左按钮
        WeakSelf(self);
        _navigationBar.leftBtnClickedBlock = ^{
            [weakself.navigationController popViewControllerAnimated:YES];
        };
        
        // 点击右按钮
        _navigationBar.rightBtnClickedBlock = ^{
            if (weakself.isFavorite) {
                // 从数据库删除
                [[DatebaseManager defaultDatebaseManager] deleteObject:weakself.model key:@"comicId" value:[NSString stringWithFormat:@"%ld",weakself.model.comicId] completed:^{
                    weakself.navigationBar.rightImageName = @"unfavorite";
                    weakself.isFavorite = NO;
                }];
            } else {
                CGFloat btnY = STATUSBAR_HEIGHT + (NAVIGATIONBAR_HEIGHT_V - STATUSBAR_HEIGHT)/2 - BTN_WIDHT_HEIGHT/2;
                CGRect endFrame = CGRectMake(SCREEN_WIDTH/2.0f - 30.f, weakself.view.height/3.0f, 60.f, 60.f);
                CGRect startFrame = CGRectMake(weakself.view.maxX - BTN_WIDHT_HEIGHT - BTN_LEFT_RIGHT, weakself.view.minY + btnY , BTN_WIDHT_HEIGHT, BTN_WIDHT_HEIGHT);
                [AnimationView animationWithImageName:@"big_favorite" atView:weakself.view startingFrame:startFrame endFrame:endFrame];
                
                // 写进数据库
                UserModel *user = [UserModel defaultUser];
                [[DatebaseManager defaultDatebaseManager] modifyObject:^{
                    // 存入数据库的是副本，避免删除后再访问
                    [user.favorites addObject:[weakself.model copy]];
                } completed:^{
                    weakself.navigationBar.rightImageName = @"favorite";
                    weakself.isFavorite = YES;
                }];
            }
        };
    }
    return _navigationBar;
}

- (void)setIsUp:(BOOL)isUp
{
    _isUp = isUp;
    
    // 通知子视图菜单栏的位置
    self.catalogController.mainViewIsUp = isUp;
    self.detailController.mainViewIsUp = isUp;
    self.commentController.mainViewIsUp = isUp;
}

# pragma mark - Up & Down

// 向上滑
- (void)scrollToUp
{
    self.mainScrollView.scrollEnabled = NO;
    self.isScrolling = YES;
    [UIView animateWithDuration:0.3 animations:^{
        // 注意：此处减去2个navigationBar高度，是因为 mainScrollView 的 初始y = 0
        // 实际偏移offsetY位置 = 初始y位置 - 移动距离
        // 即 0 - （HEIGHT_HEADER_COMICDETAIL - NAVIGATIONBAR_HEIGHT_V）
        [self.mainScrollView setContentOffset:CGPointMake(0, HEIGHT_HEADER_COMICDETAIL -  NAVIGATIONBAR_HEIGHT_V)];
    } completion:^(BOOL finished) {
        self.navigationBar.barAlpha = 1;
        self.mainScrollView.scrollEnabled = YES;
        self.isScrolling = NO;
        self.isUp = YES;
    }];
}

// 向下滑
- (void)scrollToDown
{
    self.mainScrollView.scrollEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self.mainScrollView setContentOffset:CGPointMake(0, 0)];
        self.navigationBar.barAlpha = 0;
    } completion:^(BOOL finished) {
        self.isScrolling = NO;
        self.mainScrollView.scrollEnabled = YES;
        self.isUp = NO;
    }];
}

# pragma mark - Download data

- (void)loadComicData
{
    [ActivityManager showLoadingInView:self.view];
    
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
        self.isFinishedLoadGuessLike) {
        
        // 配置详情界面参数
        self.detailController.comicInfoModel = self.comicInfoModel;
        self.detailController.detailModel = self.detailModel;
        self.detailController.guessLikeModels = self.guessLikeModels;
        self.detailController.otherWorkModels = self.otherWorks;
        self.detailController.mainViewIsUp = self.isUp;
        
        // 配置目录界面参数
        self.catalogController.dataArr = self.chapterList;
        self.catalogController.mainViewIsUp = self.isUp;
        
        // 配置评论界面的参数
        self.navigationBar.title = self.comicInfoModel.name;
        self.commentController.comicId = self.comicInfoModel.comic_id;
        self.commentController.thread_id = self.comicInfoModel.thread_id;
        
        [self setupData];
        [ActivityManager dismissLoadingInView:self.view status:ShowSuccess];
    }
}

// 加载失败
- (void)loadFailure
{
    if (self.isFinishedLoadComicDetail &&
        self.isFinishedLoadComicCatalog &&
        self.isFinishedLoadGuessLike &&
        self.isLoadFailure) {
        
        [self setupData];
        [ActivityManager dismissLoadingInView:self.view status:ShowFailure];
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
    self.mainScrollView.scrollsToTop = NO;
    self.mainScrollView.delegate = self;
    [self.view addSubview:self.mainScrollView];
    
    // 头视图
    self.headerView = [[ComicHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_HEADER_COMICDETAIL)];
    [self.mainScrollView addSubview:self.headerView];
    
    // 自定义导航栏
    [self.view addSubview:self.navigationBar];
    self.navigationBar.barAlpha = 0;
}

// 加载数据
- (void)setupData
{
    // 头视图
    self.headerView.comicInfoModel = self.comicInfoModel;
    self.headerView.detailModel = self.detailModel;
    
    // 菜单项
    self.pageMenu = [[DZRPageMenuController alloc] initWithFrame:CGRectMake(0, HEIGHT_HEADER_COMICDETAIL, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT_V) delegate:self];
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
      DZROptionIndicatorTopToMenu: @(35.0),
      DZROptionItemsSpace: @(0.0),
      DZROptionCurrentPage: @(0),
      DZROptionMenuColor: COLOR_PINK,
      DZROptionControllersScrollViewColor: COLOR_BACK_GRAY,
      DZROptionSelectorItemTitleColor: COLOR_WHITE,
      DZROptionUnselectorItemTitleColor: COLOR_TEXT_UNSELECT,
      DZROptionIndicatorColor: [UIColor whiteColor],
      DZROptionItemsCenter: @(YES),
      DZROptionCanBounceHorizontal: @(NO),
      DZROptionIndicatorNeedToCutTheRoundedCorners: @(YES)
    };
    
    return options;
}

- (NSArray *)addChildControllersToPageMenu
{
    return @[
      self.detailController,
      self.catalogController,
      self.commentController
    ];
}

# pragma mark - Page delegate

- (void)pageMenu:(UIViewController *)pageMenu willMoveTheChildController:(UIViewController *)childController atIndexPage:(NSInteger)indexPage
{
    if (![self.isFirstShow[@"comment"] boolValue]) {
        if (indexPage == 2 && childController == self.commentController) {
            [self.commentController loadNewCommentData];
            [self.isFirstShow setValue:@(YES) forKey:@"comment"];
        }
    }
}

@end
