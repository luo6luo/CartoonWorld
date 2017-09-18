//
//  MonthlyTicketCell.m
//  CartoonWorld
//
//  Created by dundun on 2017/9/6.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "MonthlyTicketCell.h"
#import "ComicDetailModel.h"

@interface MonthlyTicketCell()

@property (nonatomic, strong) UILabel *monthlyTicket;
@property (nonatomic, strong) UILabel *monthlyticketTotal;

@end

@implementation MonthlyTicketCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = COLOR_WHITE;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupMonthlyTicketSubviews];
    }
    return self;
}

- (void)setupMonthlyTicketSubviews
{
    // 本月月票标题
    UILabel *monthlyTicketTitle = [UILabel labelWithText:@"本月月票" textColor:COLOR_TEXT_BLACK fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:monthlyTicketTitle];
    [monthlyTicketTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).offset(-SCREEN_WIDTH/4);
        make.height.mas_offset(LABEL_HEIGHT);
        make.width.mas_offset(60);
    }];
    
    // 本月月票数
    self.monthlyTicket = [UILabel labelWithText:nil textColor:COLOR_TEXT_ORANGE fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.monthlyTicket];
    [self.monthlyTicket mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(monthlyTicketTitle.mas_right);
        make.centerY.equalTo(monthlyTicketTitle);
        make.height.mas_offset(LABEL_HEIGHT);
        make.width.mas_offset(30);
    }];
    
    // 累计月票标题
    UILabel *monthlyTicketTotalTitle = [UILabel labelWithText:@"累计月票" textColor:COLOR_TEXT_BLACK fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:monthlyTicketTotalTitle];
    [monthlyTicketTotalTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).offset(SCREEN_WIDTH/4 - 10);
        make.height.mas_offset(LABEL_HEIGHT);
        make.width.mas_offset(60);
    }];
    
    // 累计月票
    self.monthlyticketTotal = [UILabel labelWithText:nil textColor:COLOR_TEXT_ORANGE fontSize:FONT_SUBTITLE textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.monthlyticketTotal];
    [self.monthlyticketTotal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(monthlyTicketTotalTitle.mas_right);
        make.centerY.equalTo(monthlyTicketTotalTitle);
        make.height.mas_offset(LABEL_HEIGHT);
        make.width.mas_offset(40);
    }];
    
    // 分割线
    UIView *line = [UIView new];
    line.backgroundColor = COLOR_APP_LINE;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self);
        make.width.mas_offset(1);
        make.height.mas_offset(HEIGHT_CELL_MONTHLYTICKET/2);
    }];
}

- (void)setDetailModel:(ComicDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    self.monthlyTicket.text = [NSString stringWithFormat:@"%ld",(long)detailModel.monthly_ticket];
    self.monthlyticketTotal.text = [NSString stringWithFormat:@"%ld",(long)detailModel.total_ticket];
}

@end
