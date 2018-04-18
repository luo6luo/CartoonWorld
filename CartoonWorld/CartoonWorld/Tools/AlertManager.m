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

@end

@implementation AlertManager

// 显示提示信息
+ (void)showInfo:(NSString *)text
{
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
    hub.mode = MBProgressHUDModeText;
    hub.animationType = MBProgressHUDAnimationZoom;
    hub.label.text = text;
    [hub hideAnimated:YES afterDelay:2.5];
}

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
