//
//  SearchHotHeader.m
//  CartoonWorld
//
//  Created by dundun on 2017/11/7.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "SearchHotHeader.h"

@interface SearchHotHeader()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SearchHotHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupHistoryHeader];
    }
    return self;
}

- (void)setupHistoryHeader
{
    // 标题
    self.titleLabel = [UILabel labelWithText:@"大家都在搜" textColor:COLOR_TEXT_GRAY fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentLeft];
    self.titleLabel.frame = CGRectMake(LEFT_RIGHT, HEIGHT_HEADER_SEARCH_HISTORY/2 - LABEL_HEIGHT/2, SCREEN_WIDTH/2, LABEL_HEIGHT);
    [self.contentView addSubview:self.titleLabel];
}

@end
