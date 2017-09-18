//
//  RecommendModel.m
//  二次元境
//
//  Created by MS on 15/11/20.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "RecommendTypeModel.h"
#import "AdvertisementModel.h"
#import "ComicModel.h"

@implementation RecommendTypeModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"titleIcon": @"newTitleIconUrl", @"descriptionStr": @"description"};
}

- (void)setComics:(NSArray *)comics
{
    if (self.comicType == 5 || self.comicType == 9) {
        _comics = [AdvertisementModel mj_objectArrayWithKeyValuesArray:comics];
    } else {
        _comics = [ComicModel mj_objectArrayWithKeyValuesArray:comics];
    }
}

@end


