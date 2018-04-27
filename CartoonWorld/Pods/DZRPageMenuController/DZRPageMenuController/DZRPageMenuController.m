//
//  DZRPageView.m
//  DZRPageMenu
//
//  Created by dundun on 2017/5/10.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "DZRPageMenuController.h"

#define kScreen_Width  self.view.frame.size.width
#define kScreen_Height self.view.frame.size.height

NSString * const DZROptionItemTitleFont                       = @"itemTitleFont";
NSString * const DZROptionCurrentPage                         = @"currentPage";

NSString * const DZROptionMenuHeight                          = @"menuHeight";
NSString * const DZROptionItemWidth                           = @"itemWidth";
NSString * const DZROptionIndicatorWidth                      = @"indicatorWidth";
NSString * const DZROptionIndicatorHeight                     = @"indicatorHeight";
NSString * const DZROptionLeftRightMargin                     = @"leftRightMargin";
NSString * const DZROptionItemTopMargin                       = @"itemTopMargin";
NSString * const DZROptionItemBottomMargin                    = @"itemBottomMargin";
NSString * const DZROptionIndicatorTopToMenu                  = @"indicatorTopToMenu";
NSString * const DZROptionItemsSpace                          = @"itemsSpace";

NSString * const DZROptionMenuColor                           = @"menuColor";
NSString * const DZROptionControllersScrollViewColor          = @"controllersScrollViewColor";
NSString * const DZROptionSelectorItemTitleColor              = @"selectorItemTitleColor";
NSString * const DZROptionUnselectorItemTitleColor            = @"unselectorItemTitleColor";
NSString * const DZROptionIndicatorColor                      = @"indicatorColor";

NSString * const DZROptionIndicatorWidthEqualToItemWidth      = @"indicatorWidthEqualToItemWidth";
NSString * const DZROptionIndicatorNeedToCutTheRoundedCorners = @"indicatorNeedToCutTheRoundedCorners";
NSString * const DZROptionItemsCenter                         = @"itemsCenter";
NSString * const DZROptionCanBounceHorizontal                 = @"canBounceHorizontal";

@interface DZRPageMenuController ()<UIScrollViewDelegate>

@property (nonatomic, weak) id<DZRPageMenuDelegate> delegate;
@property (nonatomic, weak) id<DZRPageMenuDataSource> dataSource;

@property (nonatomic, strong) UIScrollView *menuScrollView;
@property (nonatomic, strong) UIView * indicatorView;
@property (nonatomic, strong) UIScrollView *controllerScrollView;

@property (nonatomic, strong) NSDictionary *options;           // 选择项
@property (nonatomic, strong) NSArray *controllersArray;       // 子视图控制器数组
@property (nonatomic, strong) NSMutableArray *pageMutaleArray; // 已经加载还在内存中的页面

@property (nonatomic, assign) CGFloat itemTitleFont;    // 菜单项标题字体大小
@property (nonatomic, assign) NSInteger pageCount;      // 页面个数
@property (nonatomic, assign) NSInteger currentPage;    // 当前页
@property (nonatomic, assign) NSInteger oldCurrentPage; // 上一个当前页
@property (nonatomic, assign) CGFloat offsetScale;      // 2个滚动视图的偏移量比例

@property (nonatomic, assign) CGFloat menuHeight;          // 菜单栏高度
@property (nonatomic, assign) CGFloat itemWidth;           // 菜单项的宽度
@property (nonatomic, assign) CGFloat indicatorWidth;      // 指示器宽度
@property (nonatomic, assign) CGFloat indicatorHeight;     // 指示器高度
@property (nonatomic, assign) CGFloat startEndMargin;      // 如果菜单项居中显示，总的菜单项宽度小于屏幕宽度，则其余的左右留白
@property (nonatomic, assign) CGFloat leftRightMargin;     // 第一个和最后一个菜单项距离父视图的留白距离
@property (nonatomic, assign) CGFloat itemTopMargin;       // 菜单项距离父视图上面的距离
@property (nonatomic, assign) CGFloat itemBottomMargin;    // 菜单项距离父视图下面的距离
@property (nonatomic, assign) CGFloat indicatorLeftToItem; // 指示器左边距离菜单项左边距离
@property (nonatomic, assign) CGFloat indicatorTopToMenu;  // 指示器顶部距离菜单栏顶部距离
@property (nonatomic, assign) CGFloat itemsSpace;          // 菜单项之间的空隙
@property (nonatomic, assign) CGFloat currentControllerScrollOffset; // 当前controllerScrollView滑动中偏移量

