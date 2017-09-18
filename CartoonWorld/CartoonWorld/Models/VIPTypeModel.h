//
//  VIPTypeModel.h
//  CartoonWorld
//
//  Created by dundun on 2017/6/23.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VIPTypeModel : NSObject

@property (nonatomic ,strong) NSString *argValue;
@property (nonatomic ,assign) BOOL canMore;             // 是否有更多
@property (nonatomic ,strong) NSString *descriptionStr; // 描述
@property (nonatomic ,strong) NSString *itemTitle;      // 分类名称
@property (nonatomic ,strong) NSString *titleIcon;      // 分类图标
@property (nonatomic, assign) NSInteger maxSize;        // 展示条数
@property (nonatomic ,strong) NSArray *comics;          // 需要展示的漫画

@end
