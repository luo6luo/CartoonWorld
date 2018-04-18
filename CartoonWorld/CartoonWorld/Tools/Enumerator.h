//
//  Enumerator.h
//  CartoonWorld
//
//  Created by dundun on 2018/4/17.
//  Copyright © 2018年 顿顿. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ScreenOrientationType) {
    ScreenOrientationTypeVertical = 0, // 竖屏
    ScreenOrientationTypeHorizontal,   // 横屏
    ScreenOrientationTypeUnknown
};

typedef NS_ENUM(NSInteger, ScrollOrientationType) {
    ScrollOrientationTypeVertical = 0, // 竖滑
    ScrollOrientationTypeHorizontal,   // 横滑
    ScrollOrientationTypeUnknown      
};

@interface Enumerator : NSObject

@end
