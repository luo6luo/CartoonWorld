//
//  RefreshManager.m
//  CartoonWorld
//
//  Created by dundun on 2017/6/23.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "RefreshManager.h"
#import <MJRefresh.h>

@interface RefreshManager()

@property (nonatomic, strong) NSMutableArray *headerImages;
@property (nonatomic, strong) NSMutableArray *footerImages;

@end

@implementation RefreshManager

+ (instancetype)defaultRefresh
{
    static RefreshManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RefreshManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.headerImages = [NSMutableArray array];
        for (int i = 1; i < 5; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_header_annimation_%d",i]];
            [self.headerImages addObject:image];
        }
        
        self.footerImages = [NSMutableArray array];
        for (int i = 1; i < 9; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_footer_annimation_%d",i]];
            [self.footerImages addObject:image];
        }
    }
    return self;
}

// 下拉刷新
+ (void)pullDownRefreshInView:(UIScrollView *)scrollView targer:(id)target action:(SEL)action
{
    RefreshManager *maneger = [self defaultRefresh];
    if (!maneger || !scrollView) { return; }
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:action];
    [header setImages:@[maneger.headerImages.firstObject] forState:MJRefreshStateIdle];
    [header setImages:maneger.headerImages forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    scrollView.mj_header = header;
}

// 上拉刷新
+ (void)pullUpRefreshInView:(UIScrollView *)scrollView targer:(id)target action:(SEL)action
{
    RefreshManager *maneger = [self defaultRefresh];
    if (!maneger || !scrollView) { return; }
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:target refreshingAction:action];;
    [footer setImages:maneger.footerImages forState:MJRefreshStateRefreshing];
    footer.refreshingTitleHidden = YES;
    scrollView.mj_footer = footer;
}

// 开始刷新
+ (void)Refreshing:(UIScrollView *)scrollView
{
    [scrollView.mj_header beginRefreshing];
}

// 停止刷新
+ (void)stopRefreshInView:(UIScrollView *)scrollView
{
    if (scrollView) {
        [scrollView.mj_header endRefreshing];
        [scrollView.mj_footer endRefreshing];
    }
}

@end
