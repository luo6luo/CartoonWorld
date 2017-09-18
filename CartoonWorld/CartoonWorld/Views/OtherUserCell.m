//
//  OtherUserCell.m
//  二次元境
//
//  Created by 顿顿 on 16/4/11.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "OtherUserCell.h"

@interface OtherUserCell ()

@property (nonatomic ,strong) UIImageView * imageV;
@property (nonatomic ,strong) UILabel * titleL;

@end

@implementation OtherUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = [UIColor whiteColor];
        [self initSubViews];
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    _imageV.image = [UIImage imageNamed:dataDic[@"image"]];
     _titleL.text = dataDic[@"name"];
}

- (void)initSubViews
{
    _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 22, 22)];
    [self.contentView addSubview:_imageV];
    
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxY(_imageV.frame) + 10, 10, 100, 22)];
    _titleL.textAlignment = NSTextAlignmentLeft;
    _titleL.textColor = TEXT_COLOR;
    _titleL.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_titleL];
    
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
