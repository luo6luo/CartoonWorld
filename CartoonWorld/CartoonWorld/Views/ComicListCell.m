//
//  MoreCell.m
//  CartoonWorld
//
//  Created by dundun on 2017/8/16.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "ComicListCell.h"
#import "ComicModel.h"

@interface ComicListCell()

@property (nonatomic, strong) UIImageView *comicImage; // 漫画
@property (nonatomic, strong) UILabel *comicName;      // 漫画名
@property (nonatomic, strong) UILabel *tags;           // 标签
@property (nonatomic, strong) UILabel *desLabel;       // 标签
@property (nonatomic, strong) UILabel *promptInfo;     // 提示信息

@end

@implementation ComicListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = COLOR_BACK_WHITE;
        
        [self setupMoreCellSubviews];
    }
    return self;
}

- (void)setupMoreCellSubviews
{
    // 漫画
    CGRect imageFrame = CGRectMake(LEFT_RIGHT, TOP_BOTTOM, VERTICAL_CELL_WIDTH, HEIGHT_CELL_MORECOMIC - 2*TOP_BOTTOM);
    self.comicImage = [UIImageView imageViewWithFrame:imageFrame image:nil];
    [self.contentView addSubview:self.comicImage];
    
    // 漫画名
    CGRect nameFrame = CGRectMake(self.comicImage.maxX + LEFT_RIGHT, TOP_BOTTOM, SCREEN_WIDTH - VERTICAL_CELL_WIDTH - 3*LEFT_RIGHT, LABEL_HEIGHT);
    self.comicName = [UILabel labelWithText:nil textColor:COLOR_TEXT_BLACK fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentLeft];
    self.comicName.frame = nameFrame;
    [self.contentView addSubview:self.comicName];
    
    // 漫画标签
    CGRect tagsFrame = CGRectMake(self.comicImage.maxX + LEFT_RIGHT, self.comicName.maxY + MIDDLE_SPASE, self.comicName.width, LABEL_HEIGHT);
    self.tags = [UILabel labelWithText:nil textColor:COLOR_TEXT_GRAY fontSize:FONT_CONTENT textAlignment:NSTextAlignmentLeft];
    self.tags.frame = tagsFrame;
    [self.contentView addSubview:self.tags];
    
    // 描述
    CGRect descriptionFrame = CGRectMake(self.comicImage.maxX + LEFT_RIGHT, self.tags.maxY + MIDDLE_SPASE, self.comicName.width, 2*LABEL_HEIGHT);
    self.desLabel = [UILabel labelWithText:nil textColor:COLOR_TEXT_GRAY fontSize:FONT_CONTENT textAlignment:NSTextAlignmentLeft];
    self.desLabel.numberOfLines = 0;
    self.desLabel.frame = descriptionFrame;
    [self.contentView addSubview:self.desLabel];
    
    // 提示信息
    CGRect promptFrame = CGRectMake(self.comicImage.maxX + LEFT_RIGHT, self.comicImage.maxY - LABEL_HEIGHT, self.comicName.width, LABEL_HEIGHT);
    self.promptInfo = [UILabel labelWithText:nil textColor:COLOR_ORANGE fontSize:FONT_CONTENT textAlignment:NSTextAlignmentLeft];
    self.promptInfo.frame = promptFrame;
    [self.contentView addSubview:self.promptInfo];
    
    // 分割线
    UIView *line = [UIView new];
    line.backgroundColor = COLOR_APP_LINE;
    line.frame = CGRectMake(0, HEIGHT_CELL_MORECOMIC - 1, SCREEN_WIDTH, 1);
    [self.contentView addSubview:line];
}

- (void)setComicModel:(ComicModel *)comicModel
{
    _comicModel = comicModel;
    
    [self.comicImage sd_setImageWithURL:[NSURL URLWithString:comicModel.cover]];
    self.comicName.text = comicModel.name;
    self.tags.text = [comicModel.tags componentsJoinedByString:@"  "];
    self.desLabel.text = comicModel.descriptionStr;
}

- (void)setPromptInfoStr:(NSString *)promptInfoStr
{
    _promptInfoStr = promptInfoStr;
    self.promptInfo.text = self.promptInfoStr;
}

@end
