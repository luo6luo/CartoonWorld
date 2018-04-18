//
//  ActivityManager.h
//  CartoonWorld
//
//  Created by dundun on 2017/9/26.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityManager : NSObject

typedef NS_ENUM(NSInteger, ShowStatusStyle) {
    ShowSuccess = 0, // 显示成功状态
    ShowFailure      // 显示失败状态
};

#pragma mark - show

/**
 * 显示正在加载动画
 */
+ (void)showLoadingInView:(UIView *)supView;

#pragma mark - dismiss

/**取消加载*/
+ (void)dismissLoading;


/**
 * 取消正在加载动画
 *
 * @param status 显示状态
 */
+ (void)dismissLoadingInView:(UIView *)supView status:(ShowStatusStyle)status;

@end
