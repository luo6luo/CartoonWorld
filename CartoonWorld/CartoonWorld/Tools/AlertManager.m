//
//  AlertManager.m
//  二次元境
//
//  Created by dundun on 17/4/19.
//  Copyright © 2017年 MS. All rights reserved.
//

#import "AlertManager.h"
#import <MBProgressHUD.h>

@interface AlertManager()

@property (nonatomic, strong) NSMutableArray *loadImages; // gif图片组
@property (nonatomic, strong) UIImageView *imageView;     // 显示的图片
@property (nonatomic, strong) UIView *backView;           // 显示的背景视图
@property (nonatomic, strong) UILabel *stateLabel;        // 状态文字

@end

@implementation AlertManager

+ (instancetype)shareManager
{
    static AlertManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[AlertManager alloc] init];
        }
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        // 背景视图
        self.backView = [[UIView alloc] init];
        
        // 动画&图片
        self.imageView = [[UIImageView alloc] init];
        self.imageView.frame = CGRectMake(0, 0, 100, 117);
        
        [self.backView addSubview:self.imageView];
        
        // 文字
        self.stateLabel = [UILabel labelWithText:@"" textColor:COLOR_PINK fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentCenter];
        self.stateLabel.font = [UIFont systemFontOfSize:FONT_CONTENT weight:3];
        self.stateLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame), 100, 25);
        [self.backView addSubview:self.stateLabel];
    }
    return self;
}

#pragma mark - getter

- (NSMutableArray *)loadImages
{
    if (!_loadImages) {
        _loadImages = [[NSMutableArray alloc] init];
        for (int i = 0; i < 10; i++) {
            NSString *imageName = [NSString stringWithFormat:@"loading_animation_%d",i];
            UIImage *image = [UIImage imageNamed:imageName];
            [_loadImages addObject:image];
        }
    }
    return _loadImages;
}

#pragma mark - show

// 显示提示信息
+ (void)showInfo:(NSString *)text
{
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    hub.mode = MBProgressHUDModeText;
    hub.animationType = MBProgressHUDAnimationZoom;
    hub.label.text = text;
    [hub hideAnimated:YES afterDelay:2.5];
}

// 显示正在加载动画（一般为首次开启页面时显示）
+ (void)showLoading
{
    AlertManager *manager = [self shareManager];
    if (!manager.backView) { return; }
    
    UIView *supView = [self currentView];
    supView.userInteractionEnabled = NO;
    
    CGFloat width = 100;
    CGFloat height = 117 + 25;
    CGFloat x = supView.frame.size.width/2 - width/2;
    CGFloat y = supView.frame.size.height/2 - height/2;
    manager.backView.frame = CGRectMake(x, y, width, height);
    
    manager.imageView.animationImages = manager.loadImages;
    manager.imageView.animationDuration = 2.0;
    manager.imageView.animationRepeatCount = 0;
    [manager.imageView startAnimating];
    
    manager.stateLabel.text = @"正在加载。。。";
    
    [supView addSubview:manager.backView];
}

#pragma mark - dismiss

// 取消加载动画
+ (void)dismissLoading
{
    AlertManager *manager = [self shareManager];
    if (!manager.backView) { return; }
    
    manager.backView.superview.userInteractionEnabled = YES;
    if (manager.imageView.isAnimating) {
        [manager.imageView stopAnimating];
    }
    [manager.backView removeFromSuperview];
}

// 取消正在加载的动画
+ (void)dismissLoadingWithstatus:(ShowStatusStyle)status
{
    AlertManager *manager = [self shareManager];
    if (!manager.backView) { return; }
    
    [manager.imageView stopAnimating];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (status == ShowSuccess) {
            manager.imageView.image = [UIImage imageNamed:@"success"];
            manager.stateLabel.text = @"加载成功";
        } else {
            manager.imageView.image = [UIImage imageNamed:@"failure"];
            manager.stateLabel.text = @"加载失败";
        }
        [manager.backView bringSubviewToFront:[self currentView]];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        manager.backView.superview.userInteractionEnabled = YES;
        [manager.backView removeFromSuperview];
    });
}

#pragma mark - alert

// 温馨提示弹框
+ (void)alerAddToController:(UIViewController *)vc text:(NSString *)text
{
    UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"温馨提示" message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [aler addAction:action];
    [vc presentViewController:aler animated:YES completion:nil];
}

# pragma mark - find current view controller

+ (UIView *)currentView
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentController = [self findCurrentViewControllerWithRootController:rootViewController];
    return currentController.view;
}

+ (UIViewController *)findCurrentViewControllerWithRootController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController) {
        return  [self findCurrentViewControllerWithRootController:rootViewController.presentedViewController];
    } else if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        if (tabBarController.viewControllers.count > 0) {
            return [self findCurrentViewControllerWithRootController:tabBarController.selectedViewController];
        } else {
            return rootViewController;
        }
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)rootViewController;
        if (navController.viewControllers.count > 0) {
            return [self findCurrentViewControllerWithRootController:navController.topViewController];
        } else {
            return rootViewController;
        }
    } else if ([rootViewController isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *splitController = (UISplitViewController *)rootViewController;
        if (splitController.viewControllers.count > 0) {
            return [self findCurrentViewControllerWithRootController:splitController.viewControllers.lastObject];
        } else {
            return rootViewController;
        }
    } else {
        return rootViewController;
    }
}

@end
