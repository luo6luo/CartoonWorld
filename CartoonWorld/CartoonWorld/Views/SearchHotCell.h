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

@property (nonatomic, strong) NSArray *hotArr;

@property (nonatomic, copy) void(^tagBtnClickedBlock)(SearchHotModel *model);

@end
