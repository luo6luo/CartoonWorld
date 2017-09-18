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
        
        SEL originalSelector = @selector(viewWillDisappear:);
        SEL swizzledSelector = @selector(xxx_viewWillDisappear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        
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
    
    [AlertManager dismissLoading];
}


@end
