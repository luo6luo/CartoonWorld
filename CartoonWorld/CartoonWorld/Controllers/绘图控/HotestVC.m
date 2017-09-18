//
//  HotestVC.m
//  二次元境
//
//  Created by MS on 15/11/23.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "HotestVC.h"

@interface HotestVC ()

@end

@implementation HotestVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.url = SSK_Hotest_URL;
    [self downloadData];
}


@end