@property (nonatomic, strong) UIColor *menuColor;                  // menuScrollView的背景颜色
@property (nonatomic, strong) UIColor *controllersScrollViewColor; // controllersScrollView背景颜色
@property (nonatomic, strong) UIColor *selectorItemTitleColor;     // 选中的菜单项标题颜色
@property (nonatomic, strong) UIColor *unselectorItemTitleColor;   // 未选中菜单项标题颜色
@property (nonatomic, strong) UIColor *indicatorColor;             // 指示器的颜色

@property (nonatomic, assign) BOOL isItemsCenter;                         // 菜单项是否居中显示
@property (nonatomic, assign) BOOL canBounceHorizontal;                   // 是否能够水平滑动超过父视图
@property (nonatomic, assign) BOOL didIndicatorNeedToCutTheRoundedCorner; // 指示器是否切要切割圆角

@end

@implementation DZRPageMenuController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Init

/**
 1. 继承 DZRPageMenuController 方式使用
 2. 加载 DZRPageMenuController.view 方式使用
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self init];
    self.view.frame = frame;
    return self;
}

// 加载 DZRPageMenuController.view 方式使用
- (instancetype)initWithFrame:(CGRect)frame delegate:(id)controller;
{
    self.delegate = controller;
    self.dataSource = controller;
    
    self = [self init];
    self.view.frame = frame;
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        if (!self.delegate) {
            self.delegate = self;
        }
        
        if (!self.dataSource) {
            self.dataSource = self;
        }
        
        // 设置初始默认值
        [self initValue];
        
        if ([self.dataSource respondsToSelector:@selector(setupPageMenuWithOptions)]) {
            self.options = [self.dataSource setupPageMenuWithOptions];
        }
        
        if ([self.dataSource respondsToSelector:@selector(addChildControllersToPageMenu)]) {
            self.controllersArray = [self.dataSource addChildControllersToPageMenu];
            self.pageCount = self.controllersArray.count;
        }
        
        // 设置选择项
        [self setupOptions];
        
        // 将需要计算的值配置好
        [self setupValue];
        
        // 设置子视图
        [self setupSubViews];
    }
    return self;
}

/**设置初始默认值*/
- (void)initValue
{
    self.pageMutaleArray = [NSMutableArray array];
    
    self.itemTitleFont = 15;
    self.pageCount = 0;
    self.currentPage = -1;
    self.oldCurrentPage = -1;
    self.offsetScale = 0.0;
    
    self.menuHeight = 40.0;
    self.itemWidth = 60.0;
    self.indicatorWidth = 60.0;
    self.indicatorHeight = 0.0;
    self.startEndMargin = 0.0;
    self.leftRightMargin = 15.0;
    self.itemTopMargin = 10.0;
    self.itemBottomMargin = 10.0;
    self.indicatorLeftToItem = 0.0;
    self.indicatorTopToMenu = 38.0;
    self.itemsSpace = 0.0;
    self.currentControllerScrollOffset = 0.0;
    
    self.menuColor = [UIColor whiteColor];
    self.controllersScrollViewColor = [UIColor whiteColor];
    self.selectorItemTitleColor = self.view.tintColor;
    self.unselectorItemTitleColor = [UIColor lightGrayColor];
    self.indicatorColor = self.view.tintColor;
    
    self.isItemsCenter = NO;
    self.canBounceHorizontal = NO;
    self.didIndicatorNeedToCutTheRoundedCorner = NO;
}

