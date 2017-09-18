//
//  RefreshManager.h
//  CartoonWorld
//
//  Created by dundun on 2017/6/23.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RefreshManager : NSObject

/**下拉刷新*/
+ (void)pullDownRefreshInView:(UIScrollView *)scrollView targer:(id)target action:(SEL)action;

/**上拉刷新*/
+ (void)pullUpRefreshInView:(UIScrollView *)scrollView targer:(id)target action:(SEL)action;

/**开始刷新*/
+ (void)Refreshing:(UIScrollView *)scrollView;

/**停止刷新*/
+ (void)stopRefreshInView:(UIScrollView *)scrollView;

@end
