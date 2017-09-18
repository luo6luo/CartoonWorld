//
//  SouSouCell.m
//  二次元境
//
//  Created by MS on 15/11/24.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "SouSouCell.h"

@interface SouSouCell ()

@property (nonatomic ,strong) UIImageView * imageView;
@property (nonatomic ,strong) UILabel * nameL;
@property (nonatomic ,strong) UILabel * imageL;

@end

@implementation SouSouCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)setModel:(NSArray *)model
{
    _model = model;
    _imageView.image = [UIImage imageNamed:model[0]];
    _imageL.text = model[1];
    _nameL.text = model[1];
}

- (void)createUI
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 80)/3, (SCREEN_WIDTH - 80)/3)];
    _imageView.layer.cornerRadius = 5;
    _imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageView];
    
    _imageL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 80)/3, (SCREEN_WIDTH - 80)/3)];
    _imageL.textColor = [UIColor whiteColor];
    _imageL.textAlignment = NSTextAlignmentCenter;
    _imageL.font = [UIFont systemFontOfSize:20];
    _imageL.layer.cornerRadius = 5;
    _imageL.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageL];
    
    _nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame), (SCREEN_WIDTH - 80)/3, (SCREEN_WIDTH - 80)/9)];
//    _nameL.textColor = TEXT_COLOR;
    _nameL.textAlignment = NSTextAlignmentCenter;
    _nameL.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_nameL];
}

@end
