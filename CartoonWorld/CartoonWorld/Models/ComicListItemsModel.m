//
//  ComicListItemsModel.m
//  二次元境
//
//  Created by 顿顿 on 16/4/6.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "ComicListItemsModel.h"

@implementation ComicListItemsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"myDescription":@"description"};
}

@end
