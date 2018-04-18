//
//  OtherUserCell.m
//  二次元境
//
//  Created by 顿顿 on 16/4/11.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "OtherUserCell.h"

@interface OtherUserCell ()

@property (nonatomic ,strong) UIImageView * leftImage; // 左图片
@property (nonatomic ,strong) UILabel * middleLabel;   // 中间label

@end

@implementation OtherUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = COLOR_WHITE;
        
        [self setupSubview];
    }
    return self;
}

- (void)setupSubview
{
    // 图标
    self.leftImage = [[UIImageView alloc] init];
    [self.contentView addSubview:self.leftImage];
    [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LEFT_RIGHT);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(ICON_HEIGHT);
    }];
    
    // 标题
    self.middleLabel = [UILabel labelWithText:nil textColor:COLOR_TEXT_BLACK fontSize:FONT_CONTENT textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.middleLabel];
    [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImage.mas_right).offset(2*MIDDLE_SPASE);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(LEFT_RIGHT);
        make.height.mas_equalTo(LABEL_HEIGHT);
    }];
    
    // 分界线
    UIView *line = [UIView new];
    line.backgroundColor = COLOR_APP_LINE;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

- (void)setInfoArr:(NSArray *)infoArr
{
    _infoArr = infoArr;
    
    if (infoArr.count > 1) {
        self.leftImage.image = [UIImage imageNamed:infoArr[0]];
        self.middleLabel.text = infoArr[1];
    }
}

@end
