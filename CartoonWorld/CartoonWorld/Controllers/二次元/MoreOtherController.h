//
//  MoreOtherController.h
//  CartoonWorld
//
//  Created by dundun on 2017/8/18.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MoreType) {
    DayComic,    // 每日条漫
    Topic        // 专题
};

@interface MoreOtherController : UITableViewController

@property (nonatomic, assign) NSInteger argValue;
@property (nonatomic, strong) NSString *argName;
@property (nonatomic, assign) MoreType moreType;

@end
