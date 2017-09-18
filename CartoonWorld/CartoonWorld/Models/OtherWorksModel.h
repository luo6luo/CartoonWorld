//
//  OtherWorksModel.h
//  CartoonWorld
//
//  Created by dundun on 2017/8/24.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OtherWorksModel : NSObject

@property (nonatomic, assign) NSInteger comicId;        // 作品id
@property (nonatomic, strong) NSString *coverUrl;       // 作品封面
@property (nonatomic, strong) NSString *name;           // 作品名称
@property (nonatomic, assign) NSInteger passChapterNum; // 最新章节

@end
