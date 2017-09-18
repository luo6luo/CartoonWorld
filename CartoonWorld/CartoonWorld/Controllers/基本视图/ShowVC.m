//
//  ShowVC.m
//  二次元境
//
//  Created by MS on 15/11/29.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "ShowVC.h"

@interface ShowVC ()

@property (nonatomic ,strong) UIScrollView * scrollV;

@end

@implementation ShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_BACK_WHITE;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.hidden = YES;
    
    //图片所占高度
    CGFloat height = SCREEN_WIDTH * self.height/self.width;
    _scrollV = [[UIScrollView alloc] init];
//    DZRImageView * imageView = [[DZRImageView alloc] init];
//    if (height >= Screen_Size.height) {
//        _scrollV.frame = [[UIScreen mainScreen] bounds];
//        imageView.frame = CGRectMake(0, 0, Screen_Size.width, height);
//    }else {
//        _scrollV.frame = CGRectMake(0, Screen_Size.height/2 - height/2, Screen_Size.width, height);
//        imageView.frame = CGRectMake(0, 0, Screen_Size.width, height);
//    }
//    _scrollV.contentSize = CGSizeMake(Screen_Size.width, height);
//    _scrollV.backgroundColor = BACK_COLOR;
//    [self.view addSubview:_scrollV];
//    imageView.backgroundColor = BACK_COLOR;
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [imageView addTarget:self withSelector:@selector(touchesBeganWithImage:)];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:_url]];
//    [_scrollV addSubview:imageView];
}

//- (void)touchesBeganWithImage:(DZRImageView *)imageView {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    //隐藏TabBar
//    CGRect frame = self.tabBarController.tabBar.frame;
//    if (frame.origin.y == Screen_Size.height - HEIGHT_OF_TABBAR) {
//        frame.origin.y += HEIGHT_OF_TABBAR;
//        [UIView animateWithDuration:0.3 animations:^{
//            self.tabBarController.tabBar.frame = frame;
//        }];
//    }
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    //显示TabBar
//    CGRect frame = self.tabBarController.tabBar.frame;
//    if (frame.origin.y == Screen_Size.height) {
//        frame.origin.y -= HEIGHT_OF_TABBAR;
//        [UIView animateWithDuration:0.3 animations:^{
//            self.tabBarController.tabBar.frame = frame;
//        }];
//    }
//}

@end
