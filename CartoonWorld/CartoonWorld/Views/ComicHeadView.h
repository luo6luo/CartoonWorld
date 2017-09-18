//
//  ComicHeadView.h
//  CartoonWorld
//
//  Created by dundun on 2017/7/10.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ComicInfoModel;
@class ComicDetailModel;

@interface ComicHeadView : UIImageView

@property (nonatomic, strong) ComicInfoModel *comicInfoModel;
@property (nonatomic, strong) ComicDetailModel *detailModel;

@end
