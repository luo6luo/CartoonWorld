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
@property (nonatomic, assign) CGFloat showHeight; // 图片屏幕上显示的高（默认是竖屏的高度）
@property (nonatomic, assign) NSInteger image_id; // 图片的id
@property (nonatomic, assign) NSInteger type;     // 图片类型
@property (nonatomic, assign) NSInteger total_tucao;
@property (nonatomic, strong) NSString *img50;
@property (nonatomic, strong) NSString *img05;
@property (nonatomic, strong) NSString *location; // 图片url
@property (nonatomic, strong) NSArray *images; // 图片信息

@end
