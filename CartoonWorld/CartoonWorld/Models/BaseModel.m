//
//  BaseModel.m
//  二次元境
//
//  Created by MS on 15/11/22.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}

@end
