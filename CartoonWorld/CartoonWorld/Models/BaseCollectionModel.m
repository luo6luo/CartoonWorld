//
//  BaseCollectionModel.m
//  二次元境
//
//  Created by MS on 15/11/23.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "BaseCollectionModel.h"

@implementation BaseCollectionModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}

@end
