//
//  MoreOtherModel.m
//  CartoonWorld
//
//  Created by dundun on 2017/8/18.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "MoreTopicModel.h"
#import <MJExtension.h>

@implementation MoreTopicModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"descriptionStr": @"description"};
}

@end
