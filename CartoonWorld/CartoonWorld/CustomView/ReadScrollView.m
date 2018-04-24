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

#import "ReadScrollView.h"
#import "ComicContentModel.h"

#define INIT_TAG   10  // 初始记录的tag
#define RUN_TAG    100 // 运行时记录的tag
#define MAX_IMAGEVIEW  5
#define SCREEN_SCALE   (SCREEN_WIDTH / SCREEN_HEIGHT) // 注意针对横屏，此处已经转屏

@interface ReadScrollView()<UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger totalCount;         // 图片数
@property (nonatomic, strong) NSMutableArray *models;       // 模型数组
@property (nonatomic, assign) CGFloat totalImageHeight;     // 图片的总高

// 滑动相关
@property (nonatomic, assign) NSInteger currentImageIndex;  // 当前显示图片下标
@property (nonatomic, assign) CGPoint currentOffset;        // 当前滑动式图点

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
    self.totalImageHeight = 0.0f;
    _screenType = ScreenOrientationTypeVertical;
    _scrollType = ScrollOrientationTypeVertical;
}

- (void)setupSubviews
{
    for (int i = 0; i < MAX_IMAGEVIEW; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"default_background"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = i + INIT_TAG;
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
    } else if (self.screenType == ScreenOrientationTypeVertical && self.scrollType == ScrollOrientationTypeVertical) {
        // 竖屏 + 竖滑
        CGFloat imageHeight = self.totalCount > 0 ? self.totalImageHeight : SCREEN_HEIGHT;
        self.contentSize = CGSizeMake(SCREEN_WIDTH, imageHeight);
    } else if (self.screenType == ScreenOrientationTypeVertical && self.scrollType == ScrollOrientationTypeHorizontal) {
        // 竖屏 + 横滑
        self.contentSize = CGSizeMake(count*SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    
    CGFloat imageY = 0.0;
    for (int i = 0; i < MAX_IMAGEVIEW; i++) {
        int tagNumber = self.totalCount > 0 ? RUN_TAG : INIT_TAG;
        UIImageView *imageView = [self viewWithTag:i + tagNumber];
        
        ComicContentModel *model = self.totalCount > 0 ? self.models[i] : nil;
        if (self.screenType == ScreenOrientationTypeVertical && self.scrollType == ScrollOrientationTypeVertical) {
            // 竖屏 + 竖滑
            CGFloat imageHeight = self.totalCount > 0 ? model.showHeight : self.height;
            imageView.frame = CGRectMake(0, imageY, self.width, imageHeight);
            imageY += self.totalCount > 0 ? model.showHeight : 0;
        } else if (self.screenType == ScreenOrientationTypeVertical && self.scrollType == ScrollOrientationTypeHorizontal) {
            // 竖屏 + 横滑
            int j = self.totalCount > 0 ? i : 0;
            imageView.frame = CGRectMake(j* self.width, 0, self.width, self.height);
        } else if (self.screenType == ScreenOrientationTypeHorizontal) {
            // 横滑 + 竖滑
            CGFloat imageHeight = self.totalCount > 0 ? (model.showHeight * SCREEN_SCALE) : SCREEN_WIDTH * SCREEN_SCALE;
            imageView.frame = CGRectMake(0, imageY, self.width, imageHeight);
            imageY += self.totalCount > 0 ? (model.showHeight * SCREEN_SCALE) : 0;
        }
    }
    
    // 滑到对应的位置
    if (self.scrollType == ScrollOrientationTypeVertical && self.screenType == ScreenOrientationTypeVertical) {
        [self setContentOffset:CGPointMake(0, self.currentOffset.y / (SCREEN_HEIGHT / SCREEN_WIDTH)) animated:NO];
    } else if (self.scrollType == ScrollOrientationTypeVertical && self.screenType == ScreenOrientationTypeHorizontal) {
        [self setContentOffset:CGPointMake(0, self.currentOffset.y * SCREEN_SCALE) animated:NO];
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
            self.totalImageHeight += model.showHeight;
        }
    }
    
    // 赋值，并修改imageView的tag为动态的
    for (int i = (int)self.currentImageIndex; i < MAX_IMAGEVIEW; i++) {
        UIImageView *imageView = [self viewWithTag:i + INIT_TAG];
        ComicContentModel *model = self.models[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.location]
                     placeholderImage:[UIImage imageNamed:@"default_background"]];
        imageView.tag = i + RUN_TAG;
    }
    
    [self layoutSelfSubviews];
}

// 刷新图片内容
- (void)refreshImage
{
    if (self.currentImageIndex <= 0 && self.currentImageIndex >= self.totalCount - 1) {
        return;
    }
    
    
}

# pragma mark - Scroll view scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 图片总张数小于图片总数
    if (self.totalCount <= MAX_IMAGEVIEW) {
        return;
    }
    
    if (scrollView.contentOffset.y <= 0 || scrollView.contentOffset.y >= scrollView.contentSize.height - [self.models.lastObject showHeight]) {
        return;
    }
    
    if (self.scrollType == ScreenOrientationTypeVertical) {
        CGFloat nextImageHeight = 0.0; // 即将出现的图片高
        NSInteger newestIndex = self.currentImageIndex; // 最新时刻的下标
        CGFloat newestOffsetY = scrollView.contentOffset.y; // 最新时刻的偏移量
        
        if (newestOffsetY > self.currentOffset.y && self.currentImageIndex < self.totalCount - 1) {
            // 上滑且没有触底
            ComicContentModel *nextModel = self.models[self.currentImageIndex + 1];
            UIImageView *nextImageView = [self viewWithTag:self.currentImageIndex + 1 + RUN_TAG];
            nextImageHeight = nextModel.showHeight;
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
                lastImage.frame = CGRectMake(0, nextImage.y + nextImage.height, SCREEN_WIDTH, model.showHeight);
                lastImage.tag = newestIndex + 2 + RUN_TAG;
            }
        } else if (newestOffsetY < self.currentOffset.y && self.currentImageIndex > 0 && newestOffsetY < self.totalImageHeight - SCREEN_HEIGHT - 10) {
            // 下滑且没有触顶，添加newestOffsetY判断，是为了滑到底部时候回弹
            ComicContentModel *nextModel = self.models[self.currentImageIndex - 1];
            UIImageView *nextImageView = [self viewWithTag:self.currentImageIndex - 1 + RUN_TAG];
            nextImageHeight = nextModel.showHeight;
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
                lastImage.frame = CGRectMake(0, nextImage.y - model.showHeight, SCREEN_WIDTH, model.showHeight);
                lastImage.tag = newestIndex - 2 + RUN_TAG;
            }
        }
        self.currentOffset = scrollView.contentOffset;
        self.currentImageIndex = newestIndex;
    }
}

@end
