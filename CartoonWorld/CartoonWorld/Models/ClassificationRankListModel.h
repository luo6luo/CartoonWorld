//
//  SearchClassificationModel.h
//  CartoonWorld
//
//  Created by dundun on 2017/10/26.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassificationRankListModel : NSObject

@property (nonatomic, strong) NSString *argName;
@property (nonatomic, assign) NSInteger argValue;
@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, strong) NSString *cover;    // 分类封面
@property (nonatomic, assign) NSInteger sortId;   // 分类id
@property (nonatomic, strong) NSString *sortName; // 分类名

@end
