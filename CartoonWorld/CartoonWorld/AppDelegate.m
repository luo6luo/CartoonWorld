//
//  AppDelegate.m
//  CartoonWorld
//
//  Created by dundun on 2017/6/9.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "AppDelegate.h"
#import "StyleManager.h"
#import "DatebaseManager.h"
#import "CustomLaunchView.h"
#import "DZRRootTabBarController.h"

@interface AppDelegate ()

@property (nonatomic, strong) CustomLaunchView *launchView;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    DZRRootTabBarController * tab = [[DZRRootTabBarController alloc] init];
    self.window.rootViewController = tab;
    [self.window makeKeyAndVisible];
    
    // 设置启动页
    self.launchView = [[CustomLaunchView alloc] initWithFrame:self.window.bounds];
    [self.launchView launchView];
    [self.window addSubview:self.launchView];
    [self.window bringSubviewToFront:self.launchView];
    
    WeakSelf(self);
    self.launchView.startToUseAppBlock = ^{
        [UIView animateWithDuration:0.3 animations:^{
            weakself.launchView.alpha = 0.0;
            if ([GET_USER_DEFAULTS(@"isLaunched") boolValue]) {
                weakself.launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 2.0f, 2.0f, 1.0f);
            }
        } completion:^(BOOL finished) {
            [weakself.launchView removeFromSuperview];
            weakself.launchView = nil;
        }];
    };
    
    [StyleManager setStyle];
    [DatebaseManager migrationVersion];
    
    return YES;
}

// 系统发生
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (self.allowRotation) {
        return UIInterfaceOrientationMaskLandscapeLeft;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
