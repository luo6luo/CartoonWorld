//
//  ReadScrollView.m
//  CartoonWorld
//
//  Created by dundun on 2018/4/12.
//  Copyright © 2018年 顿顿. All rights reserved.
//

/*
 （1）复用原理：
 在滚动视图上添加五个UIImageView，实现图片复用，
 因为只有最多3个视图是可见的，所以采用类似tableView的复用机制，前后各一个富余的UImageView来加载即将显示的视图内容。
 当前页的定义：将要出现的图片，当其高度小于屏幕高度时候，其一半内容展示则变为当前页；当其高度大于屏幕高度时，其内容占屏幕一半则变为当前页。
 竖滑为例：
 下滑：当 index > totalCount - 3，则是从底部开始下滑，不需要处理
      当 index < 3，表示已经触顶，所以不需要处理
      当下面还有空，从下向上数，当已经划过第三张imageView的一半时候，将第一张imageView放到第四张imageView的上面
 上滑：当 index < 3 时，则是才开始从顶部向上滑动，所以不需要做处理
      当 index > totalCount - 3，表示已经触底了，所以也不要再处理了
      当其他，只要一直保持当前页是5张中的中间那个imageView即可
 总结：就是类似一个无限圆，想象。
 
 
 （2）滑动问题处理：
 整个滑动分为三种：竖屏+竖滑、竖屏+侧滑、横屏+竖滑。
 竖屏+竖滑：不是翻页滑，三个UImageView的高度是整屏高度。
 竖屏+侧滑：翻页滑动，三个UIImageView的高度是整屏高度。
 横屏+竖滑：横屏只能竖滑，图片宽度是整屏宽，高度是 图片宽度*(整屏高/整屏宽)。
 
 （3）frame处理：
 点击菜单栏的”屏幕方向”和“滑动方向”两个按钮后，利用setter传值，重置frame
 */

// 拖动滑条图片上浮，图片位置
typedef NS_ENUM(NSInteger, ImagePosition) {
    ImagePositionLeft = -1,
    ImagePositionCurrent,
    ImagePositionRight,
    ImagePositionUnknow
};

#import "ReadScrollView.h"
#import "ComicContentModel.h"

#define INIT_TAG   10  // 初始记录的tag
#define RUN_TAG    100 // 运行时记录的tag
#define MAX_IMAGEVIEW  5

// 当拖动滑动条时
#define IMAGE_UP_DELAY_TIME 0.1 // 图片浮现的延迟时间
#define CURRENT_SCALE_VALUE 0.6 // 当前图片的缩放值
#define LEFT_RIGHT_MARGIN   15  // 左右图片相对于其左右图片的间距


// 注意针对横屏，此处已经转屏
#define SCREEN_SCALE  (SCREEN_WIDTH / SCREEN_HEIGHT)

@interface ReadScrollView()<UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger totalCount;         // 图片数
@property (nonatomic, strong) NSMutableArray *models;       // 模型数组
@property (nonatomic, strong) NSMutableArray *imageHeights; // 图片高度
@property (nonatomic, assign) CGFloat totalImageHeight;     // 图片的总高

// 滑动相关
@property (nonatomic, assign) NSInteger currentImageIndex; // 当前显示图片下标
@property (nonatomic, assign) CGPoint currentOffset;       // 当前滑动偏移量
@property (nonatomic, assign) CGFloat scrollViewVerticalScreenOffsetY; // 滚动视图竖屏下的偏移量y值
@property (nonatomic, assign) CGFloat firstImageVerticalScreenOffsetY; // 当前第一张视图的偏移量y值

// 翻页
@property (nonatomic, assign) BOOL isSlideMode; // 是否为滑动模式

@end

@implementation ReadScrollView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = COLOR_BACK_WHITE;
        self.delegate = self;
        
        [self setupData];
        [self setupSubviews];
    }
    return self;
}

# pragma mark - Getter

