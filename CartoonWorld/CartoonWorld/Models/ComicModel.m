//
//  ComicModel.m
//  二次元境
//
//  Created by 顿顿 on 16/4/8.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "ComicModel.h"

@implementation ComicModel

- (id)copyWithZone:(NSZone *)zone
{
    ComicModel *comicModel = [[[self class] allocWithZone:zone] init];
    comicModel.comicId = self.comicId;
    comicModel.cover = self.cover;
    comicModel.name = self.name;
    comicModel.cornerInfo = self.cornerInfo;
    return comicModel;
}

// 设置忽略属性
+ (NSArray<NSString *> *)ignoredProperties
{
    return @[@"descriptionStr", @"is_vip", @"tags", @"author_name", @"newestChapter", @"conTag", @"author"];
}

@end
