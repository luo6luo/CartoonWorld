//
//  HotSearchHeader.m
//  二次元境
//
//  Created by 顿顿 on 16/4/8.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "HotSearchHeader.h"

@interface HotSearchHeader ()<UITextFieldDelegate>

@property (nonatomic ,strong) UITextField * textF;

@end

@implementation HotSearchHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)setTextFieldText:(NSString *)textFieldText
{
    self.textF.text = textFieldText;
}

- (void)initSubViews
{
    //添加搜索条
    UIView * searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    searchView.backgroundColor = COLOR_PINK;
    [self addSubview:searchView];
    
    _textF = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, SCREEN_WIDTH - 25 - 30, 44 - 14)];
    _textF.layer.cornerRadius = 15;
    _textF.layer.masksToBounds = YES;
    _textF.borderStyle = UITextBorderStyleRoundedRect;
    _textF.font = [UIFont systemFontOfSize:13];
    _textF.textColor = TEXT_COLOR;
    _textF.placeholder = @"好多精彩内容等着你哟~~O(∩_∩)O~~";
    _textF.clearButtonMode = UITextFieldViewModeAlways;
    [self.textF addTarget:self action:@selector(searchTextField:) forControlEvents:UIControlEventEditingChanged];
    _textF.delegate = self;
    [searchView addSubview:_textF];
    
    UIButton * searButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 35, 10, 24, 24)];
    [searButton setBackgroundImage:[UIImage imageNamed:@"icnav_search_light"] forState:UIControlStateNormal];
    [searButton addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searButton];
}

- (void)searchTextField:(UITextField *)searchTextField
{
    self.searchTextBlock(self.textF.text);
}

- (void)searchButtonClicked:(UIButton *)sender
{
    self.searchBtnBlock();
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textF resignFirstResponder];
    return YES;
}

@end