- (NSMutableArray *)models
{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (NSMutableArray *)imageHeights
{
    if (!_imageHeights) {
        _imageHeights = [NSMutableArray array];
    }
    return _imageHeights;
}

# pragma mark - Setter

- (void)setScreenType:(ScreenOrientationType)screenType
{
    _screenType = screenType;
    [self layoutSelfSubviews];
}

- (void)setScrollType:(ScrollOrientationType)scrollType
{
    _scrollType = scrollType;
    if (scrollType == ScrollOrientationTypeVertical) {
        // 竖滑
        self.alwaysBounceVertical = YES;
        self.alwaysBounceHorizontal = NO;
        self.pagingEnabled = NO;
        
    } else if (scrollType == ScrollOrientationTypeHorizontal) {
        // 横滑
        self.alwaysBounceVertical = NO;
        self.alwaysBounceHorizontal = YES;
        self.pagingEnabled = YES;
    }
    [self layoutSelfSubviews];
}

- (void)setCurrentImageIndex:(NSInteger)currentImageIndex
{
    _currentImageIndex = currentImageIndex;
    if ([self.readDelegate respondsToSelector:@selector(scrollView:scrollToCurrentIndex:)]) {
        [self.readDelegate scrollView:self scrollToCurrentIndex:currentImageIndex];
    }
}

# pragma mark - Set up

- (void)setupData
{
    // 默认数据
    _currentImageIndex = 0;
    self.currentOffset = CGPointZero;
    self.scrollViewVerticalScreenOffsetY = 0;
    self.firstImageVerticalScreenOffsetY = 0;
    self.totalImageHeight = 0.0f;
    self.isSlideMode = NO;
    _screenType = ScreenOrientationTypeVertical;
    _scrollType = ScrollOrientationTypeVertical;
}

- (void)setupSubviews
{
    for (int i = 0; i < MAX_IMAGEVIEW; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectZero;
        imageView.image = [UIImage imageNamed:@"default_background"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = i + INIT_TAG;
        
        // 设置阴影
        imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        imageView.layer.shadowOffset = CGSizeMake(0, 0);
        imageView.layer.shadowOpacity = 1;
        imageView.layer.shadowRadius = 4;
        [self addSubview:imageView];
    }
    [self layoutSelfSubviews];
}

# pragma mark - Layout

- (void)layoutSelfSubviews
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    // 有数据源时候设置完整contentSize，无数据源只有一页，无法滑动翻页。
    NSInteger count = self.totalCount > 0 ? self.totalCount : 1;
    if (self.screenType == ScreenOrientationTypeHorizontal) {
        // 横屏 + 竖滑
        CGFloat imageHeight = self.totalCount > 0 ? (self.totalImageHeight * SCREEN_SCALE) : (SCREEN_WIDTH * SCREEN_SCALE);
        self.contentSize = CGSizeMake(SCREEN_WIDTH, imageHeight);
    } else if (self.screenType == ScreenOrientationTypeVertical &&
               self.scrollType == ScrollOrientationTypeVertical) {
        // 竖屏 + 竖滑
        CGFloat imageHeight = self.totalCount > 0 ? self.totalImageHeight : SCREEN_HEIGHT;
        self.contentSize = CGSizeMake(SCREEN_WIDTH, imageHeight);
    } else if (self.screenType == ScreenOrientationTypeVertical && self.scrollType == ScrollOrientationTypeHorizontal) {
        // 竖屏 + 横滑
        self.contentSize = CGSizeMake(count*SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    
    // 重置imageView的位置
    NSInteger startNumber = 0;
    NSInteger cycleCount = MAX_IMAGEVIEW;
    if (self.totalCount == 0) {
        // 没有数据
        startNumber = 0;
        cycleCount = 1;
    } else if (self.totalCount > 0 && self.totalCount < MAX_IMAGEVIEW) {
        // 总张数过小，不用复用
        startNumber = 0;
        cycleCount = self.totalCount;
    } else if (self.currentImageIndex < 3) {
        // 最上面的imageView在顶部
        startNumber = 0;
    } else if (self.currentImageIndex > self.totalCount - 3) {
        // 最下面的imageView在底部
        startNumber = self.totalCount - 5;
    } else {
        // 所有imageView在中部
        startNumber = self.currentImageIndex - 2;
    }
    
    // 竖直+竖滑状态下的imageView的y轴位置
    CGFloat imageViewY = self.firstImageVerticalScreenOffsetY;
    int tagNumber = self.totalCount > 0 ? RUN_TAG : INIT_TAG;
    for (int i = (int)startNumber; i < cycleCount + startNumber; i++) {
        UIImageView *imageView = [self viewWithTag:i + tagNumber];
        ComicContentModel *model = self.totalCount > 0 ? self.models[i] : nil;
        if (self.screenType == ScreenOrientationTypeVertical &&
            self.scrollType == ScrollOrientationTypeVertical) {
            // 竖屏 + 竖滑
            CGFloat imageHeight = self.totalCount > 0 ? model.showHeight : self.height;
            imageView.frame = CGRectMake(0, imageViewY, self.width, imageHeight);
            imageViewY += model.showHeight;
        } else if (self.screenType == ScreenOrientationTypeVertical && self.scrollType == ScrollOrientationTypeHorizontal) {
            // 竖屏 + 横滑
            imageView.frame = CGRectMake(i* self.width, 0, self.width, self.height);
        } else if (self.screenType == ScreenOrientationTypeHorizontal) {
            // 横滑 + 竖滑
            if (i == startNumber) {
                imageViewY *= SCREEN_SCALE;
            }
            CGFloat imageHeight = self.totalCount > 0 ? model.showHeight * SCREEN_SCALE : SCREEN_WIDTH * SCREEN_SCALE;
            imageView.frame = CGRectMake(0, imageViewY, self.width, imageHeight);
            imageViewY += imageHeight;
        }
    }
    
    // 滑到对应的位置
    if (self.scrollType == ScrollOrientationTypeVertical &&
        self.screenType == ScreenOrientationTypeVertical) {
        [self setContentOffset:CGPointMake(0, self.scrollViewVerticalScreenOffsetY) animated:NO];
    } else if (self.scrollType == ScrollOrientationTypeVertical &&
               self.screenType == ScreenOrientationTypeHorizontal) {
        [self setContentOffset:CGPointMake(0, self.scrollViewVerticalScreenOffsetY * SCREEN_SCALE) animated:NO];
    } else if (self.scrollType == ScrollOrientationTypeHorizontal) {
        [self setContentOffset:CGPointMake(SCREEN_WIDTH * self.currentImageIndex, 0) animated:NO];
    }
}

# pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.touchScreenBlock) {
        self.touchScreenBlock();
    }
}

# pragma mark - Refresh image

// 刷新
- (void)reloadData
{
    if ([self.readDataSource respondsToSelector:@selector(numberOfImageInScrollView:)]) {
        self.totalCount = [self.readDataSource numberOfImageInScrollView:self];
    }
    
    [self.models removeAllObjects];
    for (int i = 0; i < self.totalCount; i++) {
        if ([self.readDataSource respondsToSelector:@selector(scrollView:imageModelAtIndex:)]) {
            ComicContentModel *model = [self.readDataSource scrollView:self imageModelAtIndex:i];
            [self.models addObject:model];
            [self.imageHeights addObject:@(model.showHeight)];
            self.totalImageHeight += model.showHeight;
        }
    }
    
    // 赋值，并修改imageView的tag为动态的
    int count = self.totalCount < MAX_IMAGEVIEW ? (int)self.totalCount : MAX_IMAGEVIEW;
    for (int i = (int)self.currentImageIndex; i < count; i++) {
        UIImageView *imageView = [self viewWithTag:i + INIT_TAG];
        ComicContentModel *model = self.models[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.location]
                     placeholderImage:[UIImage imageNamed:@"default_background"]];
        imageView.tag = i + RUN_TAG;
    }
    
    [self layoutSelfSubviews];
}

