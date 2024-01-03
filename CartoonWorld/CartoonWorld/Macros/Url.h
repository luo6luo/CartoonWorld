//
//  Url.h
//  二次元境
//
//  Created by dundun on 17/4/12.
//  Copyright © 2017年 MS. All rights reserved.
//

#ifndef Url_h
#define Url_h

/*
 此处特别说明：
 AFNetWorking库中，在拼接完整的URL时候，使用了下诉方法：
 [NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString]
 
 该方法有一个注意的地方，拼接的 URLString 不能带 ”/“，否则会把 baseURL 修改了
 eg: self.baseURL = [NSURL URLWithString:@"http://eg.com/v1/"]
 URLString : /foo  -->  http://eg.com/foo
             /foo/ -->  http://eg.com/foo/
             foo   -->  http://eg.com/v1/foo
             foo/  -->  http://eg.com/v1/foo
 
 此处很容易就把URL给拼错了。。。
 */

// 基础接口
#define BASE_URL @"https://easy-mock.com/mock/5ac98c186db1e91cf4558443/cartoon"

// 二次元
#define Recommend_URL      @"home/recommend"     // 推荐
#define VIP_URL            @"home/vip"           // vip
#define Subscription_URL   @"home/subscription"  // 订阅
#define Cartoon_URL        @"http://m.u17.com/wap/cartoon/list?" // 动画（网页）
#define Special_Detail_URL @"http://www.u17.com/z/zt/appspecial/special_comic_list_v3.html?special_id=%ld" // 专题详情（网页）

// 二次元 - 更多
#define More_Comic_URL       @"home/recommend/more/others"      // 更多漫画
#define More_Topic_URL       @"home/recommend/more/topics"      // 更多专题
#define More_dailycomics_URL @"home/recommend/more/dailycomics" // 更多每日条漫

// 漫画介绍
#define Comic_Catalog_URL   @"comic/catalog"   // 漫画目录
#define Comic_Detail_URL    @"comic/detail"    // 漫画详情
#define Comic_Comment_URL   @"comic/comment"   // 漫画评价
#define Comic_GuessLike_URL @"comic/guesslike" // 猜你喜欢
#define Comic_Content_URL   @"comic/content"   // 漫画内容

// 搜索
#define Search_Classification_URL @"search/classification" // 分类搜索
#define Search_Hot_URL            @"search/hotkeywords"    // 热门搜索
#define Search_Value_URL          @"search/value"          // 值搜索

#endif /* Url_h */
