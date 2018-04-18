//
//  ComicBaseScrollView.h
//  CartoonWorld
//
//  Created by dundun on 2017/10/17.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ScrollDirection) {
    ScrollUp = 1,
    ScrollDown,
    ScrollOther
};

@interface ComicBaseScrollView : UIViewController <UIScrollViewDelegate>

// 主控制器 - 为了跳转
@property (nonatomic, strong) UIViewController *rootController;

// 主视图是否上滑动
@property (nonatomic, assign) BOOL mainViewIsUp;
@property (nonatomic, copy) void(^scrollBlock)(ScrollDirection direction);

@end
