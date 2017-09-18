//
//  VIPTypeModel.m
//  CartoonWorld
//
//  Created by dundun on 2017/6/23.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "VIPTypeModel.h"
#import "ComicModel.h"

@implementation VIPTypeModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"descriptionStr": @"description", @"titleIcon": @"titleIconUrl"};
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"comics": [ComicModel class]};
}

@end
