//
//  ClassificationTopListModel.h
//  CartoonWorld
//
//  Created by dundun on 2017/11/1.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassificationTopListModel : NSObject

@property (nonatomic, strong) NSString *cover;     // 封面
@property (nonatomic, strong) NSString *sortId;    // 分类id
@property (nonatomic, strong) NSString *sortName;  // 分类名称
@property (nonatomic, assign) NSInteger uiWeight;  // 内部分类个数
@property (nonatomic, strong) NSDictionary *extra; // 内部分类详情

@end
