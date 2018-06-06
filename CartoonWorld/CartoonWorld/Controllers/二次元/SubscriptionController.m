//
//  SubscriptionController.m
//  CartoonWorld
//
//  Created by dundun on 2017/6/23.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "SubscriptionController.h"
#import "ComicController.h"

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
    //开始请求
    WeakSelf(self);
    self.view.userInteractionEnabled = NO;
    [[NetWorkingManager defualtManager] subscriptionWithPage:self.page success:^(id responseBody) {
        if (weakself.page == 1) {
            weakself.modelArr.array = responseBody[@"models"];
        } else {
            weakself.modelArr.array = [weakself.modelArr arrayByAddingObjectsFromArray:responseBody[@"models"]];
        }
        
        weakself.hasMore = [responseBody[@"hasMore"] boolValue];
        
        [weakself.tableView reloadData];
        [RefreshManager stopRefreshInView:weakself.tableView];
        weakself.view.userInteractionEnabled = YES;
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [RefreshManager stopRefreshInView:weakself.tableView];
        weakself.view.userInteractionEnabled = YES;
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
    ComicModel * comicModel = self.modelArr[indexPath.row];
    ComicController * comicController = [[ComicController alloc] init];
    comicController.comicId = comicModel.comicId;
    comicController.model = comicModel;
    comicController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:comicController animated:YES];
}

@end
