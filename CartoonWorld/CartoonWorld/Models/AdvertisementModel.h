//
//  advertisementModel.h
//  二次元境
//
//  Created by 顿顿 on 16/4/6.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvertisementModel : NSObject

@property (nonatomic ,strong) NSString *content;  // 介绍
@property (nonatomic ,strong) NSString *cover;    // 展示图片
@property (nonatomic ,assign) NSInteger adID;     // 广告id
@property (nonatomic ,assign) NSInteger linkType; // 类型（2：网页，3：漫画）
@property (nonatomic ,strong) NSString *title;    // 广告标题
@property (nonatomic ,strong) NSArray *ext;       // 细节内容（网页url，漫画id）

@end
