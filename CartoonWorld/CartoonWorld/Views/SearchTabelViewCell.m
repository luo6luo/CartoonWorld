//
//  SearchBaseCell.m
//  二次元境
//
//  Created by MS on 15/11/24.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "SearchTabelViewCell.h"

@implementation SearchTabelViewCell
{
    UIImageView * _coverImage;
    UILabel * _nameL;
    UILabel * _click_totalL;
    UILabel * _description;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setModel:(SearchTabelViewModel *)model
{
    _model = model;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_coverImage sd_setImageWithURL:[NSURL URLWithString:_model.cover] placeholderImage:nil];
    });
    _click_totalL.text = [NSString stringWithFormat:@"总点击:%@  作者:%@",model.click_total,model.nickname];
    _description.text = model.description;
    _nameL.text = model.name;
}

- (void)createUI
{
    _coverImage = [[UIImageView alloc] init];
    _coverImage.frame = CGRectMake(10, 10, (SCREEN_WIDTH/3 - 20) * 3/4, SCREEN_WIDTH/3 - 20);
    _coverImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_coverImage];
    
    _nameL = [[UILabel alloc] init];
    _nameL.frame = CGRectMake(CGRectGetMaxX(_coverImage.frame) + 10, 10, SCREEN_WIDTH - 30 - (SCREEN_WIDTH/3 - 20) * 3/4, 20);
    _nameL.textAlignment = NSTextAlignmentLeft;
    _nameL.textColor = [UIColor blackColor];
    _nameL.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_nameL];
    
    _click_totalL = [[UILabel alloc] init];
    _click_totalL.frame = CGRectMake(CGRectGetMaxX(_coverImage.frame) + 10, CGRectGetMaxY(_nameL.frame) + 5, SCREEN_WIDTH - 30 - (SCREEN_WIDTH/3 - 20) * 3/4, 15);
    _click_totalL.textAlignment = NSTextAlignmentLeft;
    _click_totalL.textColor = COLOR_TEXT_BLACK;
    _click_totalL.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_click_totalL];
    
    _description = [[UILabel alloc] init];
    _description.frame = CGRectMake(CGRectGetMaxX(_coverImage.frame) + 10, CGRectGetMaxY(_click_totalL.frame) + 5, SCREEN_WIDTH - 30 - (SCREEN_WIDTH/3 - 20) * 3/4, 35);
    _description.textAlignment = NSTextAlignmentLeft;
    _description.textColor = COLOR_TEXT_BLACK;
    _description.numberOfLines = 0;
    _description.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_description];
    
}

@end
