//
//  SearchHistoryCell.h
//  CartoonWorld
//
//  Created by dundun on 2017/11/7.
//  Copyright © 2017年 顿顿. All rights reserved.
//

typedef NS_ENUM(NSInteger, ColorType) {
    ColorTypePink = 0, // 粉色系（背景粉，字白）
    ColorTypeLightBlue // 淡蓝系（背景白，字淡蓝）
};

#import <UIKit/UIKit.h>

@interface SearchHistoryCell : UITableViewCell

@property (nonatomic, strong) NSString *text;
// 默认 ColorTypePink
@property (nonatomic, assign) ColorType type;

@end
