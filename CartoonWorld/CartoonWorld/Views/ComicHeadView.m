//
//  ComicHeadView.m
//  CartoonWorld
//
//  Created by dundun on 2017/7/10.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "ComicHeadView.h"
#import "ComicInfoModel.h"
#import "ComicDetailModel.h"

@interface ComicHeadView()

@property (nonatomic, strong) UIImageView *coverImage;   // 漫画封面
@property (nonatomic, strong) UILabel *comicName;        // 漫画名
@property (nonatomic, strong) UILabel *author;           // 作者
@property (nonatomic, strong) UILabel *shortDescription; // 描述
@property (nonatomic, strong) UILabel *clickTitle;       // 点击标题
@property (nonatomic, strong) UILabel *clickTotal;       // 点击总数
@property (nonatomic, strong) UILabel *favoriteTitle;    // 收藏标题
@property (nonatomic, strong) UILabel *favoriteTotal;    // 收藏总数
@property (nonatomic, strong) UILabel *tags;             // 标签

@end

@implementation ComicHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = COLOR_BACK_WHITE;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.layer.masksToBounds = YES;
        
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    // 毛玻璃
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = self.bounds;
    [self addSubview:visualEffectView];
    
    // 封面
    CGFloat coverImageHeight = VERTICAL_CELL_HEIGHT - LABEL_HEIGHT;
    self.coverImage = [UIImageView imageViewWithFrame:CGRectMake(LEFT_RIGHT, self.maxY - 2.5*TOP_BOTTOM - coverImageHeight, VERTICAL_CELL_WIDTH, coverImageHeight) image:nil];
    [self addSubview:self.coverImage];
    
    // 漫画名
    self.comicName = [UILabel labelWithText:nil textColor:COLOR_TEXT_WHITE fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentLeft];
    [self addSubview:self.comicName];
    CGFloat comicNameWidth = (SCREEN_WIDTH - 2*LEFT_RIGHT - VERTICAL_CELL_WIDTH)/2;
    [self.comicName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImage.mas_right).offset(LEFT_RIGHT);
        make.top.equalTo(self.coverImage);
        make.right.equalTo(self).offset(-LEFT_RIGHT);
        make.height.mas_equalTo(LABEL_HEIGHT);
    }];
    
    // 作者
    self.author = [UILabel labelWithText:nil textColor:COLOR_TEXT_WHITE fontSize:FONT_CONTENT textAlignment:NSTextAlignmentLeft];
    [self addSubview:self.author];
    [self.author mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.comicName);
        make.top.equalTo(self.comicName.mas_bottom);
    }];
    
    // 描述
    self.shortDescription = [UILabel labelWithText:nil textColor:COLOR_TEXT_WHITE fontSize:FONT_CONTENT textAlignment:NSTextAlignmentLeft];
    [self addSubview:self.shortDescription];
    [self.shortDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.comicName);
        make.height.mas_equalTo(LABEL_HEIGHT);
        make.top.equalTo(self.author.mas_bottom).offset(MIDDLE_SPASE);
    }];
    
    // 标签
    self.tags = [UILabel labelWithText:nil textColor:COLOR_TEXT_WHITE fontSize:FONT_CONTENT textAlignment:NSTextAlignmentLeft];
    [self addSubview:self.tags];
    [self.tags mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.comicName);
        make.height.mas_equalTo(LABEL_HEIGHT);
        make.bottom.equalTo(self.coverImage);
    }];
    
    // 点击标题
    self.clickTitle = [UILabel labelWithText:@"点击" textColor:COLOR_TEXT_WHITE fontSize:FONT_CONTENT textAlignment:NSTextAlignmentLeft];
    [self addSubview:self.clickTitle];
    [self.clickTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.comicName);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(LABEL_HEIGHT);
        make.bottom.equalTo(self.tags.mas_top).offset(-MIDDLE_SPASE);
    }];
    
    // 点击总数
    self.clickTotal = [UILabel labelWithText:nil textColor:COLOR_TEXT_ORANGE fontSize:FONT_CONTENT textAlignment:NSTextAlignmentLeft];
    [self addSubview:self.clickTotal];
    [self.clickTotal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.clickTitle.mas_right);
        make.width.mas_offset(60);
        make.height.mas_equalTo(LABEL_HEIGHT);
        make.bottom.equalTo(self.tags.mas_top).offset(-MIDDLE_SPASE);
    }];
    
    // 收藏标题
    self.favoriteTitle = [UILabel labelWithText:@"收藏" textColor:COLOR_TEXT_WHITE fontSize:FONT_CONTENT textAlignment:NSTextAlignmentLeft];
    [self addSubview:self.favoriteTitle];
    [self.favoriteTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.clickTotal.mas_right);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(LABEL_HEIGHT);
        make.bottom.equalTo(self.tags.mas_top).offset(-MIDDLE_SPASE);
    }];
    
    // 收藏总数
    self.favoriteTotal = [UILabel labelWithText:nil textColor:COLOR_TEXT_ORANGE fontSize:FONT_CONTENT textAlignment:NSTextAlignmentLeft];
    [self addSubview:self.favoriteTotal];
    [self.favoriteTotal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.favoriteTitle.mas_right);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(LABEL_HEIGHT);
        make.bottom.equalTo(self.tags.mas_top).offset(-MIDDLE_SPASE);
    }];
}

- (void)setComicInfoModel:(ComicInfoModel *)comicInfoModel
{
    _comicInfoModel = comicInfoModel;
    
    [self sd_setImageWithURL:[NSURL URLWithString:comicInfoModel.ori]];
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:comicInfoModel.cover]];
    self.comicName.text = comicInfoModel.name;
    self.author.text = comicInfoModel.author[@"name"];
    self.shortDescription.text = comicInfoModel.short_description;
    self.tags.text = [comicInfoModel.theme_ids componentsJoinedByString:@"  "];
}

- (void)setDetailModel:(ComicDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    self.clickTotal.text = detailModel.click_total;
    self.favoriteTotal.text = [NSString stringWithFormat:@"%.2f万",detailModel.favorite_total/10000.0];
}

@end
