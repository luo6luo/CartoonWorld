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

// 漫画
#import "ComicInfoModel.h"
#import "ComicModel.h"
#import "CatalogModel.h"
#import "OtherWorksModel.h"
#import "ComicDetailModel.h"
#import "CommentModel.h"
#import "GuessLikeModel.h"

// 更多
#import "MoreTopicModel.h"

#import "InformationModel.h"
#import "IntroductionModel.h"
#import "CartoonModel.h"
#import "ReadModel.h"

//搜搜搜
#import "HotSearchModel.h"
#import "SearchTabelViewModel.h"

//中二堆
#import "BaseModel.h"

//绘画控
#import "BaseCollectionModel.h"

//小爷me

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
    NSDictionary *parameter = @{@"sexType": @(2), @"target": @"U17_3.0", @"v": @(3320101), @"version": @"3.3.3"};
    [self.baseManager GET:Recommend_URL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"stateCode"] integerValue] == 1) {
                NSMutableArray * types = [NSMutableArray array];
                types.array = [RecommendTypeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"returnData"][@"comicLists"]];
                [types removeObjectAtIndex:0];
                NSArray * bannerArr = [AdvertisementModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"returnData"][@"galleryItems"]];
                
                NSDictionary * dataDic = @{
                  @"banners": bannerArr,
                  @"types": types
                };
                success(dataDic);
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
      @"argCon": @(0),
      @"argName": @"topic",
      @"argValue": @(12),
      @"page": @(page)
    };
    [self.baseManager GET:Subscription_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"stateCode"] integerValue] == 1) {
                NSArray *models = [ComicModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"returnData"][@"comics"]];
                BOOL hasMore = [responseObject[@"data"][@"returnData"][@"hasMore"] boolValue];
                success(@{@"models": models, @"hasMore": @(hasMore)});
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
                    
                    NSDictionary *info = @{
                      @"chapterList": chapterList,
                      @"comicInfoModel": comicInfoModel,
                      @"otherWorks": otherWorks
                    };
                    success(info);
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
    NSDictionary *patameters = @{@"comicid": @(comicId), @"target": @"U17_3.0", @"version": @"3.3.3"};
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
    NSDictionary *parameter = @{@"android_id": @"iphone", @"object_id": @(comicId), @"page": @(page), @"thread_id": @(threadId)};
    [self.baseManager GET:Comic_Comment_URL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"stateCode"] integerValue] == 1) {
                if (responseObject[@"data"][@"returnData"]) {
                    NSDictionary *dic = responseObject[@"data"][@"returnData"];
                    NSArray *models = [CommentModel mj_objectArrayWithKeyValuesArray:dic[@"commentList"]];
                    NSDictionary *data = @{@"models": models, @"hasMore": dic[@"hasMore"]};
                    success(data);
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

// 二次元更多漫画
- (void)moreComicWithPage:(NSInteger)page argCon:(NSInteger)argCon argName:(NSString *)argName argValue:(NSInteger)argValue success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSDictionary *parameters = @{@"argCon": @(argCon), @"argName": argName, @"argValue": @(argValue), @"page": @(page)};
    [self.baseManager GET:More_Comic_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"stateCode"] integerValue] == 1) {
                NSDictionary *data = responseObject[@"data"][@"returnData"];
                NSArray *models = [ComicModel mj_objectArrayWithKeyValuesArray:data[@"comics"]];
                NSDictionary *dataDic = @{
                  @"hasMore": data[@"hasMore"], // 是否还有更多
                  @"page": data[@"page"],       // 当前页数
                  @"promptInfo": data[@"defaultParameters"][@"defaultConTagType"], // 橘色问题提示
                  @"data": models // 数据
                };
                success(dataDic);
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
                NSDictionary *dataDic = @{
                  @"models": moreOtherModels,
                  @"hasMore": data[@"hasMore"],
                  @"page": data[@"page"],
                };
                success(dataDic);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

/**漫画阅读*/
- (void)readCortoonWithChapterId:(NSInteger)chapterId success:(SuccessBlock)success failure:(FailureBlock)failure
{
//    NSString * pathURL = [NSString stringWithFormat:ManHuaNeiRong_URL,chapterId];
//    [self.baseManager GET:pathURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSArray * dataArr = [ReadModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"returnData"]];
//        success(dataArr);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(error);
//    }];
}

/**热门搜索条*/
- (void)hotSearchSuccess:(SuccessBlock)success failure:(FailureBlock)failure
{
//    [self.baseManager GET:SSS_search_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSArray * dataArr = [HotSearchModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"returnData"]];
//        success(dataArr);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(error);
//    }];
}

/**根据关键字搜索*/
- (void)searchWithString:(NSString *)string page:(NSInteger)page success:(SuccessBlock)success failure:(FailureBlock)failure
{
//    NSString * str=[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString * url = [NSString stringWithFormat:SSS_search_Sure_URL,str,(long)page];
//    [self.baseManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSArray * dataArr = [SearchTabelViewModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"returnData"][@"comicList"]];
//        NSString * comicNum = responseObject[@"data"][@"returnData"][@"comicNum"];
//        NSDictionary * dataDic = @{@"array":dataArr,
//                                   @"num":comicNum};
//        success(dataDic);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(error);
//    }];
}

/**中二堆*/
- (void)zhongErWithURL:(NSString *)url success:(SuccessBlock)success failure:(FailureBlock)failure
{
//    [self.baseManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSArray * dataArr = [BaseModel mj_objectArrayWithKeyValuesArray:responseObject[@"topics"]];
//        success(dataArr);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(error);
//    }];
}

/**绘图控*/
- (void)drawWithURL:(NSString *)url success:(SuccessBlock)success failure:(FailureBlock)failure
{
//    [self.baseManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull operation, id  _Nonnull responseObject) {
//        NSArray * dataArr = [BaseCollectionModel mj_objectArrayWithKeyValuesArray:responseObject[@"welfares"]];
//        success(dataArr);
//    } failure:^(NSURLSessionDataTask * _Nullable operation, NSError * _Nonnull error) {
//        failure(error);
//    }];
}

@end
