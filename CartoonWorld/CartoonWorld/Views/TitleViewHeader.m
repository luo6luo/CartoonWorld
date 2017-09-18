//
//  TitleViewHeader.m
//  二次元境
//
//  Created by 顿顿 on 16/4/6.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "TitleViewHeader.h"
#import "RecommendTypeModel.h"
#import <UIImageView+WebCache.h>

@interface TitleViewHeader ()

@property (nonatomic ,strong) UIImageView *iconImage;
@property (nonatomic ,strong) UILabel *title;
@property (nonatomic ,strong) UIButton *moreBtn;

@end

@implementation TitleViewHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = CORNERRADIUS;
        self.layer.masksToBounds = YES;
        self.backgroundColor = COLOR_BACK_WHITE;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    //图标
    self.iconImage = [[UIImageView alloc] init];
    self.iconImage.layer.cornerRadius = ICON_HEIGHT/2;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LEFT_RIGHT);
        make.height.width.mas_equalTo(ICON_HEIGHT);
        make.centerY.equalTo(self);
    }];
    
    //标题
    self.title = [UILabel labelWithText:@"" textColor:TEXT_COLOR fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentLeft];
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(MIDDLE_SPASE);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, LABEL_HEIGHT));
    }];
    
    
    //更多按钮
    self.moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.moreBtn.backgroundColor = [RGBColor colorWithHexString:@"#EE6AA7"];
    self.moreBtn.layer.cornerRadius = 5;
    self.moreBtn.layer.masksToBounds = YES;
    [self.moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [self.moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_CONTENT];
    self.moreBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.moreBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.moreBtn];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-LEFT_RIGHT);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(MOREBTN_SIZE);
    }];
}

- (void)buttonClicked:(UIButton *)moreBtn
{
    if (self.isShow && self.moreBtnClickedBlock) {
        self.moreBtnClickedBlock();
    }
}

- (void)setTypeModel:(RecommendTypeModel *)typeModel
{
    _typeModel = typeModel;
    if (typeModel.titleIcon) {
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:typeModel.titleIcon]];
    }
    self.title.text = typeModel.itemTitle;
}

- (void)setIsShow:(BOOL)isShow
{
    _isShow = isShow;
    [self.moreBtn setHidden:!isShow];
}

@end
