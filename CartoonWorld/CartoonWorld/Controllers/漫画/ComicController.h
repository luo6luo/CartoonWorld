//
//  ComicController.h
//  CartoonWorld
//
//  Created by dundun on 2017/7/3.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ComicModel;

@interface ComicController : UIViewController

@property (nonatomic, assign) NSInteger comicId;

// 由于使用easyMock后，无论传入的 comicId 是多少，请求下来的都是统一数据
// 所以暂时把下列 model 作为收藏数据
// 真实动态获取数据的情况下，是不需要的
@property (nonatomic, strong) ComicModel *model;

@end
