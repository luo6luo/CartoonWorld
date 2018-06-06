//
//  DZRPageView.h
//  DZRPageMenu
//
//  Created by dundun on 2017/5/10.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>

# pragma mark - Protocol

@protocol DZRPageMenuDataSource <NSObject>
@required

/**将要添加到父视图中的子视图控制器*/
- (NSArray *)addChildControllersToPageMenu;

/**配置菜单栏的选项*/
- (NSDictionary *)setupPageMenuWithOptions;

@end

@protocol DZRPageMenuDelegate <NSObject>
@optional

/**
 * 分页菜单控制器将要把该下标的子视图控制器加载出来
 *
 * @param childController 将要加载的子视图
 * @param indexPage 子视图下标
 */
- (void)pageMenu:(UIViewController *)pageMenu willMoveTheChildController:(UIViewController *)childController atIndexPage:(NSInteger)indexPage;

/**
 * 分页菜单控制器已经把该下标的子视图控制器移出来
 *
 * @param childController 将要加载的子视图
 * @param indexPage 子视图下标
 */
- (void)pageMenu:(UIViewController *)pageMenu didMoveTheChildController:(UIViewController *)childController atIndexPage:(NSInteger)indexPage;

@end

@interface DZRPageMenuController : UIViewController <DZRPageMenuDelegate, DZRPageMenuDataSource>

# pragma mark - Init

/*
 =============================================================
 说明: 'DZRPageMenuController'使用类似'UITableViewController'
 1. 可以采用继承的方式使用
 2. 可以使用添加view的方式使用
 
 注意:
 1. 继承的使用方式不限初始化方法
 2. 添加view的方式，只能使用含有代理的初始化
 =============================================================
 */

/**初始化，可以设置view的位置*/
- (instancetype)initWithFrame:(CGRect)frame;


/**
 初始化
 注意：采用添加view的方式时，必须使用此初始化方式
 
 @param frame view的位子
 @param controller 代理控制器
 @return 初始化结果
 */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id)controller;

# pragma mark - Key

// 选项key值
extern NSString * const DZROptionItemTitleFont;      // 菜单项字体大小
extern NSString * const DZROptionCurrentPage;        // 当前显示页面位置(在菜单项未超过屏宽宽度情况下有效)

extern NSString * const DZROptionMenuHeight;         // 菜单栏高度
extern NSString * const DZROptionItemWidth;          // 菜单项宽度
extern NSString * const DZROptionIndicatorWidth;     // 指示器的宽度
extern NSString * const DZROptionIndicatorHeight;    // 指示器高度
extern NSString * const DZROptionLeftRightMargin;    // 第一个和最后一个菜单项距离父视图的留白距离
extern NSString * const DZROptionItemTopMargin;      // 菜单项距离父视图上面的距离
extern NSString * const DZROptionItemBottomMargin;   // 菜单项距离父视图下面面的距离
extern NSString * const DZROptionIndicatorTopToMenu; // 指示器顶部距离菜单栏顶部距离
extern NSString * const DZROptionItemsSpace;         // 菜单项之间的空隙

extern NSString * const DZROptionMenuColor;                  // 菜单栏的颜色
extern NSString * const DZROptionControllersScrollViewColor; // 控制器颜色
extern NSString * const DZROptionSelectorItemTitleColor;     // 选中的菜单项标题颜色
extern NSString * const DZROptionUnselectorItemTitleColor;   // 未选中菜单项标题颜色
extern NSString * const DZROptionIndicatorColor;             // 指示器的颜色

extern NSString * const DZROptionItemsCenter;                         // 菜单项是否居中显示
extern NSString * const DZROptionCanBounceHorizontal;                 // 水平滑动是否能超过父视图
extern NSString * const DZROptionIndicatorNeedToCutTheRoundedCorners; // 指示器是否切要切割圆角

@end
