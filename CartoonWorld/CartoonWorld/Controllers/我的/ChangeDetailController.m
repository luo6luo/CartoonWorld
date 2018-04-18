//
//  ChangeDetailController.m
//  CartoonWorld
//
//  Created by dundun on 2017/11/24.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "ChangeDetailController.h"

@interface ChangeDetailController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView; // 输入框
@property (nonatomic, strong) UIButton *sureButton; // 确定按钮

@end

@implementation ChangeDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BACK_WHITE;
    [self setupSubviews];
}

# pragma mark - Set up

- (void)setupSubviews
{
    self.textView = [[UITextView alloc] init];
    self.textView.backgroundColor = COLOR_WHITE;
    self.textView.font = [UIFont systemFontOfSize:FONT_SUBTITLE];
    self.textView.textColor = COLOR_TEXT_UNSELECT;
    self.textView.text = self.placeholder;
    self.textView.delegate = self;
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_offset(SCREEN_WIDTH * 2/3);
    }];
    
    self.sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.sureButton.backgroundColor = COLOR_PINK;
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureButton setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    [self.sureButton addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(LEFT_RIGHT);
        make.right.equalTo(self.view).offset(-LEFT_RIGHT);
        make.centerY.equalTo(self.view);
        make.height.mas_offset(SURE_BUTTON_HEIGHT);
    }];
}

# pragma mark - Event response

- (void)sureBtnClicked:(UIButton *)button
{
    if (self.edictTextBlock) {
        self.edictTextBlock(self.textView.text);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

# pragma mark - Text view delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    // 将要开始编辑
    if ([textView.text isEqualToString:self.placeholder]) {
        textView.text = @"";
        textView.textColor = COLOR_TEXT_BLACK;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // 结束编辑
    if (textView.text.length <= 1) {
        textView.textColor = COLOR_TEXT_UNSELECT;
        textView.text = self.placeholder;
    }
}

@end
