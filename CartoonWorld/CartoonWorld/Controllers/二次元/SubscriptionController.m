//
//  SubscriptionController.m
//  CartoonWorld
//
//  Created by dundun on 2017/6/23.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "SubscriptionController.h"

#import "SubscriptionCell.h"

#import "ComicModel.h"

@interface SubscriptionController ()

@property (nonatomic ,strong) NSMutableArray *modelArr;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) NSInteger page;

@end

static NSString *const kSubscriptionCell = @"subscriptionCell";

@implementation SubscriptionController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupRefresh];
}

- (NSMutableArray *)modelArr
{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

#pragma mark - Download data

- (void)downloadData
{
    //添加活动指示器
    if (!self.isFinishedDownload) {
        [AlertManager showLoading];
    }
    
    //开始请求
    self.view.userInteractionEnabled = NO;
    [[NetWorkingManager defualtManager] subscriptionWithPage:self.page success:^(id responseBody) {
        if (self.page == 1) {
            self.modelArr.array = responseBody[@"models"];
        } else {
            self.modelArr.array = [self.modelArr arrayByAddingObjectsFromArray:responseBody[@"models"]];
        }
        
        self.hasMore = [responseBody[@"hasMore"] boolValue];
        
        [self.tableView reloadData];
        [RefreshManager stopRefreshInView:self.tableView];
        [AlertManager dismissLoadingWithstatus:ShowSuccess];
        self.view.userInteractionEnabled = YES;
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [RefreshManager stopRefreshInView:self.tableView];
        [AlertManager dismissLoadingWithstatus:ShowFailure];
        self.view.userInteractionEnabled = YES;
    }];
}

- (void)downloadDataMore
{
    if (self.hasMore) {
        self.page++;
        [self downloadData];
    } else {
        [AlertManager showInfo:@"没有了/(ㄒoㄒ)/~~"];
    }
}

- (void)downloadFirstPageData
{
    self.page = 1;
    [self downloadData];
}

#pragma mark - Set up

- (void)setupRefresh
{
    self.tableView.backgroundColor = COLOR_BACK_WHITE;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [RefreshManager pullDownRefreshInView:self.tableView targer:self action:@selector(downloadFirstPageData)];
    [RefreshManager pullUpRefreshInView:self.tableView targer:self action:@selector(downloadDataMore)];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubscriptionCell *subscriptionCell = [tableView dequeueReusableCellWithIdentifier:kSubscriptionCell];
    if (!subscriptionCell) {
        subscriptionCell = [[SubscriptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSubscriptionCell];
    }
    subscriptionCell.comicModel = self.modelArr[indexPath.row];
    return subscriptionCell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SUBSCRIPTION_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
