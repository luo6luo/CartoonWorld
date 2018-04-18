//
//  MyControllerController.m
//  二次元境
//
//  Created by HecH on 15-11-18.
//  Copyright (c) 2015年 CK. All rights reserved.
//

#import "MyController.h"
#import "UserInfoController.h"
#import "UserHeaderCell.h"
#import "OtherUserCell.h"
#import "UserModel.h"

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
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT) style:UITableViewStyleGrouped];
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
      @[@"setting", @"设置"]
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UserInfoController *userInfoController = [[UserInfoController alloc] initWithStyle:UITableViewStyleGrouped];
        userInfoController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userInfoController animated:YES];
        
        WeakSelf(self);
        userInfoController.handleStatus = ^(BOOL isHandel) {
            
        };
    } else {
        
    }
}

@end
