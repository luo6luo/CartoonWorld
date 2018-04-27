//
//  ComicContentController.m
//  CartoonWorld
//
//  Created by dundun on 2018/4/12.
//  Copyright © 2018年 顿顿. All rights reserved.
//

#import "ComicContentController.h"
#import "AppDelegate.h"
#import "CustomNavigationBar.h"
#import "ReadScrollView.h"
#import "ReadMenuBar.h"

#import "ComicContentModel.h"

#define ANIMATION_DURATION  0.5

static NSString *const kScrollOrientation = @"scrollType";
static NSString *const kScreenOrientation = @"screenType";
static NSString *const kDeviceOrientation = @"orientation";


@interface ComicContentController ()<ReadMenuBarDelegate, ReadScrollViewDataSource, ReadScrollViewDelegate>

@property (nonatomic, strong) CustomNavigationBar *navigationBar; // 导航栏
@property (nonatomic, strong) ReadScrollView *scrollView; // 滚动视图
@property (nonatomic, strong) ReadMenuBar *menuBar; // 菜单栏

@property (nonatomic, strong) NSMutableDictionary *menuItemStatus; // 菜单栏中几个按钮的状态
@property (nonatomic, strong) NSArray *dataSource;

// 点击屏幕隐藏展示导航条和菜单条的相关属性
@property (nonatomic, assign) BOOL isHiddenBar;

@end

@implementation ComicContentController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BACK_COMIC_READ;
    
    [self setupSubviews];
    [self setupData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;
}

# pragma mark - Getter

- (CustomNavigationBar *)navigationBar
{
    if (!_navigationBar) {
        _navigationBar = [[CustomNavigationBar alloc] init];
        _navigationBar.title = self.title;
        _navigationBar.barColor = COLOR_TOOL_BAR;
        
        WeakSelf(self);
        _navigationBar.leftBtnClickedBlock = ^{
            // 返回显示竖屏
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.allowRotation = 0;
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:kDeviceOrientation];
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:kDeviceOrientation];
            
            [weakself.navigationController popViewControllerAnimated:YES];
        };
    }
    return _navigationBar;
}

- (ReadMenuBar *)menuBar
{
    if (!_menuBar) {
        _menuBar = [[ReadMenuBar alloc] init];
        _menuBar.delegate = self;
    }
    return _menuBar;
}

- (ReadScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[ReadScrollView alloc] init];
        _scrollView.readDataSource = self;
        _scrollView.readDelegate = self;
        
        WeakSelf(self);
        _scrollView.touchScreenBlock = ^{
            CGFloat navigationBarHeight = 0;
            ScreenOrientationType screenType = [weakself.menuItemStatus[kScreenOrientation] integerValue];
            if (screenType == ScreenOrientationTypeVertical) {
                navigationBarHeight = NAVIGATIONBAR_HEIGHT_V;
            } else if (screenType == ScreenOrientationTypeHorizontal) {
                navigationBarHeight = NAVIGATIONBAR_HEIGHT_H;
            }
            
            __block CGRect navigationBarFrame = weakself.navigationBar.frame;
            __block CGRect menuBarFrame = weakself.menuBar.frame;
            if (weakself.isHiddenBar && navigationBarFrame.origin.y == -navigationBarHeight  && menuBarFrame.origin.y == SCREEN_HEIGHT) {
                // 隐藏bar
                navigationBarFrame.origin.y += navigationBarHeight;
                menuBarFrame.origin.y -= HEIGHT_MENU_BAR;
                [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                    weakself.navigationBar.frame = navigationBarFrame;
                    weakself.menuBar.frame = menuBarFrame;
                } completion:^(BOOL finished) {
                    weakself.isHiddenBar = NO;
                }];
            } else if (!weakself.isHiddenBar && navigationBarFrame.origin.y == 0 && menuBarFrame.origin.y == SCREEN_HEIGHT - HEIGHT_MENU_BAR) {
                // 显示bar
                navigationBarFrame.origin.y -= navigationBarHeight;
                menuBarFrame.origin.y += HEIGHT_MENU_BAR;
                [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                    weakself.navigationBar.frame = navigationBarFrame;
                    weakself.menuBar.frame = menuBarFrame;
                } completion:^(BOOL finished) {
                    weakself.isHiddenBar = YES;
                }];
            }
        };
    }
    return _scrollView;
}

# pragma mark - set up

