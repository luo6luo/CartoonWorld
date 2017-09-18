//
//  BaseShowVC.m
//  二次元境
//
//  Created by MS on 15/12/2.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "BaseShowVC.h"
#import "ShowVC.h"

@interface BaseShowVC ()

@property (nonatomic ,strong) UIScrollView * scrollV;

@end

@implementation BaseShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACK_COLOR;
    self.title = @"图片展";
}

- (void)createUI {
    
    _scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, Screen_Size.width, Screen_Size.height - 64)];
    _scrollV.backgroundColor = BACK_COLOR;
    _scrollV.showsHorizontalScrollIndicator = NO;
    _scrollV.showsVerticalScrollIndicator = NO;
    _scrollV.alwaysBounceVertical = NO;
    _scrollV.pagingEnabled = YES;
    _scrollV.contentSize = CGSizeMake(Screen_Size.width * (_arr.count - 1), Screen_Size.height - 64);
    [self.view addSubview:_scrollV];
    
    for (int i =1; i < _arr.count; i ++) {
        DZRImageView * imageView = [[DZRImageView alloc] initWithFrame:CGRectMake(Screen_Size.width * (i - 1) , 0, Screen_Size.width, Screen_Size.height - 64)];
        [imageView addTarget:self withSelector:@selector(zhongErImageView:)];
        imageView.backgroundColor = BACK_COLOR;
        
        imageView.url = _arr[i][@"url"];
        imageView.width = _arr[i][@"w"];
        imageView.height = _arr[i][@"h"];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:_arr[i][@"url"]]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollV addSubview:imageView];
    }
}

- (void)zhongErImageView:(DZRImageView *)imageView {
    ShowVC * showVC = [[ShowVC alloc] init];
    showVC.url = imageView.url;
    showVC.width = [imageView.width integerValue];
    showVC.height = [imageView.height integerValue];
    self.hidesBottomBarWhenPushed = YES;
    [self presentViewController:showVC animated:YES completion:nil];
    self.hidesBottomBarWhenPushed = NO;
}


@end
