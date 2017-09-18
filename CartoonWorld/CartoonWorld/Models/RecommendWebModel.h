//
//  RecommendScrollModel.h
//  二次元境
//
//  Created by MS on 15/11/19.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import <Foundation/Foundation.h>


//红色字体的model
@interface RecommendWebModel : NSObject

@property (nonatomic ,strong) NSString * name;
//@property (nonatomic ,strong) Theme_ListModel * theme_listModel;
@property (nonatomic ,strong) NSArray * content_lists;
@property (nonatomic ,strong) NSArray * theme_list;
+ (RecommendWebModel *)modelWithDic:(NSDictionary *)dic;

@end



//绿色字体的model
@interface RecommendViewModel : NSObject

@property (nonatomic,strong) NSString * name;
//@property (nonatomic ,strong) ComicsModel * comicsModel;
@property (nonatomic ,strong) NSArray * content_lists;
@property (nonatomic ,strong) NSArray * theme_list;
@property (nonatomic ,strong) NSArray * comics;
+ (RecommendViewModel *)modelWithDic:(NSDictionary *)dic;

@end




//专辑model
@interface RecommendZJModel : NSObject

@property (nonatomic ,strong) NSString * name;
@property (nonatomic ,strong) NSArray * content_lists;
@property (nonatomic ,strong) NSArray * theme_list;
@property (nonatomic ,strong) NSArray * comics;
+ (RecommendZJModel *)modelWithDic:(NSDictionary *)dic;

@end





