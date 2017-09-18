//
//  InformationBigPictureCell.m
//  二次元境
//
//  Created by 顿顿 on 16/4/7.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "InformationBigPictureCell.h"
#import "CoversModel.h"

@interface InformationBigPictureCell ()

@property (nonatomic ,strong) UIImageView * myImageView;
@property (nonatomic ,strong) UILabel * titleL;
@property (nonatomic ,strong) UILabel * newsauthorL;
@property (nonatomic ,strong) UILabel * newstypeL;
@property (nonatomic ,strong) UILabel * comment_countL;
@property (nonatomic ,strong) UILabel * favoritedL;

@end

@implementation InformationBigPictureCell

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
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 20)]  ;
    _titleL.textAlignment = NSTextAlignmentCenter;
    _titleL.font = [UIFont systemFontOfSize:15];
    _titleL.numberOfLines = 0;
    _titleL.textColor = [UIColor colorWithWhite:0.3 alpha:0.9];
    [self.contentView addSubview:_titleL];
    
    self.myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 40, SCREEN_WIDTH - 80, SCREEN_WIDTH * 2/5)];
    self.myImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.myImageView.clipsToBounds = YES;
    self.myImageView.layer.cornerRadius = 5;
    self.myImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.myImageView];
    
    _newstypeL = [[ UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.myImageView.frame) + 5, 40, 20)];
    _newstypeL.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hd_homepage_thread_more_2"]];
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
    CoversModel * covers = model.covers[0];
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:covers.u] placeholderImage:nil];
}


@end
