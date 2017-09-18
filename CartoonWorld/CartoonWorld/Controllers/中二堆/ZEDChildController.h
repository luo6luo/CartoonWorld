//
//  BaseVC.h
//  二次元境
//
//  Created by MS on 15/11/22.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZEDChildController : UIViewController


/**
 * 初始化方法
 *
 *  @param type 页面类型
 *  @param url 网络请求链接
 *
 *  @return 初始化成功的界面
 */
- (instancetype)initWithType:(NSString *)type url:(NSString *)url;

/**下载数据*/
- (void)downloadData;

@end
