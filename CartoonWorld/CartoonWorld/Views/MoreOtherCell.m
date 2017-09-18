//
//  MoreOtherCell.m
//  CartoonWorld
//
//  Created by dundun on 2017/8/18.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "MoreOtherCell.h"
#import "MoreTopicModel.h"
#import "ComicModel.h"

@interface MoreOtherCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *showImage;
@property (nonatomic, strong) UILabel *promptLabel;

@end

@implementation MoreOtherCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = COLOR_WHITE;
        
        [self setupSubview];
    }
    return self;
}

- (void)setupSubview
{
    // 标题
    self.titleLabel = [UILabel labelWithText:nil textColor:COLOR_TEXT_BLACK fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentLeft];
    self.titleLabel.frame = CGRectMake(LEFT_RIGHT, TOP_BOTTOM, SCREEN_WIDTH - 2*LEFT_RIGHT, LABEL_HEIGHT);
    [self.contentView addSubview:self.titleLabel];
    
    // 展示图片
    self.showImage = [UIImageView imageViewWithFrame:CGRectZero image:nil];
    self.showImage.layer.cornerRadius = 5;
    self.showImage.layer.masksToBounds = YES;
    [self.contentView addSubview:self.showImage];
    
    // 提示信息
    self.promptLabel = [UILabel labelWithText:nil textColor:COLOR_TEXT_WHITE fontSize:FONT_CONTENT textAlignment:NSTextAlignmentLeft];
    self.promptLabel.backgroundColor = [UIColor lightGrayColor];
    self.promptLabel.alpha = 0.7;
    [self.showImage addSubview:self.promptLabel];
}

- (void)layoutSubviews
{
    self.showImage.frame = CGRectMake(LEFT_RIGHT, self.titleLabel.maxY, self.titleLabel.width, HEIGHT_CELL_MOREOTHER - 2*TOP_BOTTOM - LABEL_HEIGHT);
    self.promptLabel.frame = CGRectMake(0, self.showImage.height - LABEL_HEIGHT, self.showImage.width, LABEL_HEIGHT);
}

- (void)setMoreOtherModel:(id)moreOtherModel
{
    _moreOtherModel = moreOtherModel;
    
    if ([moreOtherModel isKindOfClass:[MoreTopicModel class]]) {
        // 专题
        self.titleLabel.text = [moreOtherModel title];
        [self.showImage sd_setImageWithURL:[NSURL URLWithString:[moreOtherModel cover]]];
        self.promptLabel.text = [moreOtherModel subTitle];
    } else {
        // 每日条漫
        self.titleLabel.height = 0;
        [self setNeedsLayout];
        
        [self.showImage sd_setImageWithURL:[NSURL URLWithString:[moreOtherModel cover]]];
        self.promptLabel.text = [moreOtherModel descriptionStr];
    }
}

@end
