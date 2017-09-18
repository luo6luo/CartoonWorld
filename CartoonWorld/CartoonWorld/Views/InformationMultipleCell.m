//
//  InformationMultipleCell.m
//  二次元境
//
//  Created by 顿顿 on 16/4/7.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "InformationMultipleCell.h"
#import "CoversModel.h"

@interface InformationMultipleCell ()

@property (nonatomic ,strong) UIImageView * myImageView;
@property (nonatomic ,strong) UILabel * titleL;
@property (nonatomic ,strong) UILabel * newsauthorL;
@property (nonatomic ,strong) UILabel * newstypeL;
@property (nonatomic ,strong) UILabel * comment_countL;
@property (nonatomic ,strong) UILabel * favoritedL;

@end

@implementation InformationMultipleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = COLOR_BACK_WHITE;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 20)];
    _titleL.textAlignment = NSTextAlignmentLeft;
    _titleL.font = [UIFont systemFontOfSize:15];
    _titleL.numberOfLines = 0;
    _titleL.textColor = [UIColor colorWithWhite:0.3 alpha:0.9];
    [self.contentView addSubview:_titleL];
    
    self.myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_titleL.frame) + 10, SCREEN_WIDTH - 30, (SCREEN_WIDTH - 40)/3)];
    self.myImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.myImageView.clipsToBounds = YES;
    self.myImageView.layer.cornerRadius = 5;
    self.myImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.myImageView];
    
    _newstypeL = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.myImageView.frame) + 5, 40, 20)];
    _newstypeL.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hd_homepage_thread_more_8"]];
    _newstypeL.textAlignment = NSTextAlignmentCenter;
    _newstypeL.textColor = [UIColor whiteColor];
    _newstypeL.font = [UIFont systemFontOfSize:10];
    _newstypeL.layer.cornerRadius = 4;
    _newstypeL.layer.masksToBounds = YES;
    [self.contentView addSubview:_newstypeL];
    
    _newsauthorL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_newstypeL.frame) + 10, CGRectGetMaxY(self.myImageView.frame) + 5, 100, 20)];
    _newsauthorL.textAlignment = NSTextAlignmentLeft;
    _newsauthorL.font = [UIFont systemFontOfSize:10];
    _newsauthorL.textColor = [UIColor colorWithWhite:0.5 alpha:0.9];
    [self.contentView addSubview:_newsauthorL];
}

- (void)setModel:(InformationModel *)model
{
    _titleL.text = model.title;
    _newstypeL.text = model.newstype_info[@"content"];
    _newsauthorL.text = model.newsauthor_info[@"content"];
    CGFloat width = (self.myImageView.frame.size.width - (model.covers.count - 1)*5)/model.covers.count;
    for (int i =0; i < model.covers.count; i ++) {
        UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake((width + 5)*i, 0, width , self.myImageView.frame.size.height)];
        CoversModel * covers = model.covers[i];
        [imageV sd_setImageWithURL:[NSURL URLWithString:covers.u] placeholderImage:nil];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.clipsToBounds = YES;
        imageV.layer.cornerRadius = 4;
        imageV.layer.masksToBounds = YES;
        [self.myImageView addSubview:imageV];
    }
}


@end