- (void)setupData
{
    self.isHiddenBar = NO;
    self.menuItemStatus = [NSMutableDictionary dictionary];
    self.menuItemStatus.dictionary = @{
      @"light": @(YES), // 默认开灯
      @"screen": @(ScreenOrientationTypeVertical), // 默认竖屏
      @"scroll": @(ScrollOrientationTypeVertical)  // 默认竖滑
    };
    
    WeakSelf(self);
    [ActivityManager showLoadingInView:self.view];
    [[NetWorkingManager defualtManager] comicContentSuccess:^(id responseBody) {
        weakself.dataSource = responseBody;
        weakself.menuBar.maxPage = weakself.dataSource.count;
        [weakself.scrollView reloadData];
        [ActivityManager dismissLoadingInView:weakself.view status:ShowSuccess];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [ActivityManager dismissLoadingInView:weakself.view status:ShowFailure];
    }];
}

- (void)setupSubviews
{
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.menuBar];
}

# pragma mark - Read scroll view

- (NSInteger)numberOfImageInScrollView:(UIScrollView *)scrollView
{
    return self.dataSource.count;
}

- (ComicContentModel *)scrollView:(UIScrollView *)scrollView imageModelAtIndex:(NSInteger)index
{
    ComicContentModel *model = self.dataSource[index];
    return model;
}

- (void)scrollView:(UIScrollView *)scrollView scrollToCurrentIndex:(NSInteger)currentIndex
{
    self.menuBar.currentPage = currentIndex;
}

# pragma mark - Read menu bar delegare

- (void)button:(UIButton *)button clickedWithButtonType:(ButtonType)type isSelected:(BOOL)isSelected
{
    if (type == ButtonTypeLight) {
        // 开关灯
        
    } else if (type == ButtonTypeScreen) {
        // 横竖屏
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        ScrollOrientationType scrollType = [self.menuItemStatus[kScrollOrientation] integerValue];
        ScreenOrientationType screen = [self.menuItemStatus[kScreenOrientation] integerValue];
        if (screen == ScreenOrientationTypeVertical) {
            if (scrollType == ScrollOrientationTypeHorizontal) {
                [AlertManager alerAddToController:self text:@"已经是横滑咯，不能再横屏啦~"];
            } else if (scrollType == ScrollOrientationTypeVertical) {
                appDelegate.allowRotation = 1;
                [self.menuItemStatus setObject:@(ScreenOrientationTypeHorizontal) forKey:kScreenOrientation];
            }
        } else if (screen == ScreenOrientationTypeHorizontal) {
            appDelegate.allowRotation = 0;
            [self.menuItemStatus setObject:@(ScreenOrientationTypeVertical) forKey:kScreenOrientation];
        }
        
        [self setupScreenRotationWithOrientation:screen];
        [self.navigationBar layoutSelfSubviews];
        [self.menuBar layoutSelfSubviews];
        self.scrollView.screenType = [self.menuItemStatus[kScreenOrientation] integerValue];
    } else if (type == ButtonTypeBrightness) {
        // 亮度
        
    } else if (type == ButtonTypeScroll) {
        // 横竖滚动
        ScreenOrientationType screenType = [self.menuItemStatus[kScreenOrientation] integerValue];
        ScrollOrientationType scrollType = [self.menuItemStatus[kScrollOrientation] integerValue];
        if (scrollType == ScrollOrientationTypeVertical) {
            if (screenType == ScreenOrientationTypeVertical) {
                [self.menuItemStatus setObject:@(ScrollOrientationTypeHorizontal) forKey:kScrollOrientation];
            } else if (screenType == ScreenOrientationTypeHorizontal) {
                // 横屏不能竖滑
                [AlertManager alerAddToController:self text:@"已经是横屏咯，不能再横滑啦~"];
            }
        } else if (scrollType == ScrollOrientationTypeHorizontal) {
            [self.menuItemStatus setObject:@(ScrollOrientationTypeVertical) forKey:kScrollOrientation];
        }
        self.scrollView.scrollType = [self.menuItemStatus[kScrollOrientation] integerValue];
    }
}

- (void)slider:(UISlider *)slider valueChanged:(NSInteger)newValue
{
    NSLog(@"第%ld页", (long)newValue);
}

# pragma mark - Screen rotation

// 设置屏幕旋转
- (void)setupScreenRotationWithOrientation:(ScreenOrientationType)type
{
    if (type == ScreenOrientationTypeVertical) {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    } else if (type == ScreenOrientationTypeHorizontal) {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }
}

@end
