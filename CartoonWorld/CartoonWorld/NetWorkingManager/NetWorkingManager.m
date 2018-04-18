//
//  NetWorking.m
//  二次元境
//
//  Created by 顿顿 on 16/4/6.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "NetWorkingManager.h"
#import <MJExtension.h>

// 二次元
#import "AdvertisementModel.h"
#import "RecommendTypeModel.h"
#import "VIPTypeModel.h"

// 更多
#import "MoreTopicModel.h"

// 漫画
#import "ComicInfoModel.h"
#import "ComicModel.h"
#import "CatalogModel.h"
#import "OtherWorksModel.h"
#import "ComicDetailModel.h"
#import "CommentModel.h"
#import "GuessLikeModel.h"
#import "ComicContentModel.h"

//搜搜搜
#import "ClassificationRankListModel.h"
#import "ClassificationTopListModel.h"
#import "ClassificationTopLIstTabModel.h"
#import "SearchTabelViewModel.h"
#import "SearchHotModel.h"

@implementation NetWorkingManager

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Cannot be involked" reason:@"Singleton" userInfo:nil];
}

+ (instancetype)defualtManager
{
    static NetWorkingManager * singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!singleton) {
            singleton = [[self alloc] initSingleton];
        }
    });
    return singleton;
}

- (instancetype)initSingleton
{
    self.baseManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    self.baseManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    return self;
}

// 二次元推荐
- (void)recommendSuccess:(SuccessBlock)success  failure:(FailureBlock)failure
{
    [self.baseManager GET:Recommend_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"stateCode"] integerValue] == 1) {
                NSMutableArray * types = [NSMutableArray array];
                types.array = [RecommendTypeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"returnData"][@"comicLists"]];
                [types removeObjectAtIndex:0];
                NSArray * bannerArr = [AdvertisementModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"returnData"][@"galleryItems"]];
                
                if (bannerArr && types) {
                    NSDictionary * dataDic = @{
                      @"banners": bannerArr,
                      @"types": types
                    };
                    success(dataDic);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

// 二次元VIP
- (void)VIPSuccess:(SuccessBlock)success failure:(FailureBlock)failure
{
    [self.baseManager GET:VIP_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"stateCode"] integerValue] == 1) {
                NSArray * models = [VIPTypeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"returnData"][@"newVipList"]];
                success(models);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

// 二次元订阅
- (void)subscriptionWithPage:(NSInteger)page success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSDictionary *parameters = @{
      @"page": @(page)
    };
    [self.baseManager GET:Subscription_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"stateCode"] integerValue] == 1) {
                NSArray *models = [ComicModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"returnData"][@"comics"]];
                BOOL hasMore = [responseObject[@"data"][@"returnData"][@"hasMore"] boolValue];
                
                if (models) {
                    success(@{@"models": models, @"hasMore": @(hasMore)});
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

// 漫画目录
- (void)comicCatalogWithcomicID:(NSInteger)comicID success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [self.baseManager GET:Comic_Catalog_URL parameters:@{@"comicid": @(comicID)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"stateCode"] integerValue] == 1) {
                if (responseObject[@"data"][@"returnData"]) {
                    ComicInfoModel *comicInfoModel = [ComicInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"returnData"][@"comic"]];
                    NSArray *chapterList = [CatalogModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"returnData"][@"chapter_list"]];
                    NSArray *otherWorks = [OtherWorksModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"returnData"][@"otherWorks"]];
                    
                    if (chapterList && otherWorks) {
                        NSDictionary *info = @{
                          @"chapterList": chapterList,
                          @"comicInfoModel": comicInfoModel,
                          @"otherWorks": otherWorks
                        };
                        success(info);
                    }
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

