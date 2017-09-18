//
//  BannerHeader.m
//  二次元境
//
//  Created by 顿顿 on 16/4/6.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "BannerHeader.h"
#import "advertisementModel.h"

#import <SDCycleScrollView.h>

@interface BannerHeader ()<SDCycleScrollViewDelegate>

@property (nonatomic ,strong) SDCycleScrollView *topScroll;

@end

@implementation BannerHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    self.topScroll = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AD_HEADER_HEIGHT) delegate:self placeholderImage:[UIImage imageNamed:@""]];
    [self addSubview:self.topScroll];
}

- (void)setAdModels:(NSArray *)adModels
{
    _adModels = adModels;
    
    NSMutableArray *imageURLArr = [NSMutableArray array];
    for (int i = 0; i < adModels.count; i++) {
        AdvertisementModel *adModel = adModels[i];
        NSString *imageUrlStr = adModel.cover ? adModel.cover : @"";
        [imageURLArr addObject:imageUrlStr];
    }
    self.topScroll.imageURLStringsGroup = imageURLArr;
}

# pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //滚动视图点进漫画
    self.selectedAdBlock(self.adModels[index]);
}

@end