#pragma mark - Set up

/**创建数据源*/
- (void)setupOptions
{
    // 设置选项值
    for (NSString *key in self.options) {
        if ([key isEqualToString:DZROptionItemTitleFont]) {
            self.itemTitleFont = [self.options[key] floatValue];
        } else if ([key isEqualToString:DZROptionCurrentPage]) {
            if (self.options[key]) {
                self.currentPage = [self.options[key] integerValue];
            }
        } else if ([key isEqualToString:DZROptionMenuHeight]) {
            self.menuHeight = [self.options[key] floatValue];
        } else if ([key isEqualToString:DZROptionItemWidth]) {
            self.itemWidth = [self.options[key] floatValue];
        } else if ([key isEqualToString:DZROptionIndicatorWidth]) {
            self.indicatorWidth = [self.options[key] floatValue];
        } else if ([key isEqualToString:DZROptionIndicatorHeight]) {
            self.indicatorHeight = [self.options[key] floatValue];
        } else if ([key isEqualToString:DZROptionLeftRightMargin]) {
            self.leftRightMargin = [self.options[key] floatValue];
        } else if ([key isEqualToString:DZROptionItemTopMargin]) {
            self.itemTopMargin = [self.options[key] floatValue];
        } else if ([key isEqualToString:DZROptionItemBottomMargin]) {
            self.itemBottomMargin = [self.options[key] floatValue];
        } else if ([key isEqualToString:DZROptionIndicatorTopToMenu]) {
            self.indicatorTopToMenu = [self.options[key] floatValue];
        } else if ([key isEqualToString:DZROptionItemsSpace]) {
            self.itemsSpace = [self.options[key] floatValue];
        } else if ([key isEqualToString:DZROptionMenuColor]) {
            self.menuColor = self.options[key];
        } else if ([key isEqualToString:DZROptionControllersScrollViewColor]) {
            self.controllersScrollViewColor = self.options[key];
        } else if ([key isEqualToString:DZROptionSelectorItemTitleColor]) {
            self.selectorItemTitleColor = self.options[key];
        } else if ([key isEqualToString:DZROptionUnselectorItemTitleColor]) {
            self.unselectorItemTitleColor = self.options[key];
        } else if ([key isEqualToString:DZROptionIndicatorColor]) {
            self.indicatorColor = self.options[key];
        } else if ([key isEqualToString:DZROptionItemsCenter]) {
            self.isItemsCenter = [self.options[key] boolValue];
        } else if ([key isEqualToString:DZROptionCanBounceHorizontal]) {
            self.canBounceHorizontal = [self.options[key] boolValue];
        } else if ([key isEqualToString:DZROptionIndicatorNeedToCutTheRoundedCorners]) {
            self.didIndicatorNeedToCutTheRoundedCorner = [self.options[key] boolValue];
        }
    }
}

/**初始化子视图*/
- (void)setupSubViews
{
    // 设置menuScrollerView
    self.menuScrollView = [[UIScrollView alloc] init];
    self.menuScrollView.alwaysBounceHorizontal = self.canBounceHorizontal;
    self.menuScrollView.backgroundColor = self.menuColor;
    [self.view addSubview:self.menuScrollView];
    
    // 设置controllerScrollView
    self.controllerScrollView = [[UIScrollView alloc] init];
    self.controllerScrollView.pagingEnabled = YES;
    self.controllerScrollView.alwaysBounceHorizontal = self.canBounceHorizontal;
    self.controllerScrollView.delegate = self;
    self.controllerScrollView.backgroundColor = self.controllersScrollViewColor;
    [self.view addSubview:self.controllerScrollView];
    
    // 隐藏滑动指示器
    self.menuScrollView.showsVerticalScrollIndicator = NO;
    self.menuScrollView.showsHorizontalScrollIndicator = NO;
    self.controllerScrollView.showsVerticalScrollIndicator = NO;
    self.controllerScrollView.showsHorizontalScrollIndicator = NO;
    
    // 设置item view
    for (int i = 0; i < self.pageCount; i++) {
        [self setupItemViewAtIndexPage:i];
    }
    
    // 禁止滑到顶部
    self.menuScrollView.scrollsToTop = NO;
    self.controllerScrollView.scrollsToTop = NO;

    // 设置指示器
    self.indicatorView = [[UIView alloc] init];
    if (self.didIndicatorNeedToCutTheRoundedCorner) {
        self.indicatorView.layer.cornerRadius = self.indicatorHeight / 2;
        self.indicatorView.layer.masksToBounds = YES;
    }
    self.indicatorView.backgroundColor = self.indicatorColor;
    [self.menuScrollView addSubview:self.indicatorView];
}

