//
//  ReadMenuBar.m
//  CartoonWorld
//
//  Created by dundun on 2018/4/12.
//  Copyright © 2018年 顿顿. All rights reserved.
//

#import "ReadMenuBar.h"

@interface ReadMenuBar()

@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) NSArray *imageNames;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSMutableDictionary *isSelectedDic;

@end

@implementation ReadMenuBar

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = COLOR_TOOL_BAR;
        
        [self setupData];
        [self setupSubviews];
    }
    return self;
}

# pragma mark - Getter

- (NSMutableDictionary *)isSelectedDic
{
    if (!_isSelectedDic) {
        _isSelectedDic = [NSMutableDictionary dictionary];
    }
    return _isSelectedDic;
}

# pragma mark - Setter

- (void)setMaxPage:(NSInteger)maxPage
{
    _maxPage = maxPage;
    self.pageLabel.text = [NSString stringWithFormat:@"0/%ld",(long)maxPage - 1];
    self.slider.maximumValue = maxPage - 1;
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)currentPage, (long)self.maxPage - 1];
    self.slider.value = currentPage;
}

# pragma mark - Set up

- (void)setupData
{
    self.imageNames = @[
      @[@"off_light", @"open_light"],
      @[@"horizontal_screen", @"vertical_screen"],
      @[@"light_switch", @"light_switch"],
      @[@"horizontal_scroll", @"vertical_scroll"]
    ];
    
    self.titles = @[
      @[@"关灯", @"开灯"],
      @[@"横屏", @"竖屏"],
      @[@"亮度", @"亮度"],
      @[@"横滑", @"竖滑"]
    ];
    
    for (int i = 0; i < self.titles.count; i++) {
        ButtonType type = i;
        NSString *typeString = [NSString stringWithFormat:@"%ld", (long)type];
        [self.isSelectedDic setObject:@(NO) forKey:typeString];
    }
}

- (void)setupSubviews
{
    // 显示当前进度页数
    self.pageLabel = [UILabel labelWithText:nil textColor:COLOR_TEXT_WHITE fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentCenter];
    [self addSubview:self.pageLabel];
    
    // 进度条
    self.slider = [[UISlider alloc] init];
    self.slider.minimumValue = 0;
    [self.slider setThumbImage:[UIImage imageNamed:@"round"] forState:UIControlStateNormal];
    [self.slider addTarget:self action:@selector(sliderStartToSlide:) forControlEvents:UIControlEventTouchDown];
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.slider addTarget:self action:@selector(sliderStopToSlide:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.slider];
    
    // 按钮
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *button = [self setupMenuItemWithIndex:i];
        [self addSubview:button];
    }
    
    [self layoutSelfSubviews];
}

- (UIButton *)setupMenuItemWithIndex:(NSInteger)index
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = index + 10;
    btn.tintColor = COLOR_WHITE;
    
    // 设置按钮图片和文字位置
    ButtonType type = index;
    btn.titleLabel.font = [UIFont systemFontOfSize:FONT_SUBTITLE];
    [btn setTitle:self.titles[type][0] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:self.imageNames[type][0]] forState:UIControlStateNormal];
    
    CGFloat itemWidth = (SCREEN_WIDTH - 2*LEFT_RIGHT - (self.titles.count - 1) * MIDDLE_SPASE) / self.titles.count;
    btn.frame = CGRectMake(0, 0, itemWidth, HEIGHT_MENU_ITEM);
    CGSize imageSize = btn.imageView.bounds.size;
    CGSize titleSize = btn.titleLabel.bounds.size;
    CGFloat interval = 1.0;
    btn.titleEdgeInsets = UIEdgeInsetsMake(imageSize.height + interval, -(imageSize.width + interval), 0, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0,0, titleSize.height + interval, -(titleSize.width + interval));
    
    [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

# pragma mark - Layout

- (void)layoutSelfSubviews
{
    self.frame = CGRectMake(0, SCREEN_HEIGHT - HEIGHT_MENU_BAR, SCREEN_WIDTH, HEIGHT_MENU_BAR);
    CGFloat contentWidth = SCREEN_WIDTH - 2*LEFT_RIGHT;
    CGFloat itemWidth = (contentWidth - (self.titles.count - 1) * MIDDLE_SPASE) / self.titles.count;
    self.pageLabel.frame = CGRectMake(LEFT_RIGHT, TOP_BOTTOM, 2*LABEL_HEIGHT, LABEL_HEIGHT);
    self.slider.frame = CGRectMake(self.pageLabel.maxX + MIDDLE_SPASE, TOP_BOTTOM, contentWidth - self.pageLabel.width - MIDDLE_SPASE, LABEL_HEIGHT);
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *button = [self viewWithTag:i + 10];
        button.frame = CGRectMake(LEFT_RIGHT + (itemWidth + MIDDLE_SPASE) * i, self.slider.maxY + TOP_BOTTOM, itemWidth, HEIGHT_MENU_ITEM);
    }
}

# pragma mark - Response event

- (void)buttonClicked:(UIButton *)sender
{
    ButtonType type = sender.tag - 10;
    NSString *typeString = [NSString stringWithFormat:@"%ld", (long)type];
    BOOL isSelected = [[self.isSelectedDic valueForKey:typeString] boolValue];
    if (isSelected) {
        // 未被选中
        [sender setImage:[UIImage imageNamed:self.imageNames[type][0]] forState:UIControlStateNormal];
        [sender setTitle:self.titles[type][0] forState:UIControlStateNormal];
        [self.isSelectedDic setObject:@(NO) forKey:typeString];
    } else {
        // 被选中
        [sender setImage:[UIImage imageNamed:self.imageNames[type][1]] forState:UIControlStateNormal];
        [sender setTitle:self.titles[type][1] forState:UIControlStateNormal];
        [self.isSelectedDic setObject:@(YES) forKey:typeString];
    }
    
    if ([self.delegate respondsToSelector:@selector(button:clickedWithButtonType:isSelected:)]) {
        [self.delegate button:sender clickedWithButtonType:type isSelected:isSelected];
    }
}

// 开始滑动
- (void)sliderStartToSlide:(UISlider *)sender
{
    if (self.maxPage <= 0) {
        self.slider.value = 0;
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(slider:startToSlideAtCurrentValue:)]) {
        [self.delegate slider:sender startToSlideAtCurrentValue:sender.value];
    }
}

// 滑动值变化
- (void)sliderValueChanged:(UISlider *)sender
{
    if (self.maxPage <= 0) {
        self.slider.value = 0;
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(slider:valueChanged:)]) {
        [self.delegate slider:sender valueChanged:sender.value];
    }
}

// 结束滑动
- (void)sliderStopToSlide:(UISlider *)sender
{
    if (self.maxPage <= 0) {
        self.slider.value = 0;
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(slider:stopToSlideAtCurrentValue:)]) {
        [self.delegate slider:sender stopToSlideAtCurrentValue:sender.value];
    }
}

@end
