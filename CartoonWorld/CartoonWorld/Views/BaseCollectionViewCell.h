//
//  BaseCollectionViewCell.h
//  二次元境
//
//  Created by MS on 15/11/23.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "ZBFlowView.h"
#import "BaseCollectionModel.h"

@protocol BaseCollectionViewCellDelegate <NSObject>

- (void)makeImageToBigWithURL:(NSString *)url andWidth:(NSInteger)width andHeight:(NSInteger)height;

@end

@interface BaseCollectionViewCell : ZBFlowView

@property (nonatomic ,strong) BaseCollectionModel * model;
@property (nonatomic ,weak) id<BaseCollectionViewCellDelegate> delegate;

@end
