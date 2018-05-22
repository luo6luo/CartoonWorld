//
//  Colors.h
//  二次元境
//
//  Created by dundun on 17/4/12.
//  Copyright © 2017年 MS. All rights reserved.
//

#ifndef Colors_h
#define Colors_h

// 获取RGB颜色
#define RGBA(r,g,b,a)   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define COLOR_WHITE         [UIColor whiteColor] // 白色
#define COLOR_PINK          RGB(249, 116, 154)   // 红色
#define COLOR_ORANGE        RGB(243, 133, 59)    // 橘色

// 背景
#define COLOR_APP_LINE    RGB(229, 229, 229) // 分割线颜色
#define COLOR_CELL_BACk   RGB(245, 245, 245) // cell背景色
#define COLOR_BACK_GRAY   RGB(247, 247, 247) // 灰色背景颜色
#define COLOR_IMAGE_BACK  RGB(245, 245, 245) // 灰色背景颜色
#define COLOR_BACK_WHITE  [RGBColor colorWithHexString:@"#FFFAF0"] // 米色背景颜色
#define COLOR_BACK_COMIC_READ RGB(247, 244, 228)  // 漫画阅读界面

// 文字
#define COLOR_TEXT_WHITE       [UIColor whiteColor]                   // 白色
#define COLOR_TEXT_UNSELECT    [UIColor colorWithWhite:0.9 alpha:1.0] // 未选中灰白色
#define COLOR_TEXT_GRAY        RGB(102, 102, 102)                     // 灰色文字
#define COLOR_TEXT_BLACK       RGB(51, 51, 51)                        // 黑色文字
#define COLOR_TEXT_ORANGE      RGB(217, 89, 31)                       // 橘色文字

// 按钮
#define DEFUALT_BTN_COLOR  [UIColor colorWithWhite:0.9 alpha:1]  // 按钮默认字体颜色（暗灰白）
#define SELECTED_BTN_COLOR [UIColor colorWithWhite:1.0 alpha:1]  // 按钮选中字体颜色（纯白）

// 搜索
#define COLOR_BAR_GRAY   RGB(238, 238, 238) // 灰色条

// 漫画内容
#define COLOR_TOOL_BAR   RGB(79, 79, 79) // 漫画阅读工具条颜色


#endif /* Colors_h */
