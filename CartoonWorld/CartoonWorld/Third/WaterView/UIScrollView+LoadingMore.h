//
//  UIScrollView+LoadingMore.h
//
//
//  Created by zhangbin on 14-6-13.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>

@interface UIScrollView (LoadingMore)

- (UIView *)loadingMoreWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector;

@end
