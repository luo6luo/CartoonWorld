//
//  SearchTabelViewCell.m
//  二次元境
//
//  Created by MS on 15/11/27.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "SearchTVCell.h"
#import "HotSearchModel.h"

@interface SearchTVCell ()

@property (nonatomic ,strong) UITableView * tabelCell;

@end

@implementation SearchTVCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_BACK_WHITE;
        [self createUI];
    }
    return self;
}

- (void)setArray:(NSArray *)array
{
    _array = array;
    [_tabelCell reloadData];
}

- (void)createUI
{
    _tabelCell = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height) style:UITableViewStylePlain];
    _tabelCell.delegate = self;
    _tabelCell.dataSource = self;
    _tabelCell.backgroundColor = COLOR_BACK_WHITE;
    [_tabelCell registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.contentView addSubview:_tabelCell];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    HotSearchModel * model = self.array[indexPath.row];
    cell.textLabel.text = model.tag;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.textColor = [RGBColor colorWithHexString:model.bgColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.backgroundColor = COLOR_BACK_WHITE;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HotSearchModel * model = self.array[indexPath.row];
    [self.delegate cellWithText:model.tag];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
