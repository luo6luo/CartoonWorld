//
//  ComicContentController.m
//  CartoonWorld
//
//  Created by dundun on 2018/4/12.
//  Copyright © 2018年 顿顿. All rights reserved.
//

#import "ComicContentController.h"
#import "AppDelegate.h"
#import "ReadScrollView.h"
#import "ReadMenuBar.h"

#import "ComicContentModel.h"

#define ANIMATION_DURATION  0.5

@interface ComicContentController ()<ReadMenuBarDelegate, ReadScrollViewDataSource>

@property (nonatomic, strong) ReadScrollView *scrollView; // 滚动视图
@property (nonatomic, strong) ReadMenuBar *menuBar; // 菜单栏

@property (nonatomic, strong) NSMutableDictionary *menuItemStatus; // 菜单栏中几个按钮的状态
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) BOOL isHiddenBar;

@end

@implementation ComicContentController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BAR_GRAY;
    
    [self setupSubviews];
    [self setupData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = COLOR_TOOL_BAR;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = COLOR_PINK;
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = 0;
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
}

# pragma mark - Getter

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
        _scrollView.dataSource = self;
        
        WeakSelf(self);
        _scrollView.touchScreenBlock = ^{
            __block CGRect navigationBarFrame = weakself.navigationController.navigationBar.frame;
            __block CGRect menuBarFrame = weakself.menuBar.frame;
            if (weakself.isHiddenBar && navigationBarFrame.origin.y == -(NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT) && menuBarFrame.origin.y == SCREEN_CONTENT_HEITH) {
                navigationBarFrame.origin.y += NAVIGATIONBAR_HEIGHT;
                menuBarFrame.origin.y -= HEIGHT_MENU_BAR;
                [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                    weakself.navigationController.navigationBar.frame = navigationBarFrame;
                    weakself.menuBar.frame = menuBarFrame;
                } completion:^(BOOL finished) {
                    weakself.isHiddenBar = NO;
                }];
            } else if (!weakself.isHiddenBar && navigationBarFrame.origin.y == STATUSBAR_HEIGHT && menuBarFrame.origin.y == SCREEN_CONTENT_HEITH - HEIGHT_MENU_BAR){
                navigationBarFrame.origin.y -= NAVIGATIONBAR_HEIGHT;
                menuBarFrame.origin.y += HEIGHT_MENU_BAR;
                [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                    weakself.navigationController.navigationBar.frame = navigationBarFrame;
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
      @"screen": @(ScreenOrientationTypeVertical),
      @"scroll": @(ScrollOrientationTypeVertical)
    };
    
    WeakSelf(self);
    [ActivityManager showLoadingInView:self.view];
    [[NetWorkingManager defualtManager] comicContentSuccess:^(id responseBody) {
        weakself.dataSource = responseBody;
        weakself.menuBar.maxPage = weakself.dataSource.count;
        [weakself.scrollView refreshImageData];
        [ActivityManager dismissLoadingInView:weakself.view status:ShowSuccess];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [ActivityManager dismissLoadingInView:weakself.view status:ShowFailure];
    }];
}

- (void)setupSubviews
{
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.menuBar];
}

# pragma mark - Read scroll view

- (NSInteger)numberOfImageInScrollView:(UIScrollView *)scrollView
{
    return self.dataSource.count;
}

- (NSString *)scrollView:(UIScrollView *)scrollView imageURLAtIndex:(NSInteger)index
{
    ComicContentModel *model = self.dataSource[index];
    return model.img05;
}

# pragma mark - Read menu bar delegare

- (void)button:(UIButton *)button clickedWithButtonType:(ButtonType)type isSelected:(BOOL)isSelected
{
    if (type == ButtonTypeLight) {
        // 开关灯
        
    } else if (type == ButtonTypeScreen) {
        // 横竖屏
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        ScreenOrientationType screen = [self.menuItemStatus[@"screen"] integerValue];
        if (screen == ScreenOrientationTypeVertical) {
            appDelegate.allowRotation = 1;
            [self.menuItemStatus setObject:@(ScreenOrientationTypeHorizontal) forKey:@"screen"];
        } else if (screen == ScreenOrientationTypeHorizontal) {
            appDelegate.allowRotation = 0;
            [self.menuItemStatus setObject:@(ScreenOrientationTypeVertical) forKey:@"screen"];
        }
        
        [self setupScreenRotationWithOrientation:screen];
        self.scrollView.screenType = screen;
        [self.menuBar relayoutSubviews];
    } else if (type == ButtonTypeBrightness) {
        // 亮度
        
    } else if (type == ButtonTypeScroll) {
        // 横竖滚动
        
    }
    
    NSLog(@"type: %ld", (long)type);
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
