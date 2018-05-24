//
//  UIViewController+Swizzing.m
//  CartoonWorld
//
//  Created by dundun on 2017/6/30.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "UIViewController+Swizzing.h"

@implementation UIViewController (Swizzing)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        // 获取系统和自定义方法名
        SEL originalSelector = @selector(viewWillDisappear:);
        SEL swizzledSelector = @selector(xxx_viewWillDisappear:);
        
        // 根据方法名获取对应的方法结构体，结构体包含了SEL（方法名），IMP（方法实现）
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        // 给类添加系统方法，是为了防止本类中无系统方法
        BOOL didAddMethod = class_addMethod(class,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        
        // 本类中无系统方法则添加系统方法，有则系统和自定义方法交换
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)xxx_viewWillDisappear:(BOOL)animated
{
    [self xxx_viewWillDisappear:animated];
    
    // 每次走系统方法都会额外走此方法
//    [ActivityManager dismissLoading];
}


@end
