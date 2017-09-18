//
//  ComicClickedModel.h
//  CartoonWorld
//
//  Created by dundun on 2017/9/4.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComicDetailModel : NSObject

@property (nonatomic, strong) NSString *click_total;    // 点击量
@property (nonatomic, assign) NSInteger comic_id;       // 漫画id
@property (nonatomic, assign) NSInteger favorite_total; // 收藏
@property (nonatomic, assign) NSInteger monthly_ticket; // 月票
@property (nonatomic, assign) NSInteger total_ticket;   // 累计月票

@end
