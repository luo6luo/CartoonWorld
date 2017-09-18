//
//  ReadVC.m
//  二次元境
//
//  Created by MS on 15/11/25.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "ReadVC.h"
//#import "DZRScrollView.h"
#import "ShowVC.h"
#import "AFNetworking.h"
#import "ReadModel.h"

@interface ReadVC ()
//<DZRScrollViewDataSource,DZRScrollViewDelegate>

//@property (nonatomic ,strong) DZRScrollView * readScrollView;
@property (nonatomic ,strong) NSMutableArray * dataArr;

@end

@implementation ReadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //开始下载
    [self downloadData];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)downloadData
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }else  {
        [_dataArr removeAllObjects];
    }
    
    [[NetWorkingManager defualtManager] readCortoonWithChapterId:self.chapter_id success:^(id responseBody) {
        self.dataArr.array = responseBody;
        //创建上面视图
        [self createScrollView];
        //取消活动指示器
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        //取消活动指示器
    }];
}

- (void)createScrollView
{
//    self.readScrollView = [[DZRScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Size.width, Screen_Size.height)];
//    self.readScrollView.dataSource = self;
//    self.readScrollView.viewdelegate = self;
//    self.readScrollView.backgroundColor = BACK_COLOR;
//    self.readScrollView.showsHorizontalScrollIndicator = NO;
//    //初始化数据
//    [self.readScrollView loadData];
//    [self.view addSubview:self.readScrollView];
}

- (UIView *)loadWithView
{
    UIScrollView * imageS = [[UIScrollView alloc] init];
    imageS.backgroundColor = COLOR_BACK_WHITE;
    return imageS;
}

- (NSUInteger)wholePages
{
    return _dataArr.count;
}

//- (void)scrollView:(DZRScrollView *)scrollView withSubView:(UIView *)subView atIndex:(NSUInteger)index
//{
//    UIScrollView * scrollImage = (UIScrollView *)subView;
//    scrollImage.contentOffset = CGPointMake(0, 0);
//    
//    //填充子视图
//    ReadModel * model = self.dataArr[index];
//    CGFloat height = Screen_Size.width * ([model.height floatValue] / [model.width floatValue]);
//    DZRImageView * imageView = [[DZRImageView alloc] init];
//    if (Screen_Size.height >= height) {
//        imageView.frame = CGRectMake(0, Screen_Size.height/2 - height/2, Screen_Size.width, height);
//    }else {
//        imageView.frame = CGRectMake(0, 0, Screen_Size.width, height);
//    }
//    scrollImage.contentSize = CGSizeMake(Screen_Size.width, height);
//    [imageView addTarget:self withSelector:@selector(imageViewClicked:)];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    imageView.backgroundColor = BACK_COLOR;
//    [imageView sd_setImageWithURL:[NSURL URLWithString:model.location] placeholderImage:[UIImage imageNamed:@"default_background"]];
//    [scrollImage addSubview:imageView];
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //隐藏navigation
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

//- (void)imageViewClicked:(DZRImageView *)imageView
//{
//    
//    if (self.navigationController.navigationBar.hidden == YES) {
//        //隐藏了
//        [self.navigationController setNavigationBarHidden:NO animated:NO];
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
//    }else {
//        //没有隐藏
//        [self.navigationController setNavigationBarHidden:YES animated:NO];
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    }
//}


@end
