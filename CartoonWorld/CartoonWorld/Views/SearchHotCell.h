//
//  SearchHotCell.h
//  CartoonWorld
//
//  Created by dundun on 2017/11/6.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchHotModel;

@interface SearchHotCell : UITableViewCell

/**
 初始化

 @param style           cell类型
 @param reuseIdentifier 标识符
 @param hotArr          热搜内容
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier hotArr:(NSArray *)hotArr;

@property (nonatomic, copy) void(^tagBtnClickedBlock)(SearchHotModel *model);

@end
