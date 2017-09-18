//
//  CatalogModel.h
//  CartoonWorld
//
//  Created by dundun on 2017/8/24.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatalogModel : NSObject

@property (nonatomic, strong) NSString *chapter_id;   // 章节id
@property (nonatomic, strong) NSString *name;         // 章节名
@property (nonatomic, strong) NSString *image_total;  // 总图片数
@property (nonatomic, strong) NSArray *imHightArr;    // 该章图片宽高数组
@property (nonatomic, assign) BOOL is_new;            // 是否是最新章节
@property (nonatomic, assign) NSInteger type;         // 章节类型（0：免费）
@property (nonatomic, assign) NSInteger release_time; // 发布时间
@property (nonatomic, assign) NSInteger pass_time;    // 更新时间

@end