// 漫画详情
- (void)comicDetailWitComicID:(NSInteger)comicId success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSDictionary *patameters = @{@"comicid": @(comicId)};
    [self.baseManager GET:Comic_Detail_URL parameters:patameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"stateCode"] integerValue] == 1) {
                if (responseObject[@"data"][@"returnData"]) {
                    ComicDetailModel *detailModel = [ComicDetailModel mj_objectWithKeyValues:responseObject[@"data"][@"returnData"][@"comic"]];
                    success(detailModel);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

// 漫画评论
- (void)comicCommentWithComicID:(NSInteger)comicId page:(NSInteger)page threadID:(NSInteger)threadId success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSDictionary *parameter = @{@"object_id": @(comicId), @"page": @(page), @"thread_id": @(threadId)};
    [self.baseManager GET:Comic_Comment_URL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"stateCode"] integerValue] == 1) {
                if (responseObject[@"data"][@"returnData"]) {
                    NSDictionary *dic = responseObject[@"data"][@"returnData"];
                    NSArray *models = [CommentModel mj_objectArrayWithKeyValuesArray:dic[@"commentList"]];
                    
                    if (models) {
                        NSDictionary *data = @{@"models": models, @"hasMore": dic[@"hasMore"]};
                        success(data);
                    }
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

// 猜你喜欢
- (void)comicGuessLikeWithComicID:(NSInteger)comicId success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [self.baseManager GET:Comic_GuessLike_URL parameters:@{@"comic_id": @(comicId)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"stateCode"] integerValue] == 1) {
                if (responseObject[@"data"][@"returnData"]) {
                    NSArray *guessLickModels = [GuessLikeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"returnData"][@"comics"]];
                    success(guessLickModels);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

// 漫画内容
- (void)comicContentSuccess:(SuccessBlock)success failure:(FailureBlock)failure
{
    [self.baseManager GET:Comic_Content_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"stateCode"] integerValue] == 1) {
                if (responseObject[@"data"][@"returnData"]) {
                    NSArray *data = responseObject[@"data"][@"returnData"];
                    NSMutableArray *dataArr = [NSMutableArray array];
                    [dataArr addObjectsFromArray:[ComicContentModel mj_objectArrayWithKeyValuesArray:data[0][@"image_list"]]];
                    [dataArr addObjectsFromArray:[ComicContentModel mj_objectArrayWithKeyValuesArray:data[1][@"image_list"]]];
                    success(dataArr);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

// 二次元更多漫画
- (void)moreComicWithPage:(NSInteger)page argCon:(NSInteger)argCon argName:(NSString *)argName argValue:(NSInteger)argValue success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSDictionary *parameters = @{@"argCon": @(argCon), @"argName": argName, @"argValue": @(argValue), @"page": @(page)};
    [self.baseManager GET:More_Comic_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"stateCode"] integerValue] == 1) {
                NSDictionary *data = responseObject[@"data"][@"returnData"];
                NSArray *models = [ComicModel mj_objectArrayWithKeyValuesArray:data[@"comics"]];
                
                if (models) {
                    NSDictionary *dataDic = @{
                      @"hasMore": data[@"hasMore"], // 是否还有更多
                      @"page": data[@"page"],       // 当前页数
                      @"promptInfo": data[@"defaultParameters"][@"defaultConTagType"], // 橘色问题提示
                      @"data": models // 数据
                    };
                    success(dataDic);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

// 二次元更多每日漫条
- (void)moreDailycomicsWithPage:(NSInteger)page argCon:(NSInteger)argCon argName:(NSString *)argName argValue:(NSInteger)argValue success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSDictionary *parameters = @{@"argCon": @(argCon), @"argName": argName, @"argValue": @(argValue), @"page": @(page)};
    [self.baseManager GET:More_dailycomics_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"stateCode"] integerValue] == 1) {
                NSDictionary *data = responseObject[@"data"][@"returnData"];
                NSArray *models = [ComicModel mj_objectArrayWithKeyValuesArray:data[@"comics"]];
                
                if (models) {
                    NSDictionary *dataDic = @{
                      @"hasMore": data[@"hasMore"], // 是否还有更多
                      @"page": data[@"page"],       // 当前页数
                      @"promptInfo": data[@"defaultParameters"][@"defaultConTagType"], // 橘色问题提示
                      @"data": models // 数据
                    };
                    success(dataDic);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

// 二次元专题更多
- (void)moreTopicWithArgCon:(NSInteger)argCon page:(NSInteger)page success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [self.baseManager GET:More_Topic_URL parameters:@{@"argCon": @(argCon), @"page": @(page)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"stateCode"] integerValue] == 1) {
                NSDictionary *data = responseObject[@"data"][@"returnData"];
                NSArray *moreOtherModels = [MoreTopicModel mj_objectArrayWithKeyValuesArray:data[@"comics"]];
                
                if (moreOtherModels) {
                    NSDictionary *dataDic = @{
                      @"models": moreOtherModels,
                      @"hasMore": data[@"hasMore"],
                      @"page": data[@"page"],
                    };
                    success(dataDic);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

// 搜索分类
- (void)searchClassificationSuccess:(SuccessBlock)success failure:(FailureBlock)failure
{
    [self.baseManager GET:Search_Classification_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"stateCode"] integerValue] == 1) {
                NSArray *classificationModel = [ClassificationRankListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"returnData"][@"rankingList"]];
                NSArray *classificationTopList = [ClassificationTopListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"returnData"][@"topList"]];
                
                if (classificationModel && classificationTopList) {
                    NSDictionary *data = @{@"rankingList": classificationModel, @"topList": classificationTopList};
                    success(data);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

// 热门搜索条
- (void)hotSearchSuccess:(SuccessBlock)success failure:(FailureBlock)failure
{
    [self.baseManager GET:Search_Hot_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"stateCode"] integerValue] == 1) {
                NSArray *searchHotArr = [SearchHotModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"returnData"]];
                success(searchHotArr);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

// 根据关键字搜索
- (void)searchWithString:(NSString *)string page:(NSInteger)page success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *searchStr = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{@"page": @(page), @"q": searchStr};
    [self.baseManager GET:Search_Value_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"stateCode"] integerValue] == 1) {
                NSDictionary *dic = responseObject[@"data"][@"returnData"];
                NSArray *comics = [ComicModel mj_objectArrayWithKeyValuesArray:dic[@"comics"]];
                
                if (comics.count > 0) {
                    NSDictionary *data = @{
                      @"comicNum": dic[@"comicNum"],
                      @"hasMore": dic[@"hasMore"],
                      @"comics": comics
                    };
                    success(data);
                }
            }
        }
        
        success(nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
