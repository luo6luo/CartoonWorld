//
//  RealmString.h
//  CartoonWorld
//
//  Created by dundun on 2018/5/29.
//  Copyright © 2018年 顿顿. All rights reserved.
//

#import <Realm/Realm.h>

@interface StringObject : RLMObject<NSCopying>

@property NSString *realmString;

@end

