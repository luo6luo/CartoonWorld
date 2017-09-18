//
//  BaseCollectionViewCell.m
//  二次元境
//
//  Created by MS on 15/11/23.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "ShowVC.h"

@interface BaseCollectionViewCell ()

//@property (nonatomic ,strong) DZRImageView * imageView;
@property (nonatomic ,strong) UIImageView * imageIcon;
@property (nonatomic ,strong) UILabel * nameL;
@property (nonatomic ,strong) UILabel * timeL;
@property (nonatomic ,strong) UILabel * introduceL;

@end

@implementation BaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_BACK_GRAY;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        [self createUI];
    }
    return self;
}

- (void)setModel:(BaseCollectionModel *)model
{
//    _model = model;
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.img[@"u"]]];
//    [_imageView addTarget:self withSelector:@selector(imageVIewClicked:)];
//    [_imageIcon sd_setImageWithURL:[NSURL URLWithString:model.user_info[@"avatar"]] placeholderImage:[UIImage imageNamed:@"defaultIcon_header"]];
//    _nameL.text = model.user_info[@"name"];
//    _timeL.text = model.created_at;
//    _introduceL.text = model.introduce;
//    
//    self.imageView.frame = CGRectMake(0, 0, (Screen_Size.width - 30)/2, ([model.img[@"h"] floatValue]/[model.img[@"w"] floatValue]) * (Screen_Size.width - 30)/2);
//    self.imageIcon.frame = CGRectMake(10, CGRectGetMaxY(_imageView.frame) + 10, 30, 30);
//    self.nameL.frame = CGRectMake(CGRectGetMaxX(_imageIcon.frame)+ 10, CGRectGetMaxY(_imageView.frame) + 10, (Screen_Size.width - 30)/2 - 50, 18);
//    self.timeL.frame = CGRectMake(CGRectGetMaxX(_imageIcon.frame) + 10, CGRectGetMaxY(_nameL.frame), (Screen_Size.width - 30)/2 - 50, 12);
//    self.introduceL.frame = CGRectMake(10, CGRectGetMaxY(_imageIcon.frame) + 10, (Screen_Size.width - 30)/2 - 20, [self contentSize:model.introduce]);
    
}

- (void)createUI
{
    //    //宽:  10 + 30 + 10 + ((Screen_Size.width - 30)/2 - 60)
    //    //高: image_H + 10 + 30 + 10 + size_H + 10 + 1 + 5+20+5
//    _imageView = [[DZRImageView alloc] init];
//    self.imageView.backgroundColor = [UIColor lightGrayColor];
//    _imageView.contentMode = UIViewContentModeScaleAspectFill;
//    _imageView.clipsToBounds = YES;
//    [self addSubview:_imageView];
    
    _imageIcon = [[UIImageView alloc] init];
    _imageIcon.layer.cornerRadius = 15;
    _imageIcon.layer.masksToBounds = YES;
    _imageIcon.contentMode = UIViewContentModeScaleAspectFill;
    _imageIcon.clipsToBounds = YES;
    [self addSubview:_imageIcon];
    
    _nameL = [[UILabel alloc] init];
    _nameL.textColor = TEXT_COLOR;
    _nameL.textAlignment = NSTextAlignmentLeft;
    _nameL.font = [UIFont systemFontOfSize:12];
    [self addSubview:_nameL];
    
    _timeL = [[UILabel alloc] init];
    _timeL.textColor = [UIColor lightGrayColor];
    _timeL.textAlignment = NSTextAlignmentLeft;
    _timeL.font = [UIFont systemFontOfSize:10];
    [self addSubview:_timeL];
    
    _introduceL = [[UILabel alloc] init];
    _introduceL.textColor = TEXT_COLOR;
    _introduceL.textAlignment = NSTextAlignmentLeft;
    _introduceL.font = [UIFont systemFontOfSize:12];
    _introduceL.numberOfLines = 0;
    [self addSubview:_introduceL];
    
    UILabel * label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.9];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-30);
//        make.size.mas_equalTo(CGSizeMake((Screen_Size.width - 30)/2 - 20, 1));
    }];
    
    UILabel * Glabel = [[UILabel alloc] init];
    Glabel.backgroundColor = [RGBColor colorWithHexString:@"#EE6AA7"];
    Glabel.text = @"搬运";
    Glabel.textAlignment = NSTextAlignmentCenter;
    Glabel.font = [UIFont systemFontOfSize:12 weight:2];
    Glabel.textColor = [UIColor whiteColor];
    Glabel.layer.cornerRadius = 4;
    Glabel.layer.masksToBounds = YES;
    [self addSubview:Glabel];
    [Glabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
}

//- (void)imageVIewClicked:(DZRImageView *)imageView
//{
//    [self.delegate makeImageToBigWithURL:_model.img[@"u"] andWidth:[_model.img[@"w"] floatValue] andHeight:[_model.img[@"h"] floatValue]];
//}

- (CGFloat)contentSize:(NSString *)text
{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:12],
                                  NSParagraphStyleAttributeName : paragraphStyle};
    CGSize contentSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)
                                            options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                         attributes:attributes
                                            context:nil].size;
    return contentSize.height;
}

@end
