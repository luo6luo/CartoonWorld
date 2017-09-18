//
//  RecommendWebCell.m
//  二次元境
//
//  Created by 顿顿 on 16/4/6.
//  Copyright © 2016年 MS. All rights reserved.
//

#import "RecommendWebCell.h"

@interface RecommendWebCell ()

@property (nonatomic ,assign) CGFloat width;
@property (nonatomic ,assign) CGFloat height;
@property (nonatomic ,strong) UIImageView * imageView;

@end

@implementation RecommendWebCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _width = frame.size.width;
        _height = frame.size.height;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        [self createUI];
    }
    return self;
}

//- (void)setModel:(BannerItemsModel *)model
//{
//    _model = model;
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.smallImageUrl]];
//    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
//}

- (void)createUI
{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _width, _width/2)];
    self.imageView.layer.cornerRadius = 4;
    self.imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageView];
}

@end
