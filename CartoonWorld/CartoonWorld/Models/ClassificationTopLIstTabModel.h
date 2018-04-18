//
//  ClassificationTopLIstTabModel.h
//  CartoonWorld
//
//  Created by dundun on 2017/11/1.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassificationTopLIstTabModel : NSObject

@property (nonatomic ,strong) NSString *argName;  // 标签类型
@property (nonatomic ,assign) NSInteger argCon;   // 标签配置
@property (nonatomic ,assign) NSInteger argValue; // 标签值
@property (nonatomic, strong) NSString *tabTitle; // 标签标题

@end
