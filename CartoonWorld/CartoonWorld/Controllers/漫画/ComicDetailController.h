//
//  ComicDetailController.h
//  CartoonWorld
//
//  Created by dundun on 2017/7/7.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ComicDetailModel;
@class ComicInfoModel;

@interface ComicDetailController : UITableViewController

@property (nonatomic, strong) ComicInfoModel *comicInfoModel;
@property (nonatomic, strong) ComicDetailModel *detailModel;
@property (nonatomic, strong) NSArray *guessLikeModels;

@end
