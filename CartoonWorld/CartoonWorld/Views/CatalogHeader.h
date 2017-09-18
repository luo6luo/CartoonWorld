//
//  CatalogHeader.h
//  CartoonWorld
//
//  Created by dundun on 2017/8/24.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CatalogModel;

@interface CatalogHeader : UICollectionReusableView

@property (nonatomic, strong) CatalogModel *model;
@property (nonatomic, copy) void(^sortBtnBlock)(BOOL isPositiveOrder);

@end
