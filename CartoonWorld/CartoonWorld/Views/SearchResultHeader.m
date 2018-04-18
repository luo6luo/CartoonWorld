//
//  SearchResultHeader.m
//  CartoonWorld
//
//  Created by dundun on 2017/11/13.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "SearchResultHeader.h"

@interface SearchResultHeader()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SearchResultHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = COLOR_BACK_WHITE;
        [self setupSubview];
    }
    return self;
}

- (void)setupSubview
{
    self.titleLabel = [UILabel labelWithText:nil textColor:COLOR_TEXT_BLACK fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentLeft];
    self.titleLabel.frame = CGRectMake(LEFT_RIGHT, HEIGHT_HEADER_SEARCH_RESULT/2 - LABEL_HEIGHT/2, SCREEN_WIDTH - 2*LEFT_RIGHT, LABEL_HEIGHT);
    [self.contentView addSubview:self.titleLabel];
}

- (void)setTotalComic:(NSInteger)totalComic
{
    _totalComic = totalComic;
    self.textLabel.text = [NSString stringWithFormat:@"总共找到了%ld部漫画",(long)totalComic];
}

@end
