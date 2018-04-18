//
//  ChangeDetailController.h
//  CartoonWorld
//
//  Created by dundun on 2017/11/24.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeDetailController : UIViewController

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, copy) void(^edictTextBlock)(NSString *text);

@end

