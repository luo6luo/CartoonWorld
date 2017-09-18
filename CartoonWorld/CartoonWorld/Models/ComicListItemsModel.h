//
//  ComicListItemsModel.h
//  二次元境
//
//  Created by 顿顿 on 16/4/6.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComicListItemsModel : NSObject

@property (nonatomic ,assign) NSInteger accredit;
@property (nonatomic ,strong) NSString * chapter_num;
@property (nonatomic ,assign) NSInteger comic_id;
@property (nonatomic ,strong) NSString * cover;
@property (nonatomic ,strong) NSString * myDescription;
@property (nonatomic ,assign) NSInteger is_dujia;
@property (nonatomic ,strong) NSString * is_vip;
@property (nonatomic ,strong) NSString * last_update_chapter_id;
@property (nonatomic ,strong) NSString * last_update_chapter_name;
@property (nonatomic ,assign) NSInteger last_update_time;
@property (nonatomic ,strong) NSString * name;
@property (nonatomic ,strong) NSString * nickname;
@property (nonatomic ,strong) NSString * series_status;
@property (nonatomic ,strong) NSString * theme_ids;
@property (nonatomic ,assign) NSInteger user_id;

@end
