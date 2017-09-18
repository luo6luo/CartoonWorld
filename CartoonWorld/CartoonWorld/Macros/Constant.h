//
//  Constant.h
//  二次元境
//
//  Created by dundun on 17/4/12.
//  Copyright © 2017年 MS. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

// 设备的屏幕尺寸
#define iPhone4S     ((Width == 320) && (Height == 480))
#define iPhone5S     ((Width == 320) && (Height == 568))
#define iPhone6S     ((Width == 375) && (Height == 667))
#define iPhone6_Plus ((Width == 414) && (Height == 736))

// 屏幕大小
#define SCREEN_SIZE   [[UIScreen mainScreen] bounds].size
#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define HEIGHT_OF_TABBAR self.tabBarController.tabBar.bounds.size.height

// 控件
#define CORNERRADIUS 5
#define LABEL_HEIGHT 20
#define ICON_HEIGHT  30
#define MOREBTN_SIZE CGSizeMake(30, 20)

// 二次元
#define VERTICAL_CELL_HEIGHT      (SCREEN_WIDTH - 4*LEFT_RIGHT) * 1/2                  // 竖的cell高
#define VERTICAL_CELL_WIDTH       (SCREEN_WIDTH - 4*LEFT_RIGHT) / 3                    // 竖的cell宽
#define HORIZONTAL_CELL_HEIGHT    (SCREEN_WIDTH - 3*LEFT_RIGHT) * 2/5                  // 横的cell高
#define HORIZONTAL_CELL_WIDTH     (SCREEN_WIDTH - 3*LEFT_RIGHT) / 2                    // 横的cell宽
#define SUBSCRIPTION_CELL_HEIGHT  VERTICAL_CELL_HEIGHT - 2*LABEL_HEIGHT + 2*TOP_BOTTOM // 订阅cell的高
#define AD_HEADER_HEIGHT          SCREEN_WIDTH * 1/2                                   // 广告头高
#define TITLE_HEADER_HEIGHT       40                                                   // 标题头高度

// 更多
#define HEIGHT_CELL_MORECOMIC     VERTICAL_CELL_HEIGHT // 更多漫画
#define HEIGHT_CELL_MOREOTHER     SCREEN_WIDTH * 3/5   // 更多专题（条漫）

// 漫画
#define HEIGHT_HEADER_COMICDETAIL  SCREEN_WIDTH * 2/3  // 漫画详情头
#define HEIGHT_HEADER_CATALOG      44
#define HEIGHT_CELL_CATALOG        30
#define HEIGHT_CELL_MONTHLYTICKET  44
#define HEIGHT_CELL_GUESSLIKE      150

// section
#define HEIGHT_SECTION_MIN   0.01  // 最小高度
#define HEIGHT_SECTION_MAX   10.0  // 最大高度

#endif /* Constant_h */
