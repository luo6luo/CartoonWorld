//
//  BaseModel.h
//  二次元境
//
//  Created by MS on 15/11/22.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "BaseModel.h"

@interface BaseModel : NSObject

@property (nonatomic ,strong) NSString * best;
@property (nonatomic ,strong) NSString * changed_timestamp;
@property (nonatomic ,strong) NSString * comment_count;
@property (nonatomic ,strong) NSString * comment_floor;
@property (nonatomic ,strong) NSString * content;
@property (nonatomic ,assign) NSInteger create_timestr;
@property (nonatomic ,strong) NSString * created_at;
@property (nonatomic ,assign) NSInteger created_day;
@property (nonatomic ,strong) NSString * created_timestamp;
@property (nonatomic ,assign) NSInteger favorited;
@property (nonatomic ,strong) NSString * from;
@property (nonatomic ,strong) NSString * get_integral_count;
@property (nonatomic ,strong) NSString * give_integral_user_count;
@property (nonatomic ,strong) NSString * group_id;
@property (nonatomic ,strong) NSString * ID;
@property (nonatomic ,assign) NSInteger img_count;
@property (nonatomic ,assign) NSInteger inner_level;
@property (nonatomic ,assign) NSInteger level;
@property (nonatomic ,strong) NSString * main_all_comment_count;
@property (nonatomic ,strong) NSString * main_comment_count;
@property (nonatomic ,strong) NSString * main_comment_floor;
@property (nonatomic ,strong) NSString * p_app;
@property (nonatomic ,strong) NSString * p_app_version;
@property (nonatomic ,strong) NSString * page_view;
@property (nonatomic ,strong) NSString * tag_info;
@property (nonatomic ,strong) NSString * title;
@property (nonatomic ,strong) NSString * type;
@property (nonatomic ,strong) NSString * up_count;
@property (nonatomic ,assign) NSInteger upped;
@property (nonatomic ,strong) NSString * user_id;
@property (nonatomic ,strong) NSString * word_count;
@property (nonatomic ,strong) NSArray * tag;
@property (nonatomic ,strong) NSDictionary * user_info;

@end
