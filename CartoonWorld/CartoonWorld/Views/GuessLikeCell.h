//
//  GuessLickCellCell.h
//  CartoonWorld
//
//  Created by dundun on 2017/9/6.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GuessLikeModel;

@interface GuessLikeCell : UITableViewCell

@property (nonatomic, strong) NSArray *guesLikeModels;

@property (nonatomic, copy) void(^firstImageClickedBlock)(GuessLikeModel *model);
@property (nonatomic, copy) void(^secondImageClickedBlock)(GuessLikeModel *model);
@property (nonatomic, copy) void(^thirdImageClickedBlock)(GuessLikeModel *model);
@property (nonatomic, copy) void(^fourthImageClickedBlock)(GuessLikeModel *model);

@end
