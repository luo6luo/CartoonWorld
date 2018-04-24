//
//  ReadScrollView.h
//  CartoonWorld
//
//  Created by dundun on 2018/4/12.
//  Copyright © 2018年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ComicContentModel;

@protocol ReadScrollViewDataSource <NSObject>

/**
 一共有几张图片

 @param scrollView 加载图片的滚动视图
 */
- (NSInteger)numberOfImageInScrollView:(UIScrollView *)scrollView;

/**
 设置图视图

 @param scrollView 加载图片的滚动视图
 @param index      图视图下标
 */
- (ComicContentModel *)scrollView:(UIScrollView *)scrollView imageModelAtIndex:(NSInteger)index;

@end

@protocol ReadScrollViewDelegate <NSObject>

/**
 当前页

 @param scrollView   加载图片的滚动视图
 @param currentIndex 当前下标
 */
- (void)scrollView:(UIScrollView *)scrollView scrollToCurrentIndex:(NSInteger)currentIndex;

@end

@interface ReadScrollView : UIScrollView

@property (nonatomic, weak) id<ReadScrollViewDataSource> readDataSource;
@property (nonatomic, weak) id<ReadScrollViewDelegate> readDelegate;
@property (nonatomic, assign) ScreenOrientationType screenType; // 屏幕方向类型
@property (nonatomic, assign) ScrollOrientationType scrollType; // 滚动方向类型
@property (nonatomic, copy) void(^touchScreenBlock)();    // 点击屏幕

// 刷新数据
- (void)reloadData;

@end
