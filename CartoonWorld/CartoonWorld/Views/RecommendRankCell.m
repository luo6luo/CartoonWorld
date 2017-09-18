//
//  RecommendRankCell.m
//  CartoonWorld
//
//  Created by dundun on 2017/6/14.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "RecommendRankCell.h"
#import "ComicModel.h"

@interface RecommendRankCell()

@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic ,strong) UILabel *title;
@property (nonatomic ,strong) UILabel *tags;
@property (nonatomic ,strong) UILabel *author;

@end

@implementation RecommendRankCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.layer.cornerRadius = CORNERRADIUS;
        self.contentView.layer.masksToBounds = YES;
        
        NSArray *colorArr = @[@"#E6E6FA", @"#BFEFFF", @"#FFEC8B", @"#C1FFC1"];
        self.contentView.backgroundColor = [RGBColor colorWithHexString:colorArr[arc4random()%3]];
        [self setupRankCellViews];
    }
    return self;
}

- (void)setupRankCellViews
{
    // 漫画封面
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self);
        make.width.mas_equalTo(HORIZONTAL_CELL_WIDTH);
    }];
    
    CGFloat labelHeight = (HORIZONTAL_CELL_HEIGHT - 2*TOP_BOTTOM)/3;
    
    // 漫画标题
    self.title = [UILabel labelWithText:@"" textColor:COLOR_TEXT_BLACK fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView);
        make.left.equalTo(self.imageView.mas_right).offset(LEFT_RIGHT);
        make.height.mas_equalTo(labelHeight);
    }];
    
    // 漫画标签
    self.tags = [UILabel labelWithText:@"" textColor:COLOR_TEXT_GRAY fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.tags];
    [self.tags mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.imageView.mas_right).offset(LEFT_RIGHT);
        make.right.equalTo(self.contentView);
        make.height.mas_offset(labelHeight);
    }];
    
    // 漫画作者
    self.author = [UILabel labelWithText:@"" textColor:COLOR_TEXT_GRAY fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.author];
    [self.author mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.contentView);
        make.left.equalTo(self.imageView.mas_right).offset(LEFT_RIGHT);
        make.height.mas_offset(labelHeight);
    }];
}

- (void)setComicModel:(ComicModel *)comicModel
{
    _comicModel = comicModel;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:comicModel.cover]];
    self.title.text = comicModel.name;
    
    NSMutableString *tagsString = [NSMutableString string];
    for (int i = 0; i < comicModel.tags.count; i++) {
        [tagsString appendString:comicModel.tags[i]];
        [tagsString appendString:@"  "];
    }
    self.tags.text = tagsString;
    self.author.text = comicModel.author_name;
    
}

@end
