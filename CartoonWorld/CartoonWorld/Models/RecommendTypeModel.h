//
//  RecommendModel.h
//  二次元境
//
//  Created by MS on 15/11/20.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "RecommendTypeModel.h"

@interface RecommendTypeModel : NSObject

@property (nonatomic ,strong) NSString *argName;        // 分类参数名
@property (nonatomic ,assign) NSInteger argType;        // 分类参数类型值
@property (nonatomic ,assign) NSInteger argValue;       // 分类参数值
@property (nonatomic ,assign) NSInteger comicType;      // 漫画类型（3:条漫每日更新,5:专题,6:强力推荐作品,9:最新动画）
@property (nonatomic ,strong) NSString *descriptionStr; // 描述
@property (nonatomic ,strong) NSString *itemTitle;      // 分类名称
@property (nonatomic ,strong) NSString *titleIcon;      // 分类图标
@property (nonatomic ,strong) NSArray *comics;          // 需要展示的漫画

@end
