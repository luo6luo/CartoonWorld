//
//  CustomNavigationBar.m
//  CartoonWorld
//
//  Created by dundun on 2017/10/10.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "CustomNavigationBar.h"

@interface CustomNavigationBar()

@property (nonatomic, strong) UIButton *leftBtn;      // 左按钮
@property (nonatomic, strong) UIButton *rightBtn;     // 右按钮
@property (nonatomic, strong) UILabel *titleLabel;    // 标题
@property (nonatomic, strong) UIView *backgroundView; // 背景图
@property (nonatomic, assign) BarType barType;        // 导航条样式

@end

@implementation CustomNavigationBar

- (instancetype)initWithBarType:(BarType)barType
{
    if (self = [super init]) {
        
        self.barType = barType;
        [self setupBar];
    }
    return self;
}

// 创建条内容
- (void)setupBar
{
    // 背景图
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = COLOR_PINK;
    [self addSubview:self.backgroundView];
    
    // 左按钮
    if (self.barType != BarTypeMissingLeftBtn && self.barType!= BarTypeMissingLeftAndRightBtn) {
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.leftBtn setImage:[[UIImage imageNamed:@"back_button"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.leftBtn];
    }
    
    // 右按钮
    if (self.barType != BarTypeMissingRightBtn && self.barType != BarTypeMissingLeftAndRightBtn) {
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rightBtn];
    }
    
    // 标题
    self.titleLabel = [UILabel labelWithText:@"" textColor:COLOR_WHITE fontSize:FONT_TITLE textAlignment:NSTextAlignmentCenter];
    [self addSubview:self.titleLabel];
    
    [self layoutSelfSubviews];
}

- (void)layoutSelfSubviews
{
    // 判断设备的方向
    CGFloat statusBaYHeight = 0;
    CGFloat navigationBarHeight = 0;
    if (SCREEN_HEIGHT > SCREEN_WIDTH) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT_V);
        statusBaYHeight = STATUSBAR_HEIGHT;
        navigationBarHeight = NAVIGATIONBAR_HEIGHT_V;
    } else if (SCREEN_WIDTH  > SCREEN_HEIGHT) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT_H);
        statusBaYHeight = 0;
        navigationBarHeight = NAVIGATIONBAR_HEIGHT_H;
    }
    
    // 背景
    self.backgroundView.frame = CGRectMake(self.minX, self.minY, SCREEN_WIDTH, self.height);
    
    // 左侧按钮
    CGFloat btnY = statusBaYHeight + (navigationBarHeight - statusBaYHeight)/2 - BTN_WIDHT_HEIGHT/2;
    if (self.barType != BarTypeMissingLeftBtn && self.barType!= BarTypeMissingLeftAndRightBtn) {
        self.leftBtn.frame = CGRectMake(self.minX + BTN_LEFT_RIGHT, self.minY + btnY , BTN_WIDHT_HEIGHT, BTN_WIDHT_HEIGHT);
    }
    
    // 右侧按钮
    if (self.barType != BarTypeMissingRightBtn && self.barType != BarTypeMissingLeftAndRightBtn) {
        self.rightBtn.frame = CGRectMake(self.maxX - BTN_WIDHT_HEIGHT - BTN_LEFT_RIGHT, self.minY + btnY , BTN_WIDHT_HEIGHT, BTN_WIDHT_HEIGHT);
    }
    
    // 标题
    CGFloat titleWidth = SCREEN_WIDTH - 2*BTN_WIDHT_HEIGHT - 2*BTN_LEFT_RIGHT - 2*MIDDLE_SPASE;
    self.titleLabel.frame = CGRectMake(self.leftBtn.maxX + MIDDLE_SPASE, self.minY + btnY, titleWidth, TITLE_HEIGHT);
}

# pragma mark - Event response

// 点击左边按钮
- (void)leftBtnClicked:(UIButton *)sender
{
    if (self.leftBtnClickedBlock && sender == self.leftBtn) {
        self.leftBtnClickedBlock();
    }
}

- (void)rightBtnClicked:(UIButton *)sender
{
    if (self.rightBtnClickedBlock && sender == self.rightBtn) {
        self.rightBtnClickedBlock();
    }
}

# pragma mark - Setter

// 标题
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

// 右按钮图片
- (void)setRightImageName:(NSString *)rightImageName
{
    _rightImageName = rightImageName;
    if (self.barType != BarTypeMissingRightBtn && self.barType != BarTypeMissingLeftAndRightBtn) {
        [self.rightBtn setImage:[[UIImage imageNamed:rightImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
}

// 透明度
- (void)setBarAlpha:(CGFloat)barAlpha
{
    _barAlpha = barAlpha;
    self.backgroundView.alpha = barAlpha;
}

// 背景视图颜色
- (void)setBarColor:(UIColor *)barColor
{
    _barColor = barColor;
    self.backgroundView.backgroundColor = barColor;
}

@end
