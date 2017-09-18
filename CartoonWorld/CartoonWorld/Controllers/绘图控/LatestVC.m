//
//  LatestVC.m
//  二次元境
//
//  Created by MS on 15/11/23.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "LatestVC.h"

@interface LatestVC ()

@end

@implementation LatestVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.url = SSK_Latest_URL;
    [self downloadData];
}


@end
