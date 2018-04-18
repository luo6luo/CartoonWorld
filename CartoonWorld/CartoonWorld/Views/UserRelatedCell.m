//
//  UserRelatedCell.m
//  CartoonWorld
//
//  Created by dundun on 2017/11/21.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "UserRelatedCell.h"
#import "UserModel.h"

@interface UserRelatedCell()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UIImageView *rightImage;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *rightButton;
@property (nonatomic, assign) RelatedCellRightType rightType;

@end

@implementation UserRelatedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellRightType:(RelatedCellRightType)rightType
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = COLOR_WHITE;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.rightType = rightType;
        
        [self setupSubview];
    }
    return self;
}

- (void)setupSubview
{
    // 左侧标题
    self.leftLabel = [UILabel labelWithText:nil textColor:COLOR_TEXT_BLACK fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LEFT_RIGHT);
        make.centerY.equalTo(self);
        make.height.mas_offset(LABEL_HEIGHT);
        make.width.mas_offset(SCREEN_WIDTH/3);
    }];
    
    // 右侧返回键
    self.rightButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_btn"]];
    [self.contentView addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-LEFT_RIGHT);
        make.centerY.equalTo(self);
        make.width.height.mas_offset(LABEL_HEIGHT);
    }];
    
    UserModel *user = [UserModel defaultUser];
    if (self.rightType == RelatedCellRightTypeImage) {
        // 右边是图案
        self.rightImage = [[UIImageView alloc] initWithImage:[UIImage imageWithData:user.headerIcon]];
        self.rightImage.layer.cornerRadius = ICON_HEIGHT/2;
        self.rightImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.rightImage];
        [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rightButton.mas_left).offset(-MIDDLE_SPASE);
            make.centerY.equalTo(self);
            make.width.height.mas_offset(ICON_HEIGHT);
        }];
    } else if (self.rightType == RelatedCellRightTypeText) {
        // 右边是文字
        self.rightLabel = [UILabel labelWithText:nil textColor:COLOR_TEXT_GRAY fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rightButton.mas_left).offset(-MIDDLE_SPASE);
            make.centerY.equalTo(self);
            make.height.mas_offset(LABEL_HEIGHT);
            make.left.equalTo(self.leftLabel.mas_right);
        }];
    }
    
    // 分界线
    UIView *line = [UIView new];
    line.backgroundColor = COLOR_APP_LINE;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

# pragma mark - Setter

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.leftLabel.text = title;
}

- (void)setRightImageData:(NSData *)rightImageData
{
    _rightImageData = rightImageData;
    if (self.rightImage) {
        self.rightImage.image = [UIImage imageWithData:rightImageData];
    }
}

- (void)setRightText:(NSString *)rightText
{
    _rightText = rightText;
    if (self.rightLabel) {
        self.rightLabel.text = rightText;
    }
}

@end