// 开始翻页
- (void)startPageTurningAtCurrentPage:(NSInteger)currentPage
{
    if (self.isSlideMode) {
        return;
    }
    
    self.isSlideMode = YES;
    UIImageView *currentImageView = [self viewWithTag:RUN_TAG + self.currentImageIndex];
    currentImageView.layer.shadowOpacity = 0.8;
    CGRect currentImageNewFrame = [self scaleImageView:currentImageView frameWithMultiple:CURRENT_SCALE_VALUE AtPosition:ImagePositionCurrent];
    [UIView animateWithDuration:IMAGE_UP_DELAY_TIME animations:^{
        currentImageView.frame = currentImageNewFrame;
    }];
    
    // 计算当前视图下，其左右两边各有几个视图
    NSInteger leftImageCount = 0;
    NSInteger rightImageCount = 0;
    if (self.currentImageIndex >= 0 && self.currentImageIndex <= 2) {
        rightImageCount = self.currentImageIndex;
        leftImageCount = MAX_IMAGEVIEW - rightImageCount - 1;
    } else if (self.currentImageIndex <= self.totalCount - 1 && self.currentImageIndex >= self.totalCount - 3) {
        leftImageCount = self.totalCount - 1 - self.currentImageIndex;
        rightImageCount = MAX_IMAGEVIEW - leftImageCount - 1;
    } else {
        leftImageCount = 2;
        rightImageCount = 2;
    }
    
    // 把左边浮起来
    for (int i = 1; i <= leftImageCount; i++) {
        UIImageView *leftImage = [self viewWithTag:RUN_TAG + self.currentImageIndex + i];
        leftImage.layer.shadowOpacity = 0.8;
        CGRect leftImageFrame = [self scaleImageView:leftImage frameWithMultiple:CURRENT_SCALE_VALUE - i/10.0 AtPosition:ImagePositionLeft];
        [self insertSubview:leftImage atIndex:0];
        [UIView animateWithDuration:IMAGE_UP_DELAY_TIME animations:^{
            leftImage.frame = leftImageFrame;
        }];
    }
    
    // 把右边浮起来
    for (int i = 1; i <= rightImageCount; i++) {
        UIImageView *rightImage = [self viewWithTag:RUN_TAG + self.currentImageIndex - i];
        rightImage.layer.shadowOpacity = 0.8;
        CGRect rightImageFrame = [self scaleImageView:rightImage frameWithMultiple:CURRENT_SCALE_VALUE - i/10.0 AtPosition:ImagePositionRight];
        [self insertSubview:rightImage atIndex:0];
        [UIView animateWithDuration:IMAGE_UP_DELAY_TIME animations:^{
            rightImage.frame = rightImageFrame;
        }];
    }
}

