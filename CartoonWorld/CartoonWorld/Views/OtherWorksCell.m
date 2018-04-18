//
//  OtherWorksCell.m
//  CartoonWorld
//
//  Created by dundun on 2017/9/18.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "OtherWorksCell.h"

@interface OtherWorksCell()

@property (weak, nonatomic) IBOutlet UILabel *otherWorkCount;
@property (weak, nonatomic) IBOutlet UIImageView *rightBtnImage;

@end

@implementation OtherWorksCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = COLOR_WHITE;
    self.otherWorkCount.textColor = COLOR_TEXT_BLACK;
}

- (void)setCount:(NSInteger)count
{
    _count = count;
    self.otherWorkCount.text = [NSString stringWithFormat:@"%ld本", count];
}

@end
