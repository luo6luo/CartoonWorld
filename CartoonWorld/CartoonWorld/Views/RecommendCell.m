//
//  RecommendCell.m
//  二次元境
//
//  Created by MS on 15/11/19.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "RecommendCell.h"
#import "ComicModel.h"
#import "AdvertisementModel.h"
#import "OtherWorksModel.h"

@interface RecommendCell ()

@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic ,strong) UILabel *title;
@property (nonatomic ,strong) UILabel *update;

@end

@implementation RecommendCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.cornerRadius = CORNERRADIUS;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.cellWidth = 0.0;
        self.cellHeight = 0.0;
        
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(id)model
{
    if ([model isKindOfClass:[ComicModel class]]) {
        model = (ComicModel *)model;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[model cover]]];
        self.title.text = [model name];
        if ([model cornerInfo]) {
            self.update.text = [NSString stringWithFormat:@"最新章节%@",[model cornerInfo]];
        }
    } else if ([model isKindOfClass:[AdvertisementModel class]]) {
        model = (AdvertisementModel *)model;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[model cover]]];
        self.title.text = [model title];
        if ([model content]) {
            self.update.text = [NSString stringWithFormat:@"最新章节%@",[model content]];
        }
    } else if ([model isKindOfClass:[OtherWorksModel class]]) {
        model = (OtherWorksModel *)model;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[model coverUrl]]];
        self.title.text = [model name];
        if ([model passChapterNum]) {
            self.update.text = [NSString stringWithFormat:@"最新章节%ld", (long)[model passChapterNum]];
        }
    }
}

- (void)setCellType:(CellType)cellType
{
    _cellType = cellType;
    if (cellType == HorizontalCell) {
        self.cellWidth = HORIZONTAL_CELL_WIDTH;
        self.cellHeight = HORIZONTAL_CELL_HEIGHT;
    } else if (cellType == VerticalCell) {
        self.cellWidth = VERTICAL_CELL_WIDTH;
        self.cellHeight = VERTICAL_CELL_HEIGHT;
    } else if (cellType == OtherCell) {
        self.cellWidth = HORIZONTAL_CELL_WIDTH;
        self.cellHeight = HORIZONTAL_CELL_HEIGHT - 2*LABEL_HEIGHT;
    } else {
        self.cellWidth = VERTICAL_CELL_WIDTH;
        self.cellHeight = VERTICAL_CELL_HEIGHT - LABEL_HEIGHT;
    }
    
    [self layoutIfNeeded];
}

- (void)setupSubViews
{
    // 漫画封面
    self.imageView = [[UIImageView alloc] init];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.backgroundColor = COLOR_BACK_GRAY;
    [self.contentView addSubview:self.imageView];
    
    // 漫画标题
    self.title = [UILabel labelWithText:@"" textColor:COLOR_TEXT_BLACK fontSize:FONT_CONTENT textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.title];
    
    // 漫画最新章节
    self.update = [UILabel labelWithText:@"" textColor:COLOR_TEXT_BLACK fontSize:FONT_CONTENT textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.update];
}

- (void)layoutSubviews
{
    CGFloat titleHeight = 0.0;
    CGFloat updateHeight = 0.0;
    switch (self.cellType) {
        case HorizontalCell:
            titleHeight = LABEL_HEIGHT;
            updateHeight = LABEL_HEIGHT;
            break;
        case VerticalCell:
            titleHeight = LABEL_HEIGHT;
            updateHeight = LABEL_HEIGHT;
            break;
        case OtherCell:
            titleHeight = 0.0;
            updateHeight = 0.0;
            break;
        case VIPCell:
            titleHeight = LABEL_HEIGHT;
            updateHeight = 0.0;
            break;
        default:
            break;
    }

    self.imageView.frame = CGRectMake(0.0, 0.0, self.cellWidth, self.cellHeight - titleHeight - updateHeight);
    self.title.frame = CGRectMake(0.0, CGRectGetMaxY(self.imageView.frame), self.cellWidth, titleHeight);
    self.update.frame = CGRectMake(0.0, CGRectGetMaxY(self.title.frame), self.cellWidth, updateHeight);
}

@end
