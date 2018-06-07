//
//  ComicDetailModel.h
//  CartoonWorld
//
//  Created by dundun on 2017/7/10.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComicInfoModel : NSObject

@property (nonatomic, strong) NSDictionary *author;        // 作者信息
@property (nonatomic, assign) NSInteger comic_id;          // 漫画id
@property (nonatomic, assign) NSInteger thread_id;         // 线程id（评论需要）
@property (nonatomic, strong) NSArray *theme_ids;          // 标签
@property (nonatomic, strong) NSString *descriptionStr;    // 作品描述
@property (nonatomic, strong) NSString *short_descriptionStr; // 短描述
@property (nonatomic, strong) NSString *cover;             // 封面
@property (nonatomic, strong) NSString *ori;               // 原封面
@property (nonatomic, strong) NSString *name;              // 名字
@property (nonatomic, assign) NSInteger last_update_time;  // 最新更新时间

@end
