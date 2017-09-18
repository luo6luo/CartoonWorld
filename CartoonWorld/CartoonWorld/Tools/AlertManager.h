//
//  AlertManager.h
//  二次元境
//
//  Created by dundun on 17/4/19.
//  Copyright © 2017年 MS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertManager : NSObject

typedef NS_ENUM(NSInteger, ShowStatusStyle) {
    ShowSuccess = 0, // 显示成功状态
    ShowFailure      // 显示失败状态
};

#pragma mark - show

/**
 * 显示提示信息
 *
 * @param text 显示提示信息    必填
 */
+ (void)showInfo:(NSString *)text;


/**
 * 显示正在加载动画
 */
+ (void)showLoading;

#pragma mark - dismiss

/**取消加载*/
+ (void)dismissLoading;


/**
 * 取消正在加载动画
 *
 * @param status 显示状态
 */
+ (void)dismissLoadingWithstatus:(ShowStatusStyle)status;

#pragma mark - alert

/**
 * 温馨提示弹框
 *
 * @param vc 需要弹出的控制器   必填
 * @param text 提示文字        必填
 */
+ (void)alerAddToController:(UIViewController *)vc text:(NSString *)text;

@end
