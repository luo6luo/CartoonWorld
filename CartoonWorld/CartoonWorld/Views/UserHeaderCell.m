//
//  UserHeaderCell.m
//  二次元境
//
//  Created by MS on 15/11/23.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "UserHeaderCell.h"
#import "UserModel.h"
#import "RGBColor.h"

@interface UserHeaderCell ()

@property (nonatomic ,strong) UIImageView * headerIcon;
@property (nonatomic ,strong) UILabel * nickNameLabel;
@property (nonatomic ,strong) UILabel * detailLabel;

@end

@implementation UserHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = COLOR_WHITE;
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    // 头像
    self.headerIcon = [[UIImageView alloc] initWithImage:nil];
    [self.contentView addSubview:self.headerIcon];
    [self.headerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LEFT_RIGHT);
        make.top.equalTo(self).offset(TOP_BOTTOM);
        make.bottom.equalTo(self).offset(-TOP_BOTTOM);
        make.width.equalTo(self.headerIcon.mas_height);
    }];
    
    // 名字
    self.nickNameLabel = [UILabel labelWithText:nil textColor:COLOR_TEXT_BLACK fontSize:FONT_TITLE textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.nickNameLabel];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIcon.mas_right).offset(2*MIDDLE_SPASE);
        make.top.equalTo(self.headerIcon);
        make.right.equalTo(self).offset(-LEFT_RIGHT);
        make.height.mas_equalTo(LABEL_HEIGHT);
    }];
    
    // 描述
    self.detailLabel = [UILabel labelWithText:nil textColor:COLOR_TEXT_BLACK fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentLeft];
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.numberOfLines = 0;
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIcon.mas_right).offset(2*MIDDLE_SPASE);
        make.top.equalTo(self.nickNameLabel.mas_bottom);
        make.right.equalTo(self).offset(-LEFT_RIGHT);
        make.bottom.equalTo(self.headerIcon);
    }];
    
    //分割线
    UILabel * sliptLabel = [[UILabel alloc] init];
    sliptLabel.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.contentView addSubview:sliptLabel];
    [sliptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
}

// 加载数据
- (void)reloadData
{
    UserModel *user = [UserModel defaultUser];
    self.headerIcon.image = [UIImage imageWithData:user.headerIcon];
    self.nickNameLabel.text = user.nickName;
    self.detailLabel.text = user.descriptionStr;
}

@end
