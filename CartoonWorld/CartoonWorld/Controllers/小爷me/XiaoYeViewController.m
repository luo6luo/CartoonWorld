//
//  XiaoYeViewController.m
//  二次元境
//
//  Created by HecH on 15-11-18.
//  Copyright (c) 2015年 CK. All rights reserved.
//

#import "XiaoYeViewController.h"
#import "XiaoYeCell.h"
#import "OtherUserCell.h"
#import "UserInfoModel.h"

@interface XiaoYeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView * myTabelView;
@property (nonatomic ,strong) NSMutableArray * dataArr;
@property (nonatomic ,strong) UserInfoModel * model;

@end

@implementation XiaoYeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createData];
}

- (void)createData
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }else {
        [_dataArr removeAllObjects];
    }
    
    self.model = [[UserInfoModel alloc] init];
    self.model.imageStr = @"c497b618b6cbada07d4e1ff977aa40a3副本.jpeg";
    self.model.nameStr = @"兔子";
    self.model.detailStr = @"O(∩_∩)O~~";
    
    NSArray * imageArr = @[@"home_region_icon_153",@"home_region_icon_137",@"home_region_icon_126",@"home_region_icon_122"];
    NSArray * nameArr = @[@"历史记录",@"我的搜藏",@"关注的人",@"设置"];
    for (int i = 0; i < 4; i ++) {
        NSMutableArray * arr = [NSMutableArray array];
        if (i == 3) {
            for (int j = 0; j < 4; j ++) {
                [arr addObject:@{@"image":imageArr[j],@"name":nameArr[j]}];
            }
        }else if (i == 0){
            [arr addObject:@{}];
        }else if (i == 1){
            [arr addObject:@{@"image":@"home_region_icon_19",@"name":@"消息"}];
        }else if (i == 2){
            [arr addObject:@{@"image":@"home_region_icon_22",@"name":@"离线任务"}];
        }
        [_dataArr addObject:arr];
    }
    [self createUI];
}

- (void)createUI
{
    _myTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    _myTabelView.delegate = self;
    _myTabelView.dataSource = self;
    _myTabelView.backgroundColor = COLOR_BACK_WHITE;
    self.myTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTabelView];
    //注册cell
    [_myTabelView registerClass:[XiaoYeCell class] forCellReuseIdentifier:@"userCell"];
    [_myTabelView registerClass:[OtherUserCell class] forCellReuseIdentifier:@"otherUserCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        XiaoYeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
        cell.model = self.model;
        return cell;
    }else{
        OtherUserCell * cell = [tableView dequeueReusableCellWithIdentifier:@"otherUserCell" forIndexPath:indexPath];
        cell.dataDic = _dataArr[indexPath.section][indexPath.row];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!header) {
        header = [[UIView alloc] init];
        header.backgroundColor = COLOR_BACK_WHITE;
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
