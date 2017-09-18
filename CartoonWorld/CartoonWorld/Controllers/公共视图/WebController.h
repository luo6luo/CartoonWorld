//
//  WebController.h
//  CartoonWorld
//
//  Created by dundun on 2017/6/30.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebController : UIViewController

@property (nonatomic, strong) NSString *urlString;

/**开始加载*/
- (void)startRequest;

@end
