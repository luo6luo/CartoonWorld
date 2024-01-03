//
//  MyControllerController.m
//  二次元境
//
//  Created by HecH on 15-11-18.
//  Copyright (c) 2015年 CK. All rights reserved.
//

#import "MyController.h"
#import "UserInfoController.h"
#import "OtherWorksListController.h"
#import "SearchHistoryController.h"

#import "UserHeaderCell.h"
#import "OtherUserCell.h"

#import "StringObject.h"
#import "UserModel.h"
#import "DatebaseManager.h"

#import <SDWebImage/SDImageCache.h>

static NSString *kUserHeaderCell = @"userHeaderCell";
static NSString *kUserOtherCell = @"userOtherCell";

@interface MyController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView *myTableView;
@property (nonatomic ,strong) NSArray *dataArr;
@property (nonatomic ,strong) UserModel *model;

@end

@implementation MyController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BACK_WHITE;
    self.title = @"我的";
    
    [self setupData];
    [self setupSubview];
}

# pragma mark - Set up

- (void)setupSubview
{
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT_V) style:UITableViewStyleGrouped];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = COLOR_BACK_WHITE;
    self.self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.myTableView];
}

- (void)setupData
{
    self.dataArr = @[
      @[@"search_history", @"历史记录"],
      @[@"my_collection", @"我的收藏"],
      @[@"setting", @"清除缓存"]
    ];
}

# pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return self.dataArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UserHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:kUserHeaderCell];
        if (!headerCell) {
            headerCell = [[UserHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUserHeaderCell];
        }
        [headerCell reloadData];
        return headerCell;
    } else {
        OtherUserCell * otherCell = [tableView dequeueReusableCellWithIdentifier:kUserOtherCell];
        if (!otherCell) {
            otherCell = [[OtherUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUserOtherCell];
        }
        otherCell.infoArr = self.dataArr[indexPath.row];
        return otherCell;
    }
}

# pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return HEIGHT_CELL_HEADER;
    } else {
        return HEIGHT_CELL_OTHER;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return HEIGHT_SECTION_MIN;
    } else {
        return HEIGHT_SECTION_MAX;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return HEIGHT_SECTION_MAX;
    } else {
        return HEIGHT_SECTION_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UserInfoController *userInfoController = [[UserInfoController alloc] initWithStyle:UITableViewStyleGrouped];
        userInfoController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userInfoController animated:YES];
        
        WeakSelf(self);
        userInfoController.handleStatus = ^(BOOL isHandel) {
            [weakself.myTableView reloadData];
        };
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        // 历史记录
        SearchHistoryController *historyController = [[SearchHistoryController alloc] init];
        historyController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:historyController animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        // 我的收藏
        OtherWorksListController *otherController = [[OtherWorksListController alloc] initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
        otherController.otherWorks = (NSArray *)[UserModel defaultUser].favorites;
        otherController.title = @"我的收藏";
        otherController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:otherController animated:YES];
    } else {
        // 清除缓存
        [AlertManager alerAddToController:self message:@"您确定要清除所有缓存么？" sure:^{
            [[SDImageCache sharedImageCache] clearMemory];
            [[DatebaseManager defaultDatebaseManager] deleteAllObjectCompleted:nil];
        } cancel:nil];
    }
}

@end