// 翻到该下标页
- (void)turnToIndexPage:(NSInteger)indexPage
{
    if (!self.isSlideMode) {
        return;
    }
    
    // 记录变化的当前下标，但是不能用点语法，不能使用setter
    _currentImageIndex = indexPage;
    
}

// 停止翻页
- (void)stopPageTurning
{
    if (!self.isSlideMode) {
        return;
    }
    
    self.isSlideMode = NO;
    self.scrollViewVerticalScreenOffsetY = [self calculationSumOfTheArray:[self.imageHeights subarrayWithRange:NSMakeRange(0, self.currentImageIndex)]];
    if (self.currentImageIndex <= 2) {
        self.firstImageVerticalScreenOffsetY = 0;
    } else if (self.currentImageIndex >= self.totalCount - 3) {
        self.firstImageVerticalScreenOffsetY = [self calculationSumOfTheArray:[self.imageHeights subarrayWithRange:NSMakeRange(0, self.totalCount - 5)]];
    } else {
        self.firstImageVerticalScreenOffsetY = [self calculationSumOfTheArray:[self.imageHeights subarrayWithRange:NSMakeRange(0, self.currentImageIndex - 2)]];
    }
    
    [self layoutSelfSubviews];
}

# pragma mark - Calculation

// 计算总和
- (CGFloat)calculationSumOfTheArray:(NSArray *)array
{
    NSNumber *sum = [array valueForKeyPath:@"@sum.floatValue"];
    return [sum floatValue];
}

// 计算缩放图片视图的frame
- (CGRect)scaleImageView:(UIImageView *)imageView
       frameWithMultiple:(CGFloat)multiple
              AtPosition:(ImagePosition)position
{
    // 确定当前可视界面的原始点
    CGPoint origin = CGPointZero;
    if (self.scrollType == ScrollOrientationTypeVertical) {
        origin = CGPointMake(0, self.scrollViewVerticalScreenOffsetY);
    } else if (self.scrollType == ScrollOrientationTypeHorizontal) {
        origin = CGPointMake(SCREEN_WIDTH, 0);
    }
    CGRect frame = imageView.frame;
    if (position == ImagePositionLeft) {
        // 滑动中，在左边
        frame.origin.y = origin.y + frame.size.height * (1 - multiple)/2;
        frame.origin.x = origin.x + frame.size.width * (1 - CURRENT_SCALE_VALUE)/2 - LEFT_RIGHT_MARGIN * (CURRENT_SCALE_VALUE - multiple) * 10;
    } else if (position == ImagePositionCurrent) {
        frame.origin.y = origin.y + frame.size.height * (1 - multiple)/2;
        frame.origin.x = origin.x + frame.size.width * (1 - multiple)/2;
    } else if (position == ImagePositionRight) {
        frame.origin.y = origin.y + frame.size.height * (1 - multiple)/2;
        frame.origin.x = origin.x + frame.size.width * (0.5 - multiple + CURRENT_SCALE_VALUE/2.0) + LEFT_RIGHT_MARGIN * (CURRENT_SCALE_VALUE - multiple) * 10;
    }
    frame.size.width *= multiple;
    frame.size.height *= multiple;
    return frame;
}

