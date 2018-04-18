//
//  SearchHistoryHeader.m
//  CartoonWorld
//
//  Created by dundun on 2017/11/7.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "SearchHistoryHeader.h"

@interface SearchHistoryHeader()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation SearchHistoryHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = COLOR_PINK;
        [self setupHistoryHeader];
    }
    return self;
}

- (void)setupHistoryHeader
{
    // 标题
    self.titleLabel = [UILabel labelWithText:@"搜索历史" textColor:COLOR_TEXT_WHITE fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LEFT_RIGHT);
        make.bottom.equalTo(self).offset(- HEIGHT_HEADER_SEARCH_HISTORY/2 + LABEL_HEIGHT/2);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.height.mas_equalTo(LABEL_HEIGHT);
    }];
    
    // 删除按钮
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cancelBtn setImage:[[UIImage imageNamed:@"cancel_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(deleteSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-LEFT_RIGHT);
        make.width.height.mas_equalTo(ICON_HEIGHT);
        make.bottom.mas_equalTo(-HEIGHT_HEADER_SEARCH_HISTORY/2 + ICON_HEIGHT/2);
    }];
}

- (void)deleteSearchHistory:(UIButton *)button
{
    if (self.deleteSearchHistoryBlock) {
        self.deleteSearchHistoryBlock();
    }
}

@end
