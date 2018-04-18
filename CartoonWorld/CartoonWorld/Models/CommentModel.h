//
//  CommentModel.h
//  CartoonWorld
//
//  Created by dundun on 2017/9/5.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (nonatomic, strong) NSString *create_time_str; // 创建时间
@property (nonatomic, strong) NSString *content_filter;  // 内容
@property (nonatomic, strong) NSString *face;            // 头像
@property (nonatomic, strong) NSString *nickname;        // 昵称
@property (nonatomic, strong) NSString *likeCount;       // 喜欢数

@end