# pragma mark - Scroll view scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 图片总张数小于图片总数
    if (self.totalCount <= MAX_IMAGEVIEW) {
        return;
    }
    
    if (self.scrollType == ScrollOrientationTypeVertical) {
        if (scrollView.contentOffset.y <= 0 || scrollView.contentOffset.y >= scrollView.contentSize.height - [self.models.lastObject showHeight]) {
            return;
        }
        
        CGFloat nextImageHeight = 0.0; // 即将出现的图片高
        NSInteger newestIndex = self.currentImageIndex; // 最新时刻的下标
        CGFloat newestOffsetY = scrollView.contentOffset.y; // 最新时刻的偏移量
        CGFloat maxOffsetY = self.screenType == ScreenOrientationTypeVertical ? self.totalImageHeight - SCREEN_HEIGHT : self.totalImageHeight * SCREEN_SCALE - SCREEN_HEIGHT;
        
        if (newestOffsetY > self.currentOffset.y && self.currentImageIndex < self.totalCount - 1) {
            // 上滑且没有触底
            ComicContentModel *nextModel = self.models[self.currentImageIndex + 1];
            UIImageView *nextImageView = [self viewWithTag:self.currentImageIndex + 1 + RUN_TAG];
            nextImageHeight = self.screenType == ScreenOrientationTypeVertical ? nextModel.showHeight : nextModel.showHeight * SCREEN_SCALE;
            if (nextImageHeight < SCREEN_HEIGHT) {
                newestIndex = (newestOffsetY + SCREEN_HEIGHT) >= (nextImageHeight/2.0 + nextImageView.y) ? self.currentImageIndex + 1 : self.currentImageIndex;
            } else {
                newestIndex = (newestOffsetY + SCREEN_HEIGHT) >= (nextImageView.y + SCREEN_HEIGHT/2) ? self.currentImageIndex + 1 : self.currentImageIndex;
            }
            
            // 刷新富余imageView视图
            if (newestIndex > self.currentImageIndex && newestIndex < self.totalCount - 2 && newestIndex > 2) {
                UIImageView *lastImage = nil;
                lastImage = [self viewWithTag:newestIndex - 3 + RUN_TAG];
                UIImageView *nextImage = [self viewWithTag:newestIndex + 1 + RUN_TAG];
                ComicContentModel *model = self.models[newestIndex + 2];
                [lastImage sd_setImageWithURL:[NSURL URLWithString:model.location]];
                CGFloat lastImageHeight = self.screenType == ScreenOrientationTypeVertical ? model.showHeight : model.showHeight * SCREEN_SCALE;
                lastImage.frame = CGRectMake(0, nextImage.maxY, SCREEN_WIDTH, lastImageHeight);
                lastImage.tag = newestIndex + 2 + RUN_TAG;
                
                // 确定
                UIImageView *firstImage = [self viewWithTag:newestIndex - 2 + RUN_TAG];
                self.firstImageVerticalScreenOffsetY = self.screenType == ScreenOrientationTypeVertical ? firstImage.y : (firstImage.y / SCREEN_SCALE);
            }
        } else if (newestOffsetY < self.currentOffset.y && self.currentImageIndex > 0 && newestOffsetY < maxOffsetY - 10) {
            // 下滑且没有触顶，添加newestOffsetY判断，是为了滑到底部时候回弹
            ComicContentModel *nextModel = self.models[self.currentImageIndex - 1];
            UIImageView *nextImageView = [self viewWithTag:self.currentImageIndex - 1 + RUN_TAG];
            nextImageHeight = self.screenType == ScreenOrientationTypeVertical ? nextModel.showHeight : nextModel.showHeight * SCREEN_SCALE;
            if (nextImageHeight < SCREEN_HEIGHT) {
                newestIndex = newestOffsetY  <= (nextImageView.maxY - nextImageHeight/2.0) ? self.currentImageIndex - 1 : self.currentImageIndex;
            } else {
                newestIndex = newestOffsetY <= (nextImageView.maxY - SCREEN_HEIGHT/2.0) ? self.currentImageIndex - 1 : self.currentImageIndex;
            }
            
            // 刷新富余imageView视图
            if (newestIndex < self.currentImageIndex && newestIndex < self.totalCount - 3 && newestIndex > 1) {
                UIImageView *lastImage = nil;
                lastImage = [self viewWithTag:newestIndex + 3 + RUN_TAG];
                UIImageView *nextImage = [self viewWithTag:newestIndex - 1 + RUN_TAG];
                ComicContentModel *model = self.models[newestIndex - 2];
                [lastImage sd_setImageWithURL:[NSURL URLWithString:model.location]];
                CGFloat lastImageHeight = self.screenType == ScreenOrientationTypeVertical ? model.showHeight : model.showHeight * SCREEN_SCALE;
                lastImage.frame = CGRectMake(0, nextImage.y - lastImageHeight, SCREEN_WIDTH, lastImageHeight);
                lastImage.tag = newestIndex - 2 + RUN_TAG;
                
                // 确定
                UIImageView *firstImage = [self viewWithTag:newestIndex - 2 + RUN_TAG];
                self.firstImageVerticalScreenOffsetY = self.screenType == ScreenOrientationTypeVertical ? firstImage.y : (firstImage.y / SCREEN_SCALE);
            }
        }
        self.currentOffset = scrollView.contentOffset;
        self.currentImageIndex = newestIndex;
        self.scrollViewVerticalScreenOffsetY = self.screenType == ScreenOrientationTypeVertical ?self.currentOffset.y : (self.currentOffset.y / SCREEN_SCALE);
    } if (self.scrollType == ScrollOrientationTypeHorizontal) {
        // 滑动范围超过显示区域
        if (scrollView.contentOffset.x <= 0 || scrollView.contentOffset.x >= (self.totalCount - 1) * self.width) {
            return;
        }
        
        CGFloat newesOffsetX = self.contentOffset.x;
        NSInteger newesIndex = self.currentImageIndex;
        if (newesOffsetX > self.currentOffset.x && self.currentImageIndex < self.totalCount - 1) {
            // 左划
            newesIndex = (newesOffsetX + self.width/2.0) / self.width;
            if (newesIndex > self.currentImageIndex && newesIndex > 2 && newesIndex < self.totalCount - 2) {
                UIImageView *lastLastImageView = [self viewWithTag:newesIndex - 3 + RUN_TAG];
                UIImageView *nextImageView = [self viewWithTag:newesIndex + 1 + RUN_TAG];
                ComicContentModel *nextNextmodel = self.models[newesIndex + 2];
                [lastLastImageView sd_setImageWithURL:[NSURL URLWithString:nextNextmodel.location]];
                lastLastImageView.frame = CGRectMake(nextImageView.maxX, 0, self.width, self.height);
                lastLastImageView.tag = newesIndex + 2 + RUN_TAG;
            }
        } else if (newesOffsetX < self.currentOffset.x && self.currentImageIndex > 0) {
            // 右划
            newesIndex = newesOffsetX / self.width;
            if (newesIndex < self.currentImageIndex && newesIndex > 1 && newesIndex < self.totalCount - 3) {
                UIImageView *lastLastImageView = [self viewWithTag:newesIndex + 3 + RUN_TAG];
                UIImageView *nextImageView = [self viewWithTag:newesIndex - 1 + RUN_TAG];
                ComicContentModel *nextNextmodel = self.models[newesIndex - 2];
                [lastLastImageView sd_setImageWithURL:[NSURL URLWithString:nextNextmodel.location]];
                lastLastImageView.frame = CGRectMake(nextImageView.x - self.width, 0, self.width, self.height);
                lastLastImageView.tag = newesIndex - 2 + RUN_TAG;
            }
        }
        self.currentOffset = scrollView.contentOffset;
        self.currentImageIndex = newesIndex;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.startScrollBlock) {
        self.startScrollBlock();
    }
}

@end
