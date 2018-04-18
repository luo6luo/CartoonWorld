//
//  SearchHotCell.m
//  CartoonWorld
//
//  Created by dundun on 2017/11/6.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "SearchHotCell.h"
#import "SearchHotModel.h"

@interface SearchHotCell()

@property (nonatomic, strong) NSArray *hotArr;

@end

@implementation SearchHotCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier hotArr:(NSArray *)hotArr
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = COLOR_WHITE;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.hotArr = hotArr;
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    NSInteger row = 0;
    CGFloat totalX = LEFT_RIGHT;
    CGFloat totalY = 0.0;
    
    for (int i = 0; i < self.hotArr.count; i++) {
        SearchHotModel *model = self.hotArr[i];
        UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        tagBtn.layer.cornerRadius = TAG_BUTTON_HEIGHT/2;
        tagBtn.layer.masksToBounds = YES;
        tagBtn.layer.borderColor = COLOR_APP_LINE.CGColor;
        tagBtn.layer.borderWidth = 1.0;
        tagBtn.tag = 10 + i;
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_CONTENT];
        [tagBtn setTitle:model.tagName forState:UIControlStateNormal];
        [tagBtn setTitleColor:COLOR_TEXT_GRAY forState:UIControlStateNormal];
        [tagBtn addTarget:self action:@selector(tagBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:tagBtn];
        
        CGSize titleSize = [model.tagName adaptiveSizeWithWidth:MAXFLOAT height:TAG_BUTTON_HEIGHT fontSize:FONT_CONTENT];
        
        // 设置x位置
        if (totalX == LEFT_RIGHT) {
            // 每行中第一个
            totalX = LEFT_RIGHT;
        } else {
            CGFloat curruntX = totalX + 2*MIDDLE_SPASE + titleSize.width + 10;
            if (curruntX > SCREEN_WIDTH - LEFT_RIGHT) {
                // 当前X位置大于能显示的位置，换行
                row++;
                totalX = LEFT_RIGHT;
            } else {
                totalX += 2*MIDDLE_SPASE;
            }
        }
        
        // 设置y位置
        if (row == 0) {
            totalY = TOP_BOTTOM;
        } else {
            totalY = TOP_BOTTOM +  row * (TAG_BUTTON_HEIGHT + 2*MIDDLE_SPASE);
        }
        
        // 设置高宽
        tagBtn.frame = CGRectMake(totalX, totalY, titleSize.width + 10, TAG_BUTTON_HEIGHT);
        totalX += (titleSize.width + 10);
    }
}

- (void)tagBtnClicked:(UIButton *)button
{
    NSInteger btnTag = button.tag;
    SearchHotModel *model = self.hotArr[btnTag - 10];
    if (self.tagBtnClickedBlock) {
        self.tagBtnClickedBlock(model);
    }
}

@end
