//
//  IntroductionModel.h
//  二次元境
//
//  Created by MS on 15/11/20.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "IntroductionModel.h"

@interface IntroductionModel : NSObject

@property (nonatomic ,assign) NSInteger accredit;
@property (nonatomic ,assign) NSInteger chapter_num;
@property (nonatomic ,strong) NSString * click_total;
@property (nonatomic ,assign) NSInteger comic_id;
@property (nonatomic ,strong) NSString * cover;
@property (nonatomic ,strong) NSString * myDescription;
@property (nonatomic ,strong) NSString * extraValue;
@property (nonatomic ,assign) NSInteger is_dujia;
@property (nonatomic ,assign) NSInteger is_free;
@property (nonatomic ,assign) NSInteger is_vip;
@property (nonatomic ,strong) NSString * last_update_chapter_id;
@property (nonatomic ,strong) NSString * last_update_chapter_name;
@property (nonatomic ,assign) NSInteger last_update_time;
@property (nonatomic ,strong) NSString * name;
@property (nonatomic ,strong) NSString * nickname;
@property (nonatomic ,strong) NSString * series_status;
@property (nonatomic ,strong) NSArray * tags;
@property (nonatomic ,strong) NSString * theme_ids;
@property (nonatomic ,assign) NSInteger user_id;

@end
