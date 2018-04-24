//
//  ComicContent.m
//  CartoonWorld
//
//  Created by dundun on 2018/4/12.
//  Copyright © 2018年 顿顿. All rights reserved.
//

#import "ComicContentModel.h"

@implementation ComicContentModel

- (void)setHeight:(CGFloat)height
{
    _height = height;
    if (height > 0 && _width > 0) {
        self.showHeight = SCREEN_WIDTH * (_height/_width);
    }
}

- (void)setWidth:(CGFloat)width
{
    _width = width;
    if (width > 0 && _height > 0) {
        self.showHeight = SCREEN_WIDTH * (_height/_width);
    }
}

@end
