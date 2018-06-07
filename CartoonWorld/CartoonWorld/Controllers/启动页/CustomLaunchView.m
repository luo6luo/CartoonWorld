//
//  CustomLaunchView.m
//  CartoonWorld
//
//  Created by dundun on 2018/6/7.
//  Copyright © 2018年 顿顿. All rights reserved.
//

static NSString *const kLaunched = @"isLaunched";

#import "CustomLaunchView.h"

@interface CustomLaunchView()

//

// 初次加载
@property (nonatomic, strong) UIScrollView *scrollPage;
@property (nonatomic, strong) NSArray *imageNames;

@end

@implementation CustomLaunchView

- (void)launchView
{
    self.backgroundColor = COLOR_WHITE;
    if ([GET_USER_DEFAULTS(kLaunched) boolValue]) {
        // 已经加载过
        [self setupSubviews];
    } else {
        // 使用初始启动页
        self.imageNames = @[@"1", @"2", @"3"];
        [self addSubview:self.scrollPage];
        SET_USER_DEFAULTS(@(YES), kLaunched);
    }
    
//    self.imageNames = @[@"1", @"2", @"3"];
//    [self addSubview:self.scrollPage];
}

# pragma mark - Launched

- (void)setupSubviews
{
    UIImageView *iconImage = [UIImageView imageViewWithFrame:CGRectMake(SCREEN_WIDTH/2.0f - 50, SCREEN_HEIGHT/3.0f, 100, 100) image:@"launchIcon"];
    [self addSubview:iconImage];
    UILabel *text = [UILabel labelWithText:@"欢迎来到二次元境yo" textColor:COLOR_TEXT_BLACK fontSize:17 textAlignment:NSTextAlignmentCenter];
    text.frame = CGRectMake(LEFT_RIGHT, iconImage.maxY + TOP_BOTTOM, SCREEN_WIDTH - 2*LEFT_RIGHT, LABEL_HEIGHT);
    [self addSubview:text];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.startToUseAppBlock) {
            self.startToUseAppBlock();
        }
    });
}

# pragma mark - First launch

- (UIView *)setupScrollContentWithTag:(NSInteger)tag
{
    NSInteger index = tag - 100;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * index, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    CGFloat scale = 1000.0f/750.0f;
    CGRect frame = CGRectMake(SCREEN_WIDTH/12.0f, SCREEN_WIDTH/5.0f, SCREEN_WIDTH * 5.0f/6.0f, SCREEN_WIDTH * 5.0f/6.0f * scale);
    UIImageView *imageView = [UIImageView imageViewWithFrame:frame image:self.imageNames[index]];
    imageView.layer.cornerRadius = 20;
    imageView.layer.masksToBounds = YES;
    [view addSubview:imageView];
    
    if (index == 2) {
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        startBtn.frame = CGRectMake((SCREEN_WIDTH - 150)/2.0f, imageView.maxY + 3 * TOP_BOTTOM, 150, HEIGHT_OF_BUTTON);
        [startBtn setTitle:@"来撩啊~~~" forState:UIControlStateNormal];
        [startBtn setTintColor:COLOR_WHITE];
        startBtn.backgroundColor = COLOR_PINK;
        startBtn.layer.cornerRadius = HEIGHT_OF_BUTTON/2.0f;
        startBtn.layer.masksToBounds = YES;
        [startBtn addTarget:self action:@selector(startToUseApp:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:startBtn];
    } else {
        UILabel *label = [UILabel labelWithText:@"Look!! ─=≡Σ(((つ•̀ω•́)つ 二次元小哥哥" textColor:COLOR_TEXT_BLACK fontSize:15 textAlignment:NSTextAlignmentCenter];
        label.frame = CGRectMake(LEFT_RIGHT, imageView.maxY + 3 * TOP_BOTTOM, SCREEN_WIDTH - 2*LEFT_RIGHT, LABEL_HEIGHT);
        [view addSubview:label];
    }
    
    return view;
}

- (void)startToUseApp:(UIButton *)sender
{
    if (self.startToUseAppBlock) {
        self.startToUseAppBlock();
    }
}

# pragma mark - Getter & Setter

- (UIScrollView *)scrollPage
{
    if (!_scrollPage) {
        _scrollPage = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollPage.pagingEnabled = YES;
        _scrollPage.showsHorizontalScrollIndicator = NO;
        _scrollPage.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT);
        
        UIView *firstView = [self setupScrollContentWithTag:100];
        [_scrollPage addSubview:firstView];
        
        UIView *secondView = [self setupScrollContentWithTag:101];
        [_scrollPage addSubview:secondView];
        
        UIView *thirdView = [self setupScrollContentWithTag:102];
        [_scrollPage addSubview:thirdView];
    }
    return _scrollPage;
}

@end
