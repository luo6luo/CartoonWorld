//
//  InformationModel.m
//  二次元境
//
//  Created by MS on 15/11/21.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "InformationModel.h"
#import "CoversModel.h"

@implementation InformationModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"covers":[CoversModel class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}

@end
