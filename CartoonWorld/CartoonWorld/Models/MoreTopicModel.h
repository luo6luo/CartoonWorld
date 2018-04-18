//
//  MoreOtherModel.h
//  CartoonWorld
//
//  Created by dundun on 2017/8/18.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoreTopicModel : NSObject

@property (nonatomic, assign) BOOL canToolBarShare;     // 是否显示条
@property (nonatomic, strong) NSString *cover;          // 封面
@property (nonatomic, strong) NSString *descriptionStr; // 描述
@property (nonatomic, strong) NSString *subTitle;       // 提示条的内容
@property (nonatomic, strong) NSString *title;          // 标题
@property (nonatomic, strong) NSString *url;            // 网页链接

@property (nonatomic, assign) NSInteger specialId;      // 专题id
@property (nonatomic, assign) NSInteger specialType;    // 专题类型

@property (nonatomic, assign) NSInteger comicId;        // 漫画id

@end
