//
//  BannerHeader.h
//  二次元境
//
//  Created by 顿顿 on 16/4/6.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AdvertisementModel;

@interface BannerHeader : UICollectionReusableView

@property (nonatomic ,strong) NSArray * adModels;
@property (nonatomic ,copy) void(^selectedAdBlock)(AdvertisementModel *adModel);

@end
