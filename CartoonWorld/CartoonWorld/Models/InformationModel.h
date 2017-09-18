//
//  InformationModel.h
//  二次元境
//
//  Created by MS on 15/11/21.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "InformationModel.h"

@interface InformationModel : NSObject

@property (nonatomic ,strong) NSString * article_url;
@property (nonatomic ,strong) NSString * author_id;
@property (nonatomic ,strong) NSString * comment_count;
@property (nonatomic ,assign) NSInteger cover_type;
@property (nonatomic ,assign) NSInteger favorited;
@property (nonatomic ,strong) NSString * ID;
@property (nonatomic ,strong) NSString * online_timestamp;
@property (nonatomic ,strong) NSString * sub_title;
@property (nonatomic ,strong) NSString * title;
@property (nonatomic ,assign) NSInteger type;
@property (nonatomic ,assign) NSInteger up_count;
@property (nonatomic ,assign) NSInteger upped;
@property (nonatomic ,strong) NSDictionary * newsauthor_info;
@property (nonatomic ,strong) NSDictionary * newstype_info;
@property (nonatomic ,strong) NSArray * covers;


@end
