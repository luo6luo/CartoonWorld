//
//  SearchBar.m
//  CartoonWorld
//
//  Created by dundun on 2017/10/26.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "SearchBarView.h"

@interface SearchBarView()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *searchBar;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation SearchBarView

- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT_V);
        self.backgroundColor = COLOR_PINK;
        
        [self setupBarView];
    }
    return self;
}

# pragma mark - Set up

- (void)setupBarView
{
    // 取消按钮
    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - LEFT_RIGHT - 2*LABEL_HEIGHT, self.minY + self.height/2 + STATUSBAR_HEIGHT/2 - LABEL_HEIGHT/2, 2*LABEL_HEIGHT, LABEL_HEIGHT)];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_CONTENT];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:COLOR_TEXT_WHITE forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelBtn];
    
    // 搜索条
    self.searchBar = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_RIGHT, self.minY + self.height/2 + STATUSBAR_HEIGHT/2 - SEARCH_BAR_HEIGHT/2, self.cancelBtn.minX - LEFT_RIGHT, SEARCH_BAR_HEIGHT)];
    self.searchBar.backgroundColor = COLOR_TEXT_WHITE;
//    self.searchBar.layer.cornerRadius = SEARCH_BAR_HEIGHT/2;
//    self.searchBar.layer.masksToBounds = YES;
    self.searchBar.placeholder = @"输入漫画名称/作者";
    self.searchBar.font = [UIFont systemFontOfSize:FONT_CONTENT];
    self.searchBar.borderStyle = UITextBorderStyleRoundedRect;
    self.searchBar.clearButtonMode = UITextFieldViewModeAlways;
    self.searchBar.delegate = self;
    [self addSubview:self.searchBar];
    
    // 设置键盘
    self.searchBar.returnKeyType = UIReturnKeySearch;
}

// 点击取消
- (void)cancelButtonClicked:(UIButton *)searchBtn
{
    if (self.cancelBlock) {
        [self.searchBar resignFirstResponder];
        self.cancelBlock();
    }
}

# pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length > 0) {
        [self.searchBar resignFirstResponder];
        
        if (self.searchContentBlock) {
            self.searchContentBlock(textField.text);
        }
        
        return YES;
    } else {
        [AlertManager showInfo:@"请输入内容"];
        return NO;
    }
}

@end
