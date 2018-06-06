//
//  Method.h
//  CartoonWorld
//
//  Created by dundun on 2017/6/30.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#ifndef Method_h
#define Method_h

// 强弱引用
#define WeakSelf(type)  __weak typeof(type) weak##type = type;     // weak
#define StrongSelf(type)  __strong typeof(type) type = weak##type; // strong

// 系统版本判断
#define SYSTEM_VERSION_LESS_THAN(ver) ([[[UIDevice currentDevice] systemVersion] compare:ver options:NSNumericSearch] == NSOrderedAscending) // 小于ver
#define SYSTEM_VERSION_SAME_THAN(ver) ([[[UIDevice currentDevice] systemVersion] compare:ver options:NSNumericSearch] == NSOrderedSame) // 等于ver
#define SYSTEM_VERSION_MORE_THAN(ver) ([[[UIDevice currentDevice] systemVersion] compare:ver options:NSNumericSearch] == NSOrderedDescending) // 大于ver

// NSUserDefaults
#define GET_USER_DEFAULTS(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define SET_USER_DEFAULTS(obj, key) [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key]

// app版本号
#define VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#endif /* Method_h */
