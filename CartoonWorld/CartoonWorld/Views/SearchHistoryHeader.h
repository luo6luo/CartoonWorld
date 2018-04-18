//
//  SearchHistoryHeader.h
//  CartoonWorld
//
//  Created by dundun on 2017/11/7.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchHistoryHeader : UITableViewHeaderFooterView

@property (nonatomic, copy) void(^deleteSearchHistoryBlock)();

@end
