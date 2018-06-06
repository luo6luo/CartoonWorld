//
//  ComicBaseScrollView.m
//  CartoonWorld
//
//  Created by dundun on 2017/10/17.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "ComicBaseScrollView.h"

@interface ComicBaseScrollView ()

@property (nonatomic, assign) CGFloat lastOffsetY; // 上次y轴偏移量

@end

@implementation ComicBaseScrollView

# pragma mark - Setter

- (void)setMainViewIsUp:(BOOL)mainViewIsUp
{
    _mainViewIsUp = mainViewIsUp;
    
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:UITableView.class] ||
            [subview isKindOfClass:UICollectionView.class]) {
            UIScrollView *scrollView = (UIScrollView *)subview;
            scrollView.scrollEnabled = YES;
        }
    }
}

# pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 设置滑动方向
    CGFloat offsetY = scrollView.contentOffset.y;
    ScrollDirection direciton = ScrollOther;
    if (self.lastOffsetY - offsetY > 0) {
        direciton = ScrollDown;
    } else if (self.lastOffsetY - offsetY < 0) {
        direciton = ScrollUp;
    }
    
    if (self.mainViewIsUp) {
        // 目录在上方
        if (direciton == ScrollDown && scrollView.contentOffset.y < 0) {
            // 下拉，整体视图下滑动
            if (self.scrollBlock) {
                scrollView.scrollEnabled = NO;
                self.scrollBlock(ScrollDown);
            }
        }
    } else if (!self.mainViewIsUp) {
        // 目录在下方
        if (direciton == ScrollUp && scrollView.contentOffset.y > 0) {
            // 上拉，整体视图上滑动
            if (self.scrollBlock) {
                scrollView.scrollEnabled = NO;
                scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
                self.scrollBlock(ScrollUp);
            }
        } else if (direciton == ScrollDown) {
            // 下拉，整体不动
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
        }
    }
    
    self.lastOffsetY = scrollView.contentOffset.y;
}


@end
