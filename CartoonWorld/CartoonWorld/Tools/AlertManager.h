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

/**
 * 显示提示信息
 *
 * @param text 显示提示信息    必填
 */
+ (void)showInfo:(NSString *)text;


/**
 * 温馨提示弹框
 *
 * @param vc 需要弹出的控制器   必填
 * @param text 提示文字        必填
 */
+ (void)alerAddToController:(UIViewController *)vc text:(NSString *)text;


/**
 * 两个按钮的提示框
 *
 * @param vc          需要弹出的控制器   必填
 * @param message     提示信息
 * @param sureBlock   确定
 * @param cancelBlock 取消
 */
+ (void)alerAddToController:(UIViewController *)vc
                    message:(NSString *)message
                       sure:(void(^)())sureBlock
                     cancel:(void(^)())cancelBlock;

@end
