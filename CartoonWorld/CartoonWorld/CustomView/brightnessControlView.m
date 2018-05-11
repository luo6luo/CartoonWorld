//
//  brightnessControlView.m
//  CartoonWorld
//
//  Created by dundun on 2018/5/8.
//  Copyright © 2018年 顿顿. All rights reserved.
//

#define DELAY_TIME 0.2

#import "BrightnessControlView.h"

@interface BrightnessControlView()

@property (nonatomic, strong) UISlider *slider;

@end

@implementation BrightnessControlView

+ (BrightnessControlView *)defaultControlView
{
    static BrightnessControlView *view = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!view) {
            view = [[BrightnessControlView alloc] init];
        }
    });
    return view;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = COLOR_TOOL_BAR;
        self.alpha = 0.9;
        
        self.slider = [[UISlider alloc] init];
        self.slider.minimumValue = 0;
        self.slider.maximumValue = 1;
        [self.slider setThumbImage:[UIImage imageNamed:@"brightness_control"] forState:UIControlStateNormal];
        [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.slider];
    }
    return self;
}

- (void)sliderValueChanged:(UISlider *)sender
{
    [[UIScreen mainScreen] setBrightness:sender.value];
}

- (void)layoutSubviews
{
    self.frame = CGRectMake(SCREEN_WIDTH/6, SCREEN_HEIGHT * 1/3, SCREEN_WIDTH * 2/3, 2*LABEL_HEIGHT);
    self.slider.frame = CGRectMake(LEFT_RIGHT, 0, self.width - 2*LEFT_RIGHT, self.height);
}

# pragma mark - Show & dismiss

+ (void)showControlBarInView:(UIView *)supview
{
    if (!supview) {
        return;
    }
    
    BrightnessControlView *controlView = [BrightnessControlView defaultControlView];
    controlView.slider.value = [UIScreen mainScreen].brightness;
    [supview addSubview:controlView];
}

+ (void)dismissControlBar
{
    BrightnessControlView *controlView = [BrightnessControlView defaultControlView];
    [UIView animateWithDuration:DELAY_TIME animations:^{
        [controlView removeFromSuperview];
    }];
}

@end
