//
//  CommentCell.m
//  CartoonWorld
//
//  Created by dundun on 2017/9/19.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "CommentCell.h"
#import "CommentModel.h"

@interface CommentCell()

@property (nonatomic, strong) UIImageView *userHeaderImage; // 用户头像
@property (nonatomic, strong) UILabel *userNameLabel;       // 用户名
@property (nonatomic, strong) UILabel *commentLabel;        // 评论类容
@property (nonatomic, strong) UILabel *timeLabel;           // 评论时间
@property (nonatomic, strong) UILabel *likeCountLabel;      // 喜欢数

@end

@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = COLOR_BACK_WHITE;
        
        [self setupCommentView];
    }
    return self;
}

// 创建视图
- (void)setupCommentView
{
    // 用户头像
    self.userHeaderImage = [UIImageView imageViewWithFrame:CGRectZero image:nil];
    self.userHeaderImage.layer.cornerRadius = ICON_HEIGHT/2;
    self.userHeaderImage.layer.masksToBounds = YES;
    [self.contentView addSubview:self.userHeaderImage];
    [self.userHeaderImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LEFT_RIGHT);
        make.top.equalTo(self).offset(TOP_BOTTOM);
        make.width.height.mas_equalTo(ICON_HEIGHT);
    }];
    
    // 用户名
    self.userNameLabel = [UILabel labelWithText:nil textColor:COLOR_TEXT_BLACK fontSize:FONT_TITLE textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.userNameLabel];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userHeaderImage.mas_right).offset(MIDDLE_SPASE);
        make.top.equalTo(self).offset(TOP_BOTTOM);
        make.right.equalTo(self).offset(-LEFT_RIGHT);
        make.height.mas_equalTo(LABEL_HEIGHT);
    }];
    
    // 创建时间
    self.timeLabel = [UILabel labelWithText:nil textColor:COLOR_TEXT_GRAY fontSize:FONT_TITLE textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userHeaderImage.mas_right);
        make.bottom.equalTo(self).offset(-TOP_BOTTOM);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.height.mas_equalTo(LABEL_HEIGHT);
    }];
    
    // 喜欢数
    self.likeCountLabel = [UILabel labelWithText:nil textColor:COLOR_TEXT_GRAY fontSize:FONT_TITLE textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.likeCountLabel];
    [self.likeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.bottom.equalTo(self).offset(-TOP_BOTTOM);
        make.height.mas_equalTo(LABEL_HEIGHT);
        make.width.mas_equalTo(2*LABEL_HEIGHT);
    }];
    
    // 喜欢图片
    UIImageView *likeImage = [UIImageView imageViewWithFrame:CGRectZero image:@"favorite"];
    [self.contentView addSubview:likeImage];
    [likeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.likeCountLabel.mas_left).offset(-MIDDLE_SPASE);
        make.bottom.equalTo(self).offset(-TOP_BOTTOM);
        make.width.height.mas_equalTo(LABEL_HEIGHT);
    }];
    
    // 评论
    self.commentLabel = [UILabel labelWithText:nil textColor:COLOR_TEXT_GRAY fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentLeft];
    self.commentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userHeaderImage.mas_right).offset(MIDDLE_SPASE);
        make.right.equalTo(self).offset(-LEFT_RIGHT);
        make.top.equalTo(self.userNameLabel.mas_bottom);
        make.bottom.equalTo(self.timeLabel.mas_top);
    }];
    
    // 分割线
    UIView *lineView = [UIView new];
    lineView.backgroundColor = COLOR_APP_LINE;
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(LINE_HEIGHT);
    }];
}

- (void)setCommentModel:(CommentModel *)commentModel
{
    _commentModel = commentModel;
    
    [self.userHeaderImage sd_setImageWithURL:[NSURL URLWithString:commentModel.face]];
    self.userNameLabel.text = commentModel.nickname;
    self.commentLabel.text = commentModel.content_filter;
    self.timeLabel.text = commentModel.create_time_str;
    self.likeCountLabel.text = commentModel.likeCount;
}

@end
