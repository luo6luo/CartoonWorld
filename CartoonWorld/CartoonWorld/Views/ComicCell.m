//
//  ComicCell.m
//  二次元境
//
//  Created by 顿顿 on 16/4/8.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "ComicCell.h"

@interface ComicCell ()

@property (nonatomic ,strong) UIImageView * headerImageV;
@property (nonatomic ,strong) UILabel * bookNameL;
@property (nonatomic ,strong) UILabel * authorNameL;
@property (nonatomic ,strong) UILabel * updateL;
@property (nonatomic ,strong) UILabel * dianJiL;
@property (nonatomic ,strong) UIButton * readB;
@property (nonatomic ,strong) UILabel * topLabel;
@property (nonatomic ,strong) UILabel * xianL;
@property (nonatomic ,strong) UILabel * muluL;

@end

@implementation ComicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

- (void)setComicModel:(ComicModel *)comicModel
{
    _comicModel = comicModel;
    [self.headerImageV sd_setImageWithURL:[NSURL URLWithString:comicModel.cover]];
    self.bookNameL.text = comicModel.name;
//    self.authorNameL.text = [NSString stringWithFormat:@"作者:%@",comicModel.author[@"name"]];
//    self.updateL.text = [NSString stringWithFormat:@"更新:%@",[self lastetWithTime:comicModel.last_update_time]];
//    self.dianJiL.text = [NSString stringWithFormat:@"总点击:%@",comicModel.click_total];
    self.topLabel.text = comicModel.description;
}

- (void)setMyDescription:(NSString *)myDescription
{
    _myDescription = myDescription;
    self.topLabel.text = myDescription;
//    if (myDescription.length > 0) {
//        CGSize size = [self.comicModel.myDescription sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(Screen_Size.width - 30 , MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
//        self.topLabel.frame = CGRectMake(15, CGRectGetMaxY(_readB.frame) + 10, Screen_Size.width - 50,20 + size.height);
//        self.xianL.frame = CGRectMake(15, CGRectGetMaxY(_topLabel.frame) +5, Screen_Size.width - 30, 1);
//        self.muluL.frame = CGRectMake(15, CGRectGetMaxY(_xianL.frame), Screen_Size.width - 30, 40);
//    }else {
//        self.topLabel.frame = CGRectMake(15, CGRectGetMaxY(_readB.frame) + 10, Screen_Size.width - 50, 20);
//        self.xianL.frame = CGRectMake(15, CGRectGetMaxY(_topLabel.frame) +5, Screen_Size.width - 30, 1);
//        self.muluL.frame = CGRectMake(15, CGRectGetMaxY(_xianL.frame), Screen_Size.width - 30, 40);
//    }
}

- (void)setButtonTitle:(NSString *)buttonTitle
{
    [self.button setTitle:buttonTitle forState:UIControlStateNormal];
}

- (void)initSubViews
{
    //设置上面内容
    //竖着:10 图片H 10 label 10
    //横着:15 图W 15
    
    //整个视图高
    CGFloat height = SCREEN_WIDTH/2;
    //头像的高
    CGFloat B_height = height - 50 ;
    //书头像宽
    CGFloat width = B_height * 2/3 + 5;
    
    //设置书籍视图
    self.headerImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 74, width,B_height )];
    self.headerImageV.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageV.clipsToBounds = YES;
    self.headerImageV.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.headerImageV];
    
    //设置书名
    self.bookNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headerImageV.frame) + 10, 74, SCREEN_WIDTH - 45 - width, self.headerImageV.frame.size.height/5)];
    self.bookNameL.textColor = [UIColor blackColor];
    self.bookNameL.textAlignment = NSTextAlignmentLeft;
    self.bookNameL.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.bookNameL];
    
    //作者
    self.authorNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headerImageV.frame) + 10, CGRectGetMaxY(self.bookNameL.frame) + 5, SCREEN_WIDTH - 45 - width, (B_height - 20 - B_height/5 - B_height/4)/3)];
//    self.authorNameL.textColor = TEXT_COLOR;
    self.authorNameL.textAlignment = NSTextAlignmentLeft;
    self.authorNameL.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:self.authorNameL];
    
    //更新时间
    self.updateL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headerImageV.frame) + 10, CGRectGetMaxY(self.authorNameL.frame) + 5, SCREEN_WIDTH - 45 - width, (B_height - 20 - B_height/5 - B_height/4)/3)];
//    self.updateL.textColor = TEXT_COLOR;
    self.updateL.textAlignment = NSTextAlignmentLeft;
    self.updateL.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.updateL];
    
    //总点击
    self.dianJiL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headerImageV.frame) + 10, CGRectGetMaxY(self.updateL.frame) + 5, SCREEN_WIDTH - 45 - width, (B_height - 20 - B_height/5 - B_height/4)/3)];
//    self.dianJiL.textColor = TEXT_COLOR;
    self.dianJiL.textAlignment = NSTextAlignmentLeft;
    self.dianJiL.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.dianJiL];
    
    //设置点击阅读
    _readB = [UIButton buttonWithType:UIButtonTypeSystem];
    self.readB.frame = CGRectMake(CGRectGetMaxX(self.headerImageV.frame) + 20, CGRectGetMaxY(self.dianJiL.frame) + 5, B_height/2, B_height /4);
    _readB.layer.cornerRadius = 4;
    _readB.layer.masksToBounds = YES;
    [_readB setBackgroundImage:[UIImage imageNamed:@"hd_homepage_thread_more_2"] forState:UIControlStateNormal];
    [_readB setTitle:@"我要看" forState:UIControlStateNormal];
    [_readB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_readB addTarget:self action:@selector(LookButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _readB.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_readB];
    
    //详情介绍
    _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_readB.frame) + 10, SCREEN_WIDTH - 50, 20)];
    _topLabel.textColor = [UIColor blackColor];
    _topLabel.textAlignment = NSTextAlignmentLeft;
    _topLabel.font = [UIFont systemFontOfSize:12];
    _topLabel.numberOfLines = 0;
    [self.contentView addSubview:_topLabel];
    
    //展开按钮
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.frame = CGRectMake(SCREEN_WIDTH - 35 , CGRectGetMaxY(_readB.frame) + 10 , 20, 20);
    self.button.backgroundColor = COLOR_PINK;
    self.button.layer.cornerRadius = 10;
    self.button.layer.masksToBounds = YES;
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.button];
    
    //目录
    _xianL = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_topLabel.frame) +5, SCREEN_WIDTH - 30, 1)];
    _xianL.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
    [self.contentView addSubview:_xianL];
    
    _muluL = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_xianL.frame), SCREEN_WIDTH - 30, 40)];
    _muluL.textColor = [UIColor blackColor];
    _muluL.textAlignment = NSTextAlignmentLeft;
    _muluL.font = [UIFont systemFontOfSize:14];
    _muluL.text = @"目录";
    [self.contentView addSubview:_muluL];
}

- (NSString *)lastetWithTime:(NSString *)time {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[time integerValue]];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

- (void)LookButtonClicked:(UIButton *)button
{
    self.lookCartoonBlock();
}


@end
