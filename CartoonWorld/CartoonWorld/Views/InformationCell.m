//
//  InformationCell.m
//  二次元境
//
//  Created by MS on 15/11/21.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "InformationCell.h"
#import "CoversModel.h"

@interface InformationCell ()

@property (nonatomic ,strong) UIImageView * myImageView;
@property (nonatomic ,strong) UILabel * titleL;
@property (nonatomic ,strong) UILabel * newsauthorL;
@property (nonatomic ,strong) UILabel * newstypeL;
@property (nonatomic ,strong) UILabel * comment_countL;
@property (nonatomic ,strong) UILabel * favoritedL;

@end

@implementation InformationCell

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
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 40 - SCREEN_WIDTH  / 4, SCREEN_WIDTH  / 4)];
    _titleL.textAlignment = NSTextAlignmentLeft;
    _titleL.font = [UIFont systemFontOfSize:15];
    _titleL.numberOfLines = 0;
    _titleL.textColor = [UIColor colorWithWhite:0.3 alpha:0.9];
    [self.contentView addSubview:_titleL];
    
    self.myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleL.frame) + 10, 10, SCREEN_WIDTH  / 4, SCREEN_WIDTH  / 4)];
    self.myImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.myImageView.clipsToBounds = YES;
    self.myImageView.layer.cornerRadius = 5;
    self.myImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.myImageView];
    
    _newstypeL = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_titleL.frame) + 5, 40, 20)];
    _newstypeL.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hd_homepage_thread_more_5"]];
    _newstypeL.textAlignment = NSTextAlignmentCenter;
    _newstypeL.textColor = [UIColor whiteColor];
    _newstypeL.font = [UIFont systemFontOfSize:10];
    _newstypeL.layer.cornerRadius = 4;
    _newstypeL.layer.masksToBounds = YES;
    [self.contentView addSubview:_newstypeL];
    
    _newsauthorL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_newstypeL.frame) + 10, CGRectGetMaxY(_titleL.frame) + 5, 100, 20)];
    _newsauthorL.textAlignment = NSTextAlignmentLeft;
    _newsauthorL.font = [UIFont systemFontOfSize:10];
    _newsauthorL.textColor = [UIColor colorWithWhite:0.5 alpha:0.9];
    [self.contentView addSubview:_newsauthorL];
}

- (void)setModel:(InformationModel *)model
{
    _model = model;
    _titleL.text = model.title;
    _newstypeL.text = model.newstype_info[@"content"];
    _newsauthorL.text = model.newsauthor_info[@"content"];
    CoversModel * covers = model.covers[0];
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:covers.u] placeholderImage:nil];
}


@end
