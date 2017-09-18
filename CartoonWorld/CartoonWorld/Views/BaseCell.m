//
//  BaseCell.m
//  二次元境
//
//  Created by MS on 15/11/22.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "BaseCell.h"

@interface BaseCell ()

@property (nonatomic ,strong) UIImageView * avatarImage;
@property (nonatomic ,strong) UILabel * nameL;
@property (nonatomic ,strong) UILabel * timeL;
@property (nonatomic ,strong) UILabel * titleL;
@property (nonatomic ,strong) UILabel * contentL;
@property (nonatomic ,strong) UILabel * Glabel;

@end

@implementation BaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = COLOR_BACK_WHITE;
        [self createUI];
    }
    return self;
}

- (void)setModel:(BaseModel *)model
{
    _model = model;
    
    [_avatarImage sd_setImageWithURL:[NSURL URLWithString:model.user_info[@"avatar"]]placeholderImage:[UIImage imageNamed:@"defaultIcon_header"]];
    _nameL.text = model.user_info[@"name"];
    _titleL.text = model.title;
    _timeL.text = model.created_at;
    _contentL.text = model.content;
    self.contentL.frame = CGRectMake(15, CGRectGetMaxY(self.titleL.frame), SCREEN_WIDTH - 30, [self contentSize:self.contentL.text]);
    
}

- (void)setType:(NSString *)type
{
    _type = type;
    self.Glabel.text = type;
}

//5 + 30 + 20 + content.height + 5 + 20 + 5
- (void)createUI
{
    _avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 30, 30)];
    _avatarImage.layer.cornerRadius = 15;
    _avatarImage.layer.masksToBounds = YES;
    [self.contentView addSubview:_avatarImage];
    
    _nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_avatarImage.frame)+ 10, 5, SCREEN_WIDTH - 30 - 40, 18)];
    _nameL.textColor = TEXT_COLOR;
    _nameL.textAlignment = NSTextAlignmentLeft;
    _nameL.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_nameL];
    
    _timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_avatarImage.frame) + 10, CGRectGetMaxY(_nameL.frame), SCREEN_WIDTH - 30 - 40, 12)];
    _timeL.textColor = [UIColor lightGrayColor];
    _timeL.textAlignment = NSTextAlignmentLeft;
    _timeL.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_timeL];
    
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_avatarImage.frame) , SCREEN_WIDTH - 30, 20)];
    _titleL.textColor = [UIColor blackColor];
    _titleL.textAlignment = NSTextAlignmentLeft;
    _titleL.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_titleL];
    
    self.contentL = [[UILabel alloc] init];
    _contentL.textColor = TEXT_COLOR;
    _contentL.textAlignment = NSTextAlignmentLeft;
    _contentL.font = [UIFont systemFontOfSize:12];
    _contentL.numberOfLines = 0;
    [self.contentView addSubview:_contentL];
    
    UILabel * label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.height.mas_offset(1);
    }];
    
    self.Glabel = [[UILabel alloc] init];
    self.Glabel.backgroundColor = [RGBColor colorWithHexString:@"#EE6AA7"];
    self.Glabel.text = _type;
    self.Glabel.textAlignment = NSTextAlignmentCenter;
    self.Glabel.font = [UIFont systemFontOfSize:12 weight:2];
    self.Glabel.textColor = [UIColor whiteColor];
    self.Glabel.layer.cornerRadius = 4;
    self.Glabel.layer.masksToBounds = YES;
    [self.contentView addSubview:self.Glabel];
    [self.Glabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.bottom.equalTo(label.mas_bottom).offset(-5);
        make.size.mas_offset(CGSizeMake(40, 20));
    }];
}

- (CGFloat)contentSize:(NSString *)text
{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:12],
                                  NSParagraphStyleAttributeName : paragraphStyle};
    CGSize contentSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)
                                            options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                         attributes:attributes
                                            context:nil].size;
    return contentSize.height;
}


@end
