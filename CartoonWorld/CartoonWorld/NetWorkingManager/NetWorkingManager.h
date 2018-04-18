//
//  NetWorking.h
//  二次元境
//
//  Created by 顿顿 on 16/4/6.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef void(^SuccessBlock)(id responseBody);
typedef void(^FailureBlock)(NSError * error);

@interface NetWorkingManager : NSObject

@property (nonatomic, strong) AFHTTPSessionManager * baseManager;

+ (instancetype)defualtManager;

/**
 二次元推荐

 @param success 请求成功
 @param failure 请求失败
 */
- (void)recommendSuccess:(SuccessBlock)success
                 failure:(FailureBlock)failure;

/**
 二次元VIP

 @param success 请求成功
 @param failure 请求失败
 */
- (void)VIPSuccess:(SuccessBlock)success
           failure:(FailureBlock)failure;

/**
 二次元订阅

 @param page    页数
 @param success 请求成功
 @param failure 请求失败
 */
- (void)subscriptionWithPage:(NSInteger)page
                     success:(SuccessBlock)success
                     failure:(FailureBlock)failure;

/**
 漫画目录
 
 @param comicID  漫画id
 @param success  请求成功
 @param failure  请求失败
 */
- (void)comicCatalogWithcomicID:(NSInteger)comicID
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure;


/**
 漫画详情

 @param comicId 漫画id
 @param success 请求成功
 @param failure 请求失败
 */
- (void)comicDetailWitComicID:(NSInteger)comicId
                      success:(SuccessBlock)success
                      failure:(FailureBlock)failure;


/**
 漫画评论

 @param comicId  漫画id
 @param page     当前页
 @param threadId 线程id
 @param success  请求成功
 @param failure  请求失败
 */
- (void)comicCommentWithComicID:(NSInteger)comicId
                           page:(NSInteger)page
                       threadID:(NSInteger)threadId
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure;


/**
 漫画猜你更多

 @param comicId 漫画id
 @param success 请求成功
 @param failure 请求失败
 */
- (void)comicGuessLikeWithComicID:(NSInteger)comicId
                          success:(SuccessBlock)success
                          failure:(FailureBlock)failure;


/**
 漫画内容

 @param success 请求成功
 @param failure 请求失败
 */
- (void)comicContentSuccess:(SuccessBlock)success
                    failure:(FailureBlock)failure;


/**
 更多漫画

 @param page     当前页数
 @param argCon  （不知道）
 @param argName  类型名称
 @param argValue 类型值
 @param success  请求成功
 @param failure  请求失败
 */
- (void)moreComicWithPage:(NSInteger)page
                   argCon:(NSInteger)argCon
                  argName:(NSString *)argName
                 argValue:(NSInteger)argValue
                  success:(SuccessBlock)success
                  failure:(FailureBlock)failure;


/**
 更多每日漫条

 @param page     当前页数
 @param argCon   不知道）
 @param argName  类型名称
 @param argValue 类型值
 @param success  请求成功
 @param failure  请求失败
 */
- (void)moreDailycomicsWithPage:(NSInteger)page
                         argCon:(NSInteger)argCon
                        argName:(NSString *)argName
                       argValue:(NSInteger)argValue
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure;


/**
 更多专题

 @param argCon   标识类型
 @param page     当前页数
 @param success  请求成功
 @param failure  请求失败
 */
- (void)moreTopicWithArgCon:(NSInteger)argCon
                       page:(NSInteger)page
                    success:(SuccessBlock)success
                    failure:(FailureBlock)failure;


/**
 分类搜索

 @param success  请求成功
 @param failure  请求失败
 */
- (void)searchClassificationSuccess:(SuccessBlock)success
                            failure:(FailureBlock)failure;



/**
 热门搜索条

 @param success 请求成功
 @param failure 请求失败
 */
- (void)hotSearchSuccess:(SuccessBlock)success
                 failure:(FailureBlock)failure;


/**
 根据关键字搜索

 @param string  搜索关键字
 @param page    搜索页面
 @param success 请求成功
 @param failure 请求失败
 */
- (void)searchWithString:(NSString *)string
                    page:(NSInteger)page
                 success:(SuccessBlock)success
                 failure:(FailureBlock)failure;

@end
