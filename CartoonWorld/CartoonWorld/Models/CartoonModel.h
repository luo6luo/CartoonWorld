//
//  CartoonModel.h
//  二次元境
//
//  Created by MS on 15/11/25.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "CartoonModel.h"

@interface CartoonModel : NSObject

@property (nonatomic ,assign) NSInteger chapter_id;
@property (nonatomic ,strong) NSString * image_total;
@property (nonatomic ,assign) NSInteger is_free;
@property (nonatomic ,strong) NSString * name;
@property (nonatomic ,strong) NSString * pass_time;
@property (nonatomic ,strong) NSString * price;
@property (nonatomic ,strong) NSString * release_time;
@property (nonatomic ,strong) NSString * size;
@property (nonatomic ,strong) NSString * type;

@end
