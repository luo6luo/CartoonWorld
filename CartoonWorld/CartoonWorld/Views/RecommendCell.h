//
//  RecommendCell.h
//  二次元境
//
//  Created by MS on 15/11/19.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ComicModel;

typedef NS_ENUM(NSInteger, CellType) {
    HorizontalCell = 0, // 横着的
    VerticalCell   = 1, // 竖着的
    OtherCell      = 2, // 没有描述的
    VIPCell        = 3, // vip
};

@interface RecommendCell : UICollectionViewCell

@property (nonatomic ,strong) id model;
@property (nonatomic ,assign) CellType cellType;

@end
