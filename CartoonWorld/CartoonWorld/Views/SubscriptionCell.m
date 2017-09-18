//
//  SubscriptionCell.m
//  CartoonWorld
//
//  Created by dundun on 2017/6/26.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "SubscriptionCell.h"
#import "ComicModel.h"

@interface SubscriptionCell()

@property (nonatomic ,strong) UIImageView *coverImage;
@property (nonatomic ,strong) UILabel *title;
@property (nonatomic ,strong) UILabel *tags;
@property (nonatomic ,strong) UILabel *content;

@end

@implementation SubscriptionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = COLOR_BACK_WHITE;
        
        [self setupCellSubViews];
    }
    return self;
}

- (void)setupCellSubViews
{
    // 漫画封面
    self.coverImage = [[UIImageView alloc] init];
    self.coverImage.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImage.layer.masksToBounds = YES;
    self.coverImage.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.coverImage];
    [self.coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(TOP_BOTTOM);
        make.bottom.equalTo(self).offset(-TOP_BOTTOM);
        make.left.equalTo(self).offset(LEFT_RIGHT);
        make.width.mas_equalTo(VERTICAL_CELL_WIDTH);
    }];
    
    // 漫画标题
    self.title = [UILabel labelWithText:@"" textColor:TEXT_COLOR fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImage.mas_right).offset(LEFT_RIGHT);
        make.right.equalTo(self).offset(-LEFT_RIGHT);
        make.top.equalTo(self.coverImage);
        make.height.mas_offset(LABEL_HEIGHT);
    }];
    
    // 漫画标签
    self.tags = [UILabel labelWithText:@"" textColor:TEXT_GRAD_COLOR fontSize:FONT_CONTENT textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.tags];
    [self.tags mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImage.mas_right).offset(LEFT_RIGHT);
        make.right.equalTo(self).offset(-LEFT_RIGHT);
        make.top.equalTo(self.title.mas_bottom).offset(TOP_BOTTOM);
        make.height.mas_offset(LABEL_HEIGHT);
    }];
    
    // 漫画简介
    self.content = [UILabel labelWithText:@"" textColor:TEXT_GRAD_COLOR fontSize:FONT_CONTENT textAlignment:NSTextAlignmentLeft];
    self.content.numberOfLines = 0;
    [self.contentView addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverImage.mas_right).offset(LEFT_RIGHT);
        make.right.equalTo(self).offset(-LEFT_RIGHT);
        make.top.equalTo(self.tags.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    
    // 分割线
    UIView *line = [UIView new];
    line.backgroundColor = COLOR_APP_LINE;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_offset(1);
    }];
}

- (void)setComicModel:(ComicModel *)comicModel
{
    _comicModel = comicModel;
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:comicModel.cover]];
    self.title.text = comicModel.name;
    NSMutableString *tagsMutableString = [NSMutableString string];
    for (int i = 0; i < comicModel.tags.count; i++) {
        if (i < 2) {
            [tagsMutableString appendString:[NSString stringWithFormat:@"%@ ",comicModel.tags[i]]];
        }
    }
    self.tags.text = [NSString stringWithFormat:@"%@|  %@",tagsMutableString, comicModel.author];
    self.content.text = comicModel.descriptionStr;
}

@end
