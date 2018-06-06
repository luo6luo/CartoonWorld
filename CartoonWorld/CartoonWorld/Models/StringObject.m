//
//  RealmString.m
//  CartoonWorld
//
//  Created by dundun on 2018/5/29.
//  Copyright © 2018年 顿顿. All rights reserved.
//

#import "StringObject.h"

@implementation StringObject

- (id)copyWithZone:(NSZone *)zone
{
    StringObject *obj = [[[self class] allocWithZone:zone] init];
    obj.realmString = self.realmString;
    return obj;
}

@end
