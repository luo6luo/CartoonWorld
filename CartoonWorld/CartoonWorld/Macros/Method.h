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


#endif /* Method_h */
