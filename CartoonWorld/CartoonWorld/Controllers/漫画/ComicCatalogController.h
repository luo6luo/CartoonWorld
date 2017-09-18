//
//  ComicCatalogController.h
//  CartoonWorld
//
//  Created by dundun on 2017/7/7.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CatalogScrollDirection) {
    CatalogUp = 1,
    CatalogDown,
    CatalogOther
};

@interface ComicCatalogController : UICollectionViewController

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, assign) BOOL mainViewIsUp; // 主视图是否上滑动
@property (nonatomic, copy) void(^catalogScrollBlock)(CatalogScrollDirection direction); 

@end
