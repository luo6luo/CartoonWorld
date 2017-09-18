//
//  RecommendScrollModel.m
//  二次元境
//
//  Created by MS on 15/11/19.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "RecommendWebModel.h"

//红色字体的model
@implementation RecommendWebModel

+ (RecommendWebModel *)modelWithDic:(NSDictionary *)dic {
    return [[RecommendWebModel alloc] initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary * )dic {
    if (self = [super init]) {
        _name = dic[@"name"];
        _theme_list = dic[@"theme_list"];
        _comics = dic[@"comics"];
        _content_lists = dic[@"content_lists"];
    }
    return self;
}

@end
//theme_list数组里面的内容
@implementation Theme_ListModel

+ (Theme_ListModel *)modelWithDic:(NSDictionary *)dic {
    return [[Theme_ListModel alloc] initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary * )dic {
    if (self = [super init]) {
        _cover = dic[@"cover"];
        _name = dic[@"name"];
        _url = dic[@"url"];
    }
    return self;
}
@end




//绿色字体的model
@implementation RecommendViewModel

+ (RecommendViewModel *)modelWithDic:(NSDictionary *)dic {
    return [[RecommendViewModel alloc] initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        _name = dic[@"name"];
        _theme_list = dic[@"theme_list"];
        _comics = dic[@"comics"];
        _content_lists = dic[@"content_lists"];
    }
    return self;
}

@end
//comics数组里面的内容
@implementation ComicsModel

+ (ComicsModel *)modelWithDic:(NSDictionary *)dic {
    return [[ComicsModel alloc] initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        _cover_img = dic[@"cover_img"];
        _last_volume = dic[@"last_volume"];
        _name = dic[@"name"];
    }
    return self;
}
@end


//专辑model
@implementation RecommendZJModel

+ (RecommendZJModel *)modelWithDic:(NSDictionary *)dic {
    return [[RecommendZJModel alloc] initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        _name = dic[@"name"];
        _theme_list = dic[@"theme_list"];
        _comics = dic[@"comics"];
        _content_lists = dic[@"content_lists"];
    }
    return self;
}
@end
//专辑里面的model
@implementation Content_listsModel

+ (Content_listsModel *)modelWithDic:(NSDictionary *)dic {
    return [[Content_listsModel alloc] initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        _title = dic[@"title"];
        _covers = dic[@"covers"];
    }
    return self;
}

@end