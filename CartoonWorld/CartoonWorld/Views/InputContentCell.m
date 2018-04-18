//
//  ChangePasswordCell.m
//  CartoonWorld
//
//  Created by dundun on 2017/12/18.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "InputContentCell.h"

@interface InputContentCell()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation InputContentCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = COLOR_WHITE;
    
    self.textField.font = [UIFont systemFontOfSize:FONT_SUBTITLE];
    self.textField.textColor = COLOR_TEXT_BLACK;
}

- (IBAction)changeInputContent:(id)sender
{
    if (self.textField) {
        UITextField *tf = (UITextField *)sender;
        self.changeInputBlock(tf.text);
    }
}

- (void)setInputContent:(NSString *)inputContent
{
    _inputContent = inputContent;
    self.textField.text = inputContent;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
}

@end
