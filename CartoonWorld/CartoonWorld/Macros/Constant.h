//
//  Constant.h
//  二次元境
//
//  Created by dundun on 17/4/12.
//  Copyright © 2017年 MS. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

// 判断设备
#define iPhone4S     ((SCREEN_WIDTH == 320) && (SCREEN_HEIGHT == 480))
#define iPhone5S     ((SCREEN_WIDTH == 320) && (SCREEN_HEIGHT == 568))
#define iPhone6S     ((SCREEN_WIDTH == 375) && (SCREEN_HEIGHT == 667))
#define iPhone6_Plus ((SCREEN_WIDTH == 414) && (SCREEN_HEIGHT == 736))
#define iPhoneX      ((SCREEN_WIDTH == 375) && (SCREEN_HEIGHT == 812))

// 屏幕大小
#define SCREEN_SIZE   [[UIScreen mainScreen] bounds].size
#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_CONTENT_HEITH_V (SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT_V) // 竖屏实际显示高度
#define SCREEN_CONTENT_HEITH_H (SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT_H) // 横屏实际显示高度

// 控件
#define TABBAR_HEIGHT      (iPhoneX ? 83:49)     // tabBar高度
#define STATUSBAR_HEIGHT   (iPhoneX ? 44:20)     // 状态栏高度
#define NAVIGATIONBAR_HEIGHT_V (iPhoneX ? 88:64) // 竖屏navigationBar高度(包含了statusBar)
#define NAVIGATIONBAR_HEIGHT_H 32 // 横屏navigationBar高度(包含了statusBar)
#define CORNERRADIUS  5   // 切圆角大小
#define LABEL_HEIGHT  20  // label高
#define ICON_HEIGHT   30  // 图标高宽
#define LINE_HEIGHT   1   // 分割线高度


// 二次元
#define VERTICAL_CELL_HEIGHT      (SCREEN_WIDTH - 4*LEFT_RIGHT) * 1/2 // 竖的cell高
#define VERTICAL_CELL_WIDTH       (SCREEN_WIDTH - 4*LEFT_RIGHT) / 3   // 竖的cell宽
#define HORIZONTAL_CELL_HEIGHT    (SCREEN_WIDTH - 3*LEFT_RIGHT) * 2/5 // 横的cell高
#define HORIZONTAL_CELL_WIDTH     (SCREEN_WIDTH - 3*LEFT_RIGHT) / 2   // 横的cell宽
#define SUBSCRIPTION_CELL_HEIGHT  (VERTICAL_CELL_HEIGHT - 2*LABEL_HEIGHT + 2*TOP_BOTTOM) // 订阅cell的高
#define AD_HEADER_HEIGHT          SCREEN_WIDTH * 1/2   // 广告头高
#define TITLE_HEADER_HEIGHT       40                   // 标题头高度
#define MOREBTN_SIZE              CGSizeMake(30, 20)   // 更多按钮

// 更多
#define HEIGHT_CELL_MORECOMIC     VERTICAL_CELL_HEIGHT // 更多漫画
#define HEIGHT_CELL_MOREOTHER     SCREEN_WIDTH * 3/5   // 更多专题（条漫）

// 漫画
#define HEIGHT_HEADER_CATALOG      44
#define HEIGHT_CELL_CATALOG        30
#define HEIGHT_CELL_OTHERWORK      44
#define HEIGHT_CELL_MONTHLYTICKET  44
#define HEIGHT_CELL_GUESSLIKE      150
#define HEIGHT_HEADER_COMICDETAIL  (VERTICAL_CELL_HEIGHT - LABEL_HEIGHT + 5*TOP_BOTTOM) + NAVIGATIONBAR_HEIGHT_V // 漫画详情头
#define HEIGHT_MENU_ITEM           40
#define HEIGHT_MENU_BAR            (3*TOP_BOTTOM + LABEL_HEIGHT + HEIGHT_MENU_ITEM)

// 搜索
#define HEIGHT_CELL_RANKLIST      (SCREEN_WIDTH - 4*LEFT_RIGHT) / 3 // 分类排行高
#define HEIGHT_CELL_TOPLIST       (SCREEN_WIDTH - 4*LEFT_RIGHT) / 6 // 分类顶部列表高
#define HEIGHT_CELL_SEARCH_HOT       40  // 热搜
#define HEIGHT_HEADER_SEARCH_HISTORY 40  // 搜索历史头
#define HEIGHT_HEADER_SEARCH_HOT     40  // 热搜头
#define HEIGHT_HEADER_SEARCH_RESULT  40  // 搜索结果头
#define SEARCH_BAR_HEIGHT            25  // 搜索条高度
#define TAG_BUTTON_HEIGHT            25  // 标签按钮高度

// 我的
#define HEIGHT_CELL_HEADER           100 // 用户信息
#define HEIGHT_CELL_OTHER            44  // 其他
#define HEIGHT_WIDTH_USER_HEADER     60  // 用户头像
#define HEIGHT_CELL_INPUT            44  // 输入框
#define HEIGHT_OF_BUTTON             45  // 提交按钮高度
#define SURE_BUTTON_HEIGHT           40  // 确定标签按钮

// section
#define HEIGHT_SECTION_MIN   0.01  // 最小高度
#define HEIGHT_SECTION_MAX   10.0  // 最大高度

#endif /* Constant_h */
