//
//  GuessLickModel.h
//  CartoonWorld
//
//  Created by dundun on 2017/9/6.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuessLikeModel : NSObject

@property (nonatomic, strong) NSString *cover;    // 作品封面
@property (nonatomic, assign) NSInteger comic_id; // 作品id
@property (nonatomic, strong) NSString *name;     // 作品名称

@end