/**
 * 创建菜单项
 *
 * @param index 菜单项对应的下标
 */
- (void)setupItemViewAtIndexPage:(NSInteger)index
{
    // 菜单项视图
    UILabel *itemView = [[UILabel alloc] init];
    CGFloat x = self.startEndMargin + self.leftRightMargin + index * (self.itemsSpace + self.itemWidth);
    CGFloat itemHeight = self.menuHeight - self.itemTopMargin - self.itemBottomMargin;
    itemView.frame = CGRectMake(x, self.itemTopMargin, self.itemWidth, itemHeight);
    itemView.tag = index + 100;
    itemView.font = [UIFont systemFontOfSize:self.itemTitleFont];
    itemView.textAlignment = NSTextAlignmentCenter;
    itemView.backgroundColor = self.menuColor;
    [self.menuScrollView addSubview:itemView];
    
    // 标题
    UIViewController *childVC = self.controllersArray[index];
    itemView.text = (childVC.title != nil) ? childVC.title : [NSString stringWithFormat:@"item%ld",(long)index];
    
    // 字体颜色
    if (index == self.currentPage) {
        itemView.textColor = self.selectorItemTitleColor;
    } else {
        itemView.textColor = self.unselectorItemTitleColor;
    }
    
    // 给菜单项添加手势
    itemView.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
    [recognizer addTarget:self action:@selector(itemCicked:)];
    [itemView addGestureRecognizer:recognizer];
}

/**设置值（需要初步计算获得）*/
- (void)setupValue
{
    // 如果是中心对称则计算初始留白
    if (self.isItemsCenter) {
        self.startEndMargin = (kScreen_Width - self.itemWidth * self.pageCount - self.leftRightMargin * 2 - self.itemsSpace * (self.pageCount - 1)) / 2;
    }
    // 判断总的长度是否超过父视图
    if (self.startEndMargin < 0) {
        // 超过，没有初始留白
        self.startEndMargin = 0.0;
        // 设置当前页
        if (self.isItemsCenter) {
            if (self.pageCount % 2) { // 奇数
                self.currentPage = self.pageCount / 2;
            } else {
                self.currentPage = self.pageCount / 2 - 1;
            }
        }
    } else if (self.currentPage == -1){
        // 未超过，设置当前页
        if (self.isItemsCenter) {
            if (self.pageCount % 2) { // 奇数
                self.currentPage = self.pageCount / 2;
            } else {
                self.currentPage = self.pageCount / 2 - 1;
            }
        } else {
            self.currentPage = 0;
        }
    }
    
    // 确认指示器长度
    if (self.indicatorWidth > (self.itemWidth + self.leftRightMargin)) {
        self.indicatorWidth = self.itemWidth + self.leftRightMargin;
    }
    
    // 计算指示器距离对应菜单项左边距离
    self.indicatorLeftToItem = (self.itemWidth - self.indicatorWidth) / 2;
    
    // 确认指示器距离对应菜单项顶部距离
    if (self.indicatorTopToMenu  > self.menuHeight - self.indicatorHeight) {
        self.indicatorTopToMenu  = self.menuHeight - self.indicatorHeight;
    }
    
    // 计算偏移量比例
    CGFloat totalLength = 2 * self.leftRightMargin + self.pageCount * self.itemWidth + (self.pageCount - 1) * self.itemsSpace;
    if (totalLength > kScreen_Width) {
        self.offsetScale = (totalLength - kScreen_Width) / ((self.pageCount - 1) * kScreen_Width);
    }
    
    self.currentControllerScrollOffset = self.currentPage * kScreen_Width;
}

