//
//  ComicDetailController.h
//  CartoonWorld
//
//  Created by dundun on 2017/7/7.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "ComicBaseScrollView.h"

@class ComicDetailModel;
@class ComicInfoModel;

@interface ComicDetailController : ComicBaseScrollView

// 数据
@property (nonatomic, strong) ComicInfoModel *comicInfoModel;
@property (nonatomic, strong) ComicDetailModel *detailModel;
@property (nonatomic, strong) NSArray *otherWorkModels;
@property (nonatomic, strong) NSArray *guessLikeModels;

@end
