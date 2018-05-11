//
//  LightStateView.m
//  CartoonWorld
//
//  Created by dundun on 2018/5/8.
//  Copyright © 2018年 顿顿. All rights reserved.
//

#import "LightStateView.h"

#define LIGHT_STATE RGBA(0, 0, 0, 0)
#define DARK_STATE RGBA(0, 0, 0, 0.2)

@implementation LightStateView

- (instancetype)init
{
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]) {
        self.userInteractionEnabled = NO;
        self.isOpenLight = YES;
    }
    return self;
}

- (void)setIsOpenLight:(BOOL)isOpenLight
{
    _isOpenLight = isOpenLight;
    if (isOpenLight) {
        self.backgroundColor = LIGHT_STATE;
    } else {
        self.backgroundColor = DARK_STATE;
    }
}

@end