#pragma mark - Layout subviews

- (void)viewDidLayoutSubviews
{
    // 设置menuScrollerView
    self.menuScrollView.frame = CGRectMake(0.0, 0.0, kScreen_Width, self.menuHeight);
    
    // 设置controllerScrollView
    self.controllerScrollView.frame= CGRectMake(0.0, CGRectGetMaxY(self.menuScrollView.frame), kScreen_Width, kScreen_Height - self.menuHeight);
    
    // 配置contentSize
    CGFloat menuContentSizeWidth = 2 * (self.startEndMargin + self.leftRightMargin) + self.pageCount * self.itemWidth + (self.pageCount - 1) * self.itemsSpace;
    self.menuScrollView.contentSize = CGSizeMake(menuContentSizeWidth, self.menuHeight);
    self.controllerScrollView.contentSize = CGSizeMake(self.pageCount * kScreen_Width, kScreen_Height - self.menuHeight);
    
    // 设置offset
    [self.controllerScrollView setContentOffset:CGPointMake(self.currentPage * kScreen_Width, 0.0) animated:NO]; 
    CGFloat menuOffsetX = 0.0;
    menuOffsetX = self.controllerScrollView.contentOffset.x * self.offsetScale;
    [self.menuScrollView setContentOffset:CGPointMake(menuOffsetX, 0.0) animated:NO];
    
    // 设置指示器
    CGFloat indicatorX = self.startEndMargin + self.leftRightMargin + self.currentPage * (self.itemWidth + self.itemsSpace) + self.indicatorLeftToItem;
    self.indicatorView.frame = CGRectMake(indicatorX, self.indicatorTopToMenu, self.indicatorWidth, self.indicatorHeight);
    
    // 设置初始显示界面
    if (![self.pageMutaleArray containsObject:@(self.currentPage)]) {
        [self willMoveContrller:self.currentPage];
        [self.pageMutaleArray addObject:@(self.currentPage)];
        [self didMoveContrller:self.currentPage];
    }
}

#pragma mark - show/dismiss

/**将新出现的视图加载出来*/
- (void)willMoveContrller:(NSInteger)indexPage
{
    UIViewController *childVC = self.controllersArray[indexPage];
    if (childVC) {
        if ([self.delegate respondsToSelector:@selector(pageMenu:willMoveTheChildController:atIndexPage:)]) {
            [self.delegate pageMenu:self willMoveTheChildController:childVC atIndexPage:indexPage];
        }
        [childVC willMoveToParentViewController:self];
        
        CGFloat x = indexPage * kScreen_Width;
        CGFloat height = self.controllerScrollView.frame.size.height;
        childVC.view.frame = CGRectMake(x, 0.0, kScreen_Width, height);
        [self.controllerScrollView addSubview:childVC.view];
        
        [self addChildViewController:childVC];
        [childVC didMoveToParentViewController:self];
        
//        NSLog(@"%@",[NSString stringWithFormat:@"%ld将要出来了",(long)indexPage]);
    }
}

/**视图正式加载为当前视图*/
- (void)didMoveContrller:(NSInteger)indexPage
{
    UIViewController *childVC = self.controllersArray[indexPage];
    if (childVC) {
        if ([self.delegate respondsToSelector:@selector(pageMenu:didMoveTheChildController:atIndexPage:)]) {
            [self.delegate pageMenu:self didMoveTheChildController:childVC atIndexPage:indexPage];
        }
        
//        NSLog(@"%@",[NSString stringWithFormat:@"%ld已经出来了",(long)indexPage]);
    }
}

