//
//  Url.h
//  二次元境
//
//  Created by dundun on 17/4/12.
//  Copyright © 2017年 MS. All rights reserved.
//

#ifndef Url_h
#define Url_h

// 基础接口
#define BASE_URL @"http://app.u17.com/v3/appV3_3/ios/phone/"

// 二次元
#define Recommend_URL    @"comic/boutiqueListNew" // 推荐
#define VIP_URL          @"list/vipList"          // vip
#define Subscription_URL @"list/commonComicList"  // 订阅
#define Cartoon_URL      @"http://m.u17.com/wap/cartoon/list?" // 动画

// 二次元 - 更多
#define More_Comic_URL   @"list/commonComicList"   // 更多漫画
#define More_Topic_URL   @"comic/special"          // 更多专题

// 漫画介绍
#define Comic_Catalog_URL   @"comic/detail_static_new" // 漫画目录
#define Comic_Detail_URL    @"comic/detail_realtime"   // 漫画详情
#define Comic_Comment_URL   @"comment/list"            // 漫画评价
#define Comic_GuessLike_URL @"comic/guessLike"         // 猜你喜欢




//漫画介绍
#define ManHuaJieShao_URL @"http://app.u17.com/v3/app/android/phone/comic/detail_static?comicid=%ld&t=1448367030&v=2220099"
//漫画内容
#define ManHuaNeiRong_URL @"http://app.u17.com/v3/app/android/phone/comic/chapter?chapter_id=%ld&t=1448367544&v=2220099"



//中二堆-精华
#define ZED_Essence_URL @"http://api.zhuizhuiyoyo.com/request.php?method=topics%2Flist&timestamp=1449131214099&param=%7B%22count%22%3A20%2C%22page%22%3A1%2C%22tag%22%3A%22best%22%7D&sig=323001f726f9195150db5ce1ca2473e9"
//中二堆-同人
#define ZED_Colleague_URL @"http://api.zhuizhuiyoyo.com/request.php?method=topics%2Flist&timestamp=1449131561167&param=%7B%22count%22%3A20%2C%22type%22%3A4%2C%22page%22%3A1%7D&sig=a7aa05360110be3e2c23d951f8d9480a"
//中二堆-cos
#define ZED_COS_URL @"http://api.zhuizhuiyoyo.com/request.php?method=topics%2Flist&timestamp=1449131515957&param=%7B%22count%22%3A20%2C%22type%22%3A12%2C%22page%22%3A1%7D&sig=efa97477f72b05e69fda7063d6563fcc"
//中二堆-资源
#define ZED_Source_URL @"http://api.zhuizhuiyoyo.com/request.php?method=topics%2Flist&timestamp=1449131446303&param=%7B%22count%22%3A20%2C%22type%22%3A7%2C%22page%22%3A1%7D&sig=956e575d2abdb4f4ff380cd093f1bebe"
//中二堆-吐槽
#define ZED_Debunk_URL @"http://api.zhuizhuiyoyo.com/request.php?method=topics%2Flist&timestamp=1449131388820&param=%7B%22count%22%3A20%2C%22type%22%3A1%2C%22page%22%3A1%7D&sig=85e08e8cd48dae064fd5f7a473ee8a3b"


//搜搜搜(搜索热门)
#define SSS_search_URL @"http://app.u17.com/v3/app/android/phone/search/hotkeywords?t=1448370111&v=2220099"
//搜搜搜(打上汉字检索到的漫画名字)
#define SSS_search_Write_URL @"http://app.u17.com/v3/app/android/phone/search/relative?inputText=%@&t=1448368607&v=2220099"
//搜搜搜(打上汉子,按确定键检索到的漫画)
#define SSS_search_Sure_URL @"http://app.u17.com/v3/app/android/phone/search/rslist?q=%@&page=%ld&t=1448369103&v=2220099"


//说说看-最新
#define SSK_Latest_URL @"http://api.zhuizhuiyoyo.com/request.php?method=welfare%2Flist&timestamp=1449627118965&param=%7B%22count%22%3A20%2C%22o%22%3A%22n%22%2C%22page%22%3A1%2C%22user_id%22%3A0%7D&sig=47e5b0a2488caab52689eb9769c71041"
//说说看-最热
#define SSK_Hotest_URL @"http://api.zhuizhuiyoyo.com/request.php?method=welfare%2Flist&timestamp=1447764577896&param=%7B%22count%22%3A20%2C%22o%22%3A%22h%22%2C%22page%22%3A1%2C%22user_id%22%3A0%7D&sig=a15ce7ff34477d595cd557391dafc290"

#endif /* Url_h */
