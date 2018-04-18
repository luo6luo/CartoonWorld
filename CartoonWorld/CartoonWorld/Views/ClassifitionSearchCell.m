//
//  SearchCell.m
//  CartoonWorld
//
//  Created by dundun on 2017/10/26.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "ClassifitionSearchCell.h"
#import "ClassificationRankListModel.h"
#import "ClassificationTopListModel.h"

@interface ClassifitionSearchCell()

@property (nonatomic, strong) UIImageView *classificationImage;
@property (nonatomic, strong) UILabel *classificationLabel;

@end

@implementation ClassifitionSearchCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = COLOR_WHITE;
        
        // 创建视图
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    CGFloat kCellWidth = (SCREEN_WIDTH - 4*LEFT_RIGHT) / 3;
    
    // 分类图标
    self.classificationImage = [[UIImageView alloc] init];
    self.classificationImage.contentMode = UIViewContentModeScaleAspectFit;
    self.classificationImage.frame = CGRectMake(0, 0, kCellWidth, HEIGHT_CELL_RANKLIST - 30);
    [self.contentView addSubview:self.classificationImage];
    
    // 分类名字
    self.classificationLabel = [UILabel labelWithText:nil textColor:COLOR_TEXT_BLACK fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentCenter];
    self.classificationLabel.frame = CGRectMake(0, kCellWidth, kCellWidth, 30);
    [self.contentView addSubview:self.classificationLabel];
}

- (void)setModel:(id)model
{
    _model = model;
    CGFloat kCellWidth = (SCREEN_WIDTH - 4*LEFT_RIGHT) / 3;
    
    if ([model isKindOfClass:[ClassificationRankListModel class]]) {
        self.classificationLabel.text = [model sortName];
        self.classificationImage.frame = CGRectMake(0, 0, kCellWidth, HEIGHT_CELL_RANKLIST - 30);
        self.classificationLabel.frame = CGRectMake(0, self.classificationImage.maxY, kCellWidth, 30);
    } else {
        self.classificationImage.frame = CGRectMake(0, 0, kCellWidth, HEIGHT_CELL_TOPLIST);
        self.classificationLabel.frame = CGRectMake(0, self.classificationImage.maxY, kCellWidth, 0);
    }
    [self.classificationImage sd_setImageWithURL:[NSURL URLWithString:[model cover]]];
}

@end
