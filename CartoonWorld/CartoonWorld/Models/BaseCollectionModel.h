//
//  BaseCollectionModel.h
//  二次元境
//
//  Created by MS on 15/11/23.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "BaseCollectionModel.h"

@interface BaseCollectionModel : NSObject

@property (nonatomic ,assign) NSInteger comic_id;
@property (nonatomic ,strong) NSString * created_at;
@property (nonatomic ,assign) NSInteger ID;
@property (nonatomic ,strong) NSString * created_timestamp;
@property (nonatomic ,strong) NSString * introduce;
@property (nonatomic ,strong) NSString * size;
@property (nonatomic ,strong) NSString * type;
@property (nonatomic ,strong) NSString * up_count;
@property (nonatomic ,strong) NSNumber * uploaded_at;
@property (nonatomic ,strong) NSNumber * upped;
@property (nonatomic ,strong) NSString * user_id;
@property (nonatomic ,strong) NSDictionary * img;
@property (nonatomic ,strong) NSDictionary * user_info;

@end
