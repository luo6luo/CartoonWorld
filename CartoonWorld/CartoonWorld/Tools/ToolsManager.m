//
//  ToolsManager.m
//  二次元境
//
//  Created by dundun on 17/4/12.
//  Copyright © 2017年 MS. All rights reserved.
//

#import "ToolsManager.h"

@implementation ToolsManager

+ (BOOL)isPad
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return NO;
    }
}

@end