/**移除该下标的视图控制器*/
- (void)removeControllerAtIndex:(NSInteger)indexPage
{
    UIViewController *childVC = self.controllersArray[indexPage];
    if (childVC) {
        [childVC willMoveToParentViewController:nil];
        [childVC.view removeFromSuperview];
        [childVC removeFromParentViewController];
        [childVC didMoveToParentViewController:nil];
        
//        NSLog(@"%@",[NSString stringWithFormat:@"%ld移除",(long)indexPage]);
    }
}

#pragma mark - Refresh

/**刷新indicatorView和menuScrollView的位置*/
- (void)refreshIndicatorViewAndMenuScrollView
{
    CGFloat menuOffset = self.controllerScrollView.contentOffset.x * self.offsetScale;
    [self.menuScrollView setContentOffset:CGPointMake(menuOffset, 0.0) animated:YES];
    
    if (self.oldCurrentPage >= 0 && self.oldCurrentPage < self.pageCount) {
        UILabel *oldItem = (UILabel *)[self.menuScrollView viewWithTag:(self.oldCurrentPage + 100)];
        oldItem.textColor = self.unselectorItemTitleColor;
    }
    
    if (self.currentPage >= 0 && self.currentPage < self.pageCount) {
        UILabel *currentItem = (UILabel *)[self.menuScrollView viewWithTag:(self.currentPage + 100)];
        currentItem.textColor = self.selectorItemTitleColor;
    }
    
    CGFloat moveScale = (self.menuScrollView.contentSize.width - 2 * (self.startEndMargin + self.leftRightMargin + self.indicatorLeftToItem) - self.indicatorWidth) / ((self.pageCount - 1) * kScreen_Width);
    CGFloat indicatorX = self.controllerScrollView.contentOffset.x * moveScale + (self.startEndMargin + self.leftRightMargin + self.indicatorLeftToItem);
    self.indicatorView.frame = CGRectMake(indicatorX, self.indicatorView.frame.origin.y, self.indicatorWidth, self.indicatorHeight);
}

#pragma mark - Response events

