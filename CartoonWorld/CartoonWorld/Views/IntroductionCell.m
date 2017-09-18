//
//  IntroductionCell.m
//  CartoonWorld
//
//  Created by dundun on 2017/9/6.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "IntroductionCell.h"

@interface IntroductionCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation IntroductionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = COLOR_WHITE;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupIntroductionSubviews];
    }
    return self;
}

- (void)setupIntroductionSubviews
{
    // 标题
    self.titleLabel = [UILabel labelWithText:@"作品介绍" textColor:COLOR_TEXT_BLACK fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LEFT_RIGHT);
        make.right.equalTo(self).offset(-LEFT_RIGHT);
        make.height.mas_offset(LABEL_HEIGHT);
        make.top.equalTo(self).offset(TOP_BOTTOM);
    }];
    
    // 内容
    self.contentLabel = [UILabel labelWithText:nil textColor:COLOR_TEXT_BLACK fontSize:FONT_CONTENT textAlignment:NSTextAlignmentLeft];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LEFT_RIGHT);
        make.right.equalTo(self).offset(-LEFT_RIGHT);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(MIDDLE_SPASE);
        make.bottom.equalTo(self).offset(-TOP_BOTTOM);
    }];
}

- (void)setContentStr:(NSString *)contentStr
{
    _contentStr = contentStr;
    self.contentLabel.attributedText = [self setContent:contentStr lineSpacing:5];
}

//设置行间距
- (NSMutableAttributedString *)setContent:(NSString*)content lineSpacing:(CGFloat)lineSpacing {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    return attributedString;
}

@end
