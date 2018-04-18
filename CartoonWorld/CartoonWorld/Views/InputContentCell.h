//
//  ChangePasswordCell.h
//  CartoonWorld
//
//  Created by dundun on 2017/12/18.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputContentCell : UITableViewCell

@property (nonatomic, copy) void(^changeInputBlock)(NSString *inputStr);
@property (nonatomic, strong) NSString *inputContent;
@property (nonatomic, strong) NSString *placeholder;

@end
