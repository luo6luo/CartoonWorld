//
//  ToolsManager.h
//  二次元境
//
//  Created by dundun on 17/4/12.
//  Copyright © 2017年 MS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ToolsManager : NSObject


/**
 判断客户端设备
 */
+ (BOOL)isPad;

/**
 判断设备方向
 */
+ (ScreenOrientationType)screenOrientation;

/**
 设置界面安全区域

 @param isShow navigationBar是否显示
 @return       设置好的安全区域
 */
+ (UIEdgeInsets)safeAreaInsetWithNavigationBar:(BOOL)isShow;

@end
