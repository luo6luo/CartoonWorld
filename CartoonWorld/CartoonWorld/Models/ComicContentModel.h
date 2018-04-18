//
//  ComicContent.h
//  CartoonWorld
//
//  Created by dundun on 2018/4/12.
//  Copyright © 2018年 顿顿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComicContentModel : NSObject

@property (nonatomic, assign) CGFloat height; // 图片高
@property (nonatomic, assign) CGFloat width;  // 图片宽
@property (nonatomic, assign) NSInteger image_id; // 图片的id
@property (nonatomic, assign) NSInteger type;     // 图片类型
@property (nonatomic, assign) NSInteger total_tucao;
@property (nonatomic, strong) NSString *img50;
@property (nonatomic, strong) NSString *img05;    // 图片url
@property (nonatomic, strong) NSString *location; // 下载图片url
@property (nonatomic, strong) NSArray *images; // 图片信息

@end
