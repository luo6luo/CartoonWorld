//
//  ReadScrollView.m
//  CartoonWorld
//
//  Created by dundun on 2018/4/12.
//  Copyright © 2018年 顿顿. All rights reserved.
//

#import "ReadScrollView.h"

#define MAX_IMAGEVIEW  3

@interface ReadScrollView()<UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger totalCount;      // 图片数
@property (nonatomic, strong) NSMutableArray *imageURLs; // 所有图片链接
@property (nonatomic, assign) NSInteger currentImageIndex; // 当前显示图片下标

@end

@implementation ReadScrollView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = COLOR_PINK;
        self.currentImageIndex = 10;
        self.screenType = ScreenOrientationTypeVertical;
        self.scrollType = ScrollOrientationTypeVertical;
        
        [self setupSubviews];
    }
    return self;
}

# pragma mark - Getter

- (NSMutableArray *)imageURLs
{
    if (!_imageURLs) {
        _imageURLs = [NSMutableArray array];
    }
    return _imageURLs;
}

# pragma mark - Setter

- (void)setScreenType:(ScreenOrientationType)screenType
{
    _screenType = screenType;
    if (screenType == ScreenOrientationTypeVertical) {
        // 竖屏
        self.alwaysBounceVertical = YES;
        self.alwaysBounceHorizontal = NO;
        self.pagingEnabled = NO;
        
    } else {
        // 横屏
        self.alwaysBounceVertical = NO;
        self.alwaysBounceHorizontal = YES;
        self.pagingEnabled = YES;
    }
    
    [self setNeedsLayout];
}

- (void)setScrollType:(ScrollOrientationType)scrollType
{
    _scrollType = scrollType;
    if (scrollType == ScreenOrientationTypeVertical) {
        // 竖滑
        self.contentSize = CGSizeMake(SCREEN_WIDTH, 3*SCREEN_HEIGHT);
    } else {
        // 横滑
        self.contentSize = CGSizeMake(3*SCREEN_WIDTH, SCREEN_HEIGHT);
    }
}

# pragma mark - Set up

- (void)setupData
{
    if ([self.dataSource respondsToSelector:@selector(numberOfImageInScrollView:)]) {
        self.totalCount = [self.dataSource numberOfImageInScrollView:self];
    }
}

- (void)setupSubviews
{
    for (int i = 0; i < MAX_IMAGEVIEW; i++) {
        UIImageView *imageView = [UIImageView imageViewWithFrame:CGRectZero image:@"default_background"];
        imageView.tag = i + 10;
        [self addSubview:imageView];
    }
    
    [self setNeedsLayout];
}

# pragma mark - Layout

- (void)layoutSubviews
{
    if (self.screenType == ScreenOrientationTypeVertical) {
        // 竖屏
        self.frame = CGRectMake(0, -NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } else {
        // 横屏
        self.frame = CGRectMake(0, -NAVIGATIONBAR_HEIGHT, SCREEN_HEIGHT, SCREEN_WIDTH);
    }
    
    for (int i = 0; i < MAX_IMAGEVIEW; i++) {
        UIImageView *imageView = [self viewWithTag:i + 10];
        if (self.screenType == ScreenOrientationTypeVertical && self.scrollType == ScrollOrientationTypeVertical) {
            // 竖屏 + 竖滑
            imageView.frame = CGRectMake(0, i * self.height, self.width, self.height);
        } else if (self.screenType == ScreenOrientationTypeVertical && self.scrollType == ScrollOrientationTypeHorizontal) {
            // 竖屏 + 横滑
            imageView.frame = CGRectMake(i * self.width, 0, self.width, self.height);
        } else {
            // 横屏（只能竖滑）
        }
    }
}

# pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.touchScreenBlock) {
        self.touchScreenBlock();
    }
}

# pragma mark - Scroll view scroll

- (void)refreshImageData
{
    for (int i = (int)self.currentImageIndex; i < MAX_IMAGEVIEW; i++) {
        UIImageView *imageView = [self viewWithTag:i];
        if ([self.dataSource respondsToSelector:@selector(scrollView:imageURLAtIndex:)]) {
            NSURL *url = [NSURL URLWithString:[self.dataSource scrollView:self imageURLAtIndex:self.currentImageIndex]];
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_background"]];
        }
    }
}

- (void)refreshImage
{
    if (self.currentImageIndex <= 0 && self.currentImageIndex >= self.totalCount - 1) {
        return;
    }
    
    for (int i = (int)self.currentImageIndex - 1; i < MAX_IMAGEVIEW; i++) {
        UIImageView *imageView = [self viewWithTag:i];
        if ([self.dataSource respondsToSelector:@selector(scrollView:imageURLAtIndex:)]) {
            NSURL *url = [NSURL URLWithString:[self.dataSource scrollView:self imageURLAtIndex:self.currentImageIndex]];
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_background"]];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

@end
