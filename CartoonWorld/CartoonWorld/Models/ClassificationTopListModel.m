//
//  ClassificationTopListModel.m
//  CartoonWorld
//
//  Created by dundun on 2017/11/1.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "ClassificationTopListModel.h"
#import "ClassificationTopLIstTabModel.h"

@implementation ClassificationTopListModel

- (void)setExtra:(NSDictionary *)extra
{
    _extra = extra;
    _extra = @{@"tabList": [ClassificationTopLIstTabModel mj_objectArrayWithKeyValuesArray:self.extra[@"tabList"]]};
}

@end
