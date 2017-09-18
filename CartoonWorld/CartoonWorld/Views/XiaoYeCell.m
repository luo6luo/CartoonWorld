//
//  XiaoYeCell.m
//  二次元境
//
//  Created by MS on 15/11/23.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "XiaoYeCell.h"
#import "RGBColor.h"

@interface XiaoYeCell ()

@property (nonatomic ,strong) UIImageView * imageV;
@property (nonatomic ,strong) UIImageView * iconImageV;
@property (nonatomic ,strong) UILabel * titleL;
@property (nonatomic ,strong) UILabel * detailL;

@end

@implementation XiaoYeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = [UIColor whiteColor];
        [self initSubViews];
    }
    return self;
}

- (void)setModel:(UserInfoModel *)model
{
    _model = model;
    _iconImageV.image = [UIImage imageNamed:model.imageStr];
    _titleL.text = model.nameStr;
    _detailL.text = model.detailStr;
}

- (void)initSubViews
{
    //头像
    _iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    _iconImageV.layer.cornerRadius = 30;
    _iconImageV.layer.masksToBounds = YES;
    [self.contentView addSubview:_iconImageV];
    
    //名字
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageV.frame) + 10, 10, 100, 30)];
    _titleL.textAlignment = NSTextAlignmentLeft;
    _titleL.textColor = [UIColor blackColor];
    _titleL.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_titleL];
    
    //描述
    _detailL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageV.frame) + 10, CGRectGetMaxY(_titleL.frame), SCREEN_WIDTH - 90, 30)];
    _detailL.textAlignment = NSTextAlignmentLeft;
    _detailL.numberOfLines = 0;
    _detailL.adjustsFontSizeToFitWidth = YES;
    _detailL.textColor = [UIColor blackColor];
    _detailL.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_detailL];
    
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

@end
