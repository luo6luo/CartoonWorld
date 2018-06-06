//
//  ComicModel.h
//  二次元境
//
//  Created by 顿顿 on 16/4/8.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <Realm/Realm.h>
//@class UserModel;

@interface ComicModel : RLMObject<NSCopying>

// 共有
@property NSInteger comicId;           // 漫画id
@property NSString *cover;             // 漫画封面
@property NSString *name;              // 漫画名
@property (nonatomic ,assign) NSInteger newestChapter;     // 最新章节
@property (nonatomic ,strong) NSString *descriptionStr;    // 描述
@property (nonatomic ,assign) NSInteger is_vip;
@property (nonatomic, strong) NSArray *tags;               // 漫画标签

// 二次元-推荐
@property (nonatomic, strong) NSString *author_name;       // 作者
@property NSString *cornerInfo;        // 最新章节

// 漫画列表，二次元-订阅
@property (nonatomic ,assign) NSInteger conTag;            // 数量
@property (nonatomic ,strong) NSString *author;            // 作者

@end

