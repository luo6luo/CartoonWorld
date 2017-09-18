//
//  GuessLickCellCell.m
//  CartoonWorld
//
//  Created by dundun on 2017/9/6.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "GuessLikeCell.h"
#import "GuessLikeModel.h"

@interface GuessLikeCell()

@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;
@property (weak, nonatomic) IBOutlet UIImageView *fourthImage;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;

@end

@implementation GuessLikeCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.backgroundColor = COLOR_WHITE;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setupSubviews];
}

- (void)setupSubviews
{
    self.firstImage.backgroundColor = COLOR_BACK_GRAY;
    self.secondImage.backgroundColor = COLOR_BACK_GRAY;
    self.thirdImage.backgroundColor = COLOR_BACK_GRAY;
    self.fourthImage.backgroundColor = COLOR_BACK_GRAY;
    
    self.firstLabel.textColor = COLOR_TEXT_BLACK;
    self.secondLabel.textColor = COLOR_TEXT_BLACK;
    self.thirdLabel.textColor = COLOR_TEXT_BLACK;
    self.fourthLabel.textColor = COLOR_TEXT_BLACK;
    
    // 第一个图片添加手势
    UITapGestureRecognizer *firstTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstImageClicked:)];
    [self.firstImage addGestureRecognizer:firstTap];
    
    // 第二个图片添加手势
    UITapGestureRecognizer *secondTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondImageClicked:)];
    [self.secondImage addGestureRecognizer:secondTap];
    
    // 第三个图片添加手势
    UITapGestureRecognizer *thirdTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thirdImageClicked:)];
    [self.thirdImage addGestureRecognizer:thirdTap];
    
    // 第四个图片添加手势
    UITapGestureRecognizer *fourthTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fourthImageClicked:)];
    [self.fourthImage addGestureRecognizer:fourthTap];
}

- (void)setGuesLikeModels:(NSArray *)guesLikeModels
{
    _guesLikeModels = guesLikeModels;
    
    for (int i = 0; i < 4; i++) {
        if (guesLikeModels.count > i) {
            GuessLikeModel *model = guesLikeModels[i];
            if (i == 0) {
                [self.firstImage sd_setImageWithURL:[NSURL URLWithString:model.cover]];
                self.firstLabel.text = model.name;
            } else if (i == 1) {
                [self.secondImage sd_setImageWithURL:[NSURL URLWithString:model.cover]];
                self.secondLabel.text = model.name;
            } else if (i == 2) {
                [self.thirdImage sd_setImageWithURL:[NSURL URLWithString:model.cover]];
                self.thirdLabel.text = model.name;
            } else if (i == 3) {
                [self.fourthImage sd_setImageWithURL:[NSURL URLWithString:model.cover]];
                self.fourthLabel.text = model.name;
            }
        }
    }
}

# pragma mark - Response events

- (void)firstImageClicked:(UITapGestureRecognizer *)tap
{
    if (self.firstImageClickedBlock && self.guesLikeModels.count >= 1) {
        self.firstImageClickedBlock(self.guesLikeModels[0]);
    }
}

- (void)secondImageClicked:(UITapGestureRecognizer *)tap
{
    if (self.secondImageClickedBlock && self.guesLikeModels.count >= 2) {
        self.secondImageClickedBlock(self.guesLikeModels[1]);
    }
}

- (void)thirdImageClicked:(UITapGestureRecognizer *)tap
{
    if (self.thirdImageClickedBlock && self.guesLikeModels.count >= 3) {
        self.thirdImageClickedBlock(self.guesLikeModels[2]);
    }
}

- (void)fourthImageClicked:(UITapGestureRecognizer *)tap
{
    if (self.fourthImageClickedBlock && self.guesLikeModels.count >= 4) {
        self.fourthImageClickedBlock(self.guesLikeModels[3]);
    }
}

@end
