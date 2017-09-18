//
//  IntroductionModel.m
//  二次元境
//
//  Created by MS on 15/11/20.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "IntroductionModel.h"

@implementation IntroductionModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"myDescription":@"description"};
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
