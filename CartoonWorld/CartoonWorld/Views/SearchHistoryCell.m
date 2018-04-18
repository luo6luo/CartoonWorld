//
//  SearchHistoryCell.m
//  CartoonWorld
//
//  Created by dundun on 2017/11/7.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "SearchHistoryCell.h"

@interface SearchHistoryCell()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SearchHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = COLOR_PINK;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupTitleView];
    }
    return self;
}

- (void)setupTitleView
{
    self.titleLabel = [UILabel labelWithText:nil textColor:COLOR_TEXT_WHITE fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentLeft];
    self.titleLabel.frame = CGRectMake(LEFT_RIGHT, HEIGHT_CELL_SEARCH_HOT/2 - LABEL_HEIGHT/2, SCREEN_WIDTH - 2*LEFT_RIGHT, LABEL_HEIGHT);
    [self.contentView addSubview:self.titleLabel];
}

# pragma mark - Setter

- (void)setText:(NSString *)text
{
    _text = text;
    self.titleLabel.text = text;
}

@end
