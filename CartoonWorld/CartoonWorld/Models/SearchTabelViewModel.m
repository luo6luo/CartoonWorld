//
//  SearchBaseModel.m
//  二次元境
//
//  Created by MS on 15/11/24.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "SearchTabelViewModel.h"

@implementation SearchTabelViewModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"myDescription":@"description"};
}

@end
