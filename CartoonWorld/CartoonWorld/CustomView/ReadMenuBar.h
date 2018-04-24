//
//  ReadMenuBar.h
//  CartoonWorld
//
//  Created by dundun on 2018/4/12.
//  Copyright © 2018年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,ButtonType) {
    ButtonTypeLight = 0,  // 灯（开关）
    ButtonTypeScreen,     // 屏幕（横竖）
    ButtonTypeBrightness, // 亮度
    ButtonTypeScroll      // 滚动方向（横竖）
};

@protocol ReadMenuBarDelegate <NSObject>

/**
 按钮被点击

 @param button     被点击的按钮
 @param type       按钮类型
 @param isSelected 该按钮是否被选中
 */
- (void)button:(UIButton *)button clickedWithButtonType:(ButtonType)type isSelected:(BOOL)isSelected;

/**
 滑块值改变

 @param slider   该滑块
 @param newValue 滑块新值
 */
- (void)slider:(UISlider *)slider valueChanged:(NSInteger)newValue;

@end

@interface ReadMenuBar : UIView

@property (nonatomic, weak) id<ReadMenuBarDelegate> delegate;
@property (nonatomic, assign) NSInteger maxPage; // 最大页数
@property (nonatomic, assign) NSInteger currentPage; // 当前页

// 重新布局
- (void)layoutSelfSubviews;

@end
