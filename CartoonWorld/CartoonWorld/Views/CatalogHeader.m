//
//  CatalogHeader.m
//  CartoonWorld
//
//  Created by dundun on 2017/8/24.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "CatalogHeader.h"
#import "CatalogModel.h"

@interface CatalogHeader()

@property (nonatomic, strong) UILabel *title;       // 标题
@property (nonatomic, strong) UIButton *sortBtn;    // 排序按钮
@property (nonatomic, assign) BOOL isPositiveOrder; // 是否正序

@end

@implementation CatalogHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_BACK_WHITE;
        self.isPositiveOrder = YES;
        
        [self setupCatalogHeaderView];
    }
    return self;
}

- (void)setupCatalogHeaderView
{
    // 排序按钮
    CGRect btnFrame = CGRectMake(SCREEN_WIDTH - LEFT_RIGHT - ICON_HEIGHT, HEIGHT_HEADER_CATALOG/2 - ICON_HEIGHT/2, ICON_HEIGHT, ICON_HEIGHT);
    self.sortBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.sortBtn.frame = btnFrame;
    [self.sortBtn addTarget:self action:@selector(sortButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.sortBtn setImage:[UIImage imageNamed:@"sort_up"] forState:UIControlStateNormal];
    [self addSubview:self.sortBtn];
    
    // 标题
    self.title = [UILabel labelWithText:nil textColor:COLOR_TEXT_BLACK fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentLeft];
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LEFT_RIGHT);
        make.right.equalTo(self.sortBtn.mas_left);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(LABEL_HEIGHT);
    }];
}

- (void)sortButtonClicked:(UIButton *)button
{
    if (self.isPositiveOrder) {
        [self.sortBtn setImage:[UIImage imageNamed:@"sort_down"] forState:UIControlStateNormal];
        self.isPositiveOrder = NO;
    } else {
        [self.sortBtn setImage:[UIImage imageNamed:@"sort_up"] forState:UIControlStateNormal];
        self.isPositiveOrder = YES;
    }
    
    if (self.sortBtnBlock) {
        self.sortBtnBlock(self.isPositiveOrder);
    }
}

// 转换时间
- (NSString *)formatterDate:(NSInteger)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat  = @"yyyy-MM-dd";
    return [formatter stringFromDate:date];
}

- (void)setModel:(CatalogModel *)model
{
    _model = model;
    
    self.title.text = [NSString stringWithFormat:@"目录  %@ 更新    %@", [self formatterDate:model.pass_time], model.name];
}

@end
