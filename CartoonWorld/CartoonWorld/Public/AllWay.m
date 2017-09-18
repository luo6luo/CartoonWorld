//
//  AllWay.m
//  二次元境
//
//  Created by MS on 15/11/27.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "AllWay.h"

@implementation AllWay

+ (NSTimeInterval)timeWithLastest:(NSString *)lastest_time
{
    NSDate * last_date = [NSDate dateWithTimeIntervalSince1970:[lastest_time integerValue]];
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:last_date];
    NSLog(@"%f",time);
    return time;
}

@end