/**点击菜单项*/
- (void)itemCicked:(UITapGestureRecognizer *)recognizer
{
    UILabel *itemView = (UILabel *)recognizer.view;
    NSInteger indexPage = itemView.tag - 100;
    
    if (indexPage != self.currentPage) {
        NSInteger smallPage = indexPage < self.currentPage ? indexPage : self.currentPage;
        NSInteger largePage = indexPage > self.currentPage ? indexPage : self.currentPage;
        for (int i = (int)smallPage; i <= largePage; i++) {
            if (![self.pageMutaleArray containsObject:@(i)]) {
                [self willMoveContrller:(NSInteger)i];
                [self.pageMutaleArray addObject:@(i)];
            }
        }
        // 更新最新偏移量
        self.currentControllerScrollOffset = indexPage * kScreen_Width;
        self.oldCurrentPage = self.currentPage;
        self.currentPage = indexPage;
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.controllerScrollView setContentOffset:CGPointMake(indexPage * kScreen_Width, 0.0)];
        } completion:^(BOOL finished) {
            [self scrollViewScrollAnimationFinished:self.controllerScrollView];
        }];
    }
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 确保是controllerScrollView
    if (scrollView != self.controllerScrollView) { return; }
    
    // 获取当前的偏移量
    CGFloat nowOffset = scrollView.contentOffset.x;
    if (nowOffset > 0.0 && nowOffset < (self.pageCount - 1) * kScreen_Width) {
        // 未超过视图
        
        // 将即将出现的视图加载出来
        NSInteger newIndexPage = 0;
        if (fmodf(nowOffset, kScreen_Width)) {
            newIndexPage = nowOffset > self.currentControllerScrollOffset ? (nowOffset / kScreen_Width + 1) : (nowOffset / kScreen_Width);
        } else {
            newIndexPage = nowOffset / kScreen_Width;
        }
        
        if (newIndexPage >= 0 && newIndexPage < self.pageCount) {
            // 不在内存中的视图将出现
            if (![self.pageMutaleArray containsObject:@(newIndexPage)]) {
                [self willMoveContrller:newIndexPage];
                [self.pageMutaleArray addObject:@(newIndexPage)];
            } else if (newIndexPage == self.oldCurrentPage){
                // 在内存中视图将出现
                // 问题标记：考虑到可能一段滑动没有解释但是界面已经移除整个屏幕
                // 等下次出现时其实还没有被释放，所以应该先走willMoveController方法
                // 但是目前一旦视图移出整个屏幕就会被移出
                // 问题暂定
            }
        }
        
        // 当前界面发生变化
        NSInteger nowIndexPage = (nowOffset + kScreen_Width / 2) / kScreen_Width;
        if (nowIndexPage != self.currentPage) {
            
            self.oldCurrentPage = self.currentPage;
            self.currentPage = nowIndexPage;
            
            [self didMoveContrller:nowIndexPage];

            // 将移除的视图移除
            CGFloat leftRemovePage = nowIndexPage - 2;
            if ([self.pageMutaleArray containsObject:@(leftRemovePage)]) {
                [self removeControllerAtIndex:leftRemovePage];
                [self.pageMutaleArray removeObject:@(leftRemovePage)];
            }
            
            CGFloat rightRemovePage = nowIndexPage + 2;
            if ([self.pageMutaleArray containsObject:@(rightRemovePage)]) {
                [self removeControllerAtIndex:rightRemovePage];
                [self.pageMutaleArray removeObject:@(rightRemovePage)];
            }
        }
    }
    
    // 更新最新偏移量
    self.currentControllerScrollOffset = scrollView.contentOffset.x;
    
    // 刷新menuScrollView和indicatorView的位置
    [self refreshIndicatorViewAndMenuScrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (![scrollView isEqual:self.controllerScrollView]) { return; }
    
    // 确保当前视图准确
    NSInteger nowIndexPage = (scrollView.contentOffset.x + kScreen_Width / 2) / kScreen_Width;
    if (nowIndexPage != self.currentPage) {
        
        [self didMoveContrller:nowIndexPage];
        self.oldCurrentPage = self.currentPage;
        self.currentPage = nowIndexPage;
    }
    
    // 移除除了当前视图之外的所有视图
    for (int i = 0; i< self.pageMutaleArray.count; i++) {
        NSInteger indexPage = [self.pageMutaleArray[i] integerValue];
        if (self.currentPage != indexPage) {
            [self removeControllerAtIndex:indexPage];
            [self.pageMutaleArray removeObject:@(indexPage)];
        }
    }

    // 更新最新偏移量
    self.currentControllerScrollOffset = scrollView.contentOffset.x;
    
    // 刷新menuScrollView和indicatorView的位置
    [self refreshIndicatorViewAndMenuScrollView];
}

- (void)scrollViewScrollAnimationFinished:(UIScrollView *)scrollView
{
    if (![scrollView isEqual:self.controllerScrollView]) { return; }

    [self didMoveContrller:self.currentPage];
    
    // 移除除了当前视图之外的所有视图
    NSInteger removeCount = self.pageMutaleArray.count;
    NSInteger indexInArray = 0;
    for (int i = 0; i < removeCount; i++) {
        NSInteger indexPage = [self.pageMutaleArray[indexInArray] integerValue];
        if (self.currentPage != indexPage) {
            [self removeControllerAtIndex:indexPage];
            [self.pageMutaleArray removeObject:@(indexPage)];
        } else {
            indexInArray++;
        }
    }
}

#pragma mark - Page menu data source

- (NSDictionary *)setupPageMenuWithOptions
{
    return nil;
}

- (NSArray *)addChildControllersToPageMenu
{
    return nil;
}

@end
