//
//  SearchBar.h
//  CartoonWorld
//
//  Created by dundun on 2017/10/26.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchBarView : UIView

@property (nonatomic, copy) void(^cancelBlock)();
@property (nonatomic, copy) void(^searchContentBlock)(NSString *content);

@end
