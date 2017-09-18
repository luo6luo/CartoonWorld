//
//  MoreOtherController.m
//  CartoonWorld
//
//  Created by dundun on 2017/8/18.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "MoreOtherController.h"
#import "MoreOtherCell.h"
#import "MoreTopicModel.h"

static NSString *kMoreOtherCell = @"moreOtherCell";

@interface MoreOtherController ()

@property (nonatomic, assign) NSInteger argCon;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation MoreOtherController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_BACK_WHITE;
    self.currentPage = 1;
    self.hasMore = NO;
    
    [self setupTableView];
    [self loadMoreOtherData];
}

- (void)setupTableView
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [RefreshManager pullDownRefreshInView:self.tableView targer:self action:@selector(loadMoreOtherData)];
    [RefreshManager pullUpRefreshInView:self.tableView targer:self action:@selector(loadMoreOtherMoreData)];
}

# pragma mark - Getter & Setter

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)setMoreType:(MoreType)moreType
{
    _moreType = moreType;
    
    if (moreType == Topic) {
        self.argCon = 1;
    } else {
        self.argCon = 0;
    }
}

# pragma mark - Data

// 加载数据
- (void)loadMoreOtherData
{
    self.currentPage = 1;
    [self.dataArr removeAllObjects];
    
    if (self.moreType == Topic) {
        // 专题
        [self loadTopicData];
    } else if (self.moreType == DayComic) {
        // 条漫每日更新
        [self loadDayComicData];
    }
}

// 加载更多
- (void)loadMoreOtherMoreData
{
    self.currentPage++;
    
    if (self.moreType == Topic) {
        // 专题
        [self loadTopicData];
    } else if (self.moreType == DayComic) {
        // 条漫每日更新
        [self loadDayComicData];
    }
}

// 加载每日条漫
- (void)loadDayComicData
{
    self.view.userInteractionEnabled = NO;
    
    WeakSelf(self);
    [[NetWorkingManager defualtManager] moreComicWithPage:self.currentPage argCon:self.argCon argName:self.argName argValue:self.argValue success:^(id responseBody) {
        
        // 获取数据
        weakself.hasMore = [responseBody[@"hasMore"] boolValue];
        if (weakself.currentPage > 1) {
            [weakself.dataArr addObjectsFromArray:responseBody[@"data"]];
        } else {
            weakself.dataArr = responseBody[@"data"];
        }
        
        [weakself.tableView reloadData];
        [RefreshManager stopRefreshInView:weakself.tableView];
        weakself.view.userInteractionEnabled = YES;
        
        if (weakself.dataArr.count == 0) {
            [AlertManager showInfo:@"没有相关数据"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [RefreshManager stopRefreshInView:weakself.tableView];
        [AlertManager showInfo:@"网络错误"];
        weakself.view.userInteractionEnabled = YES;
    }];
}

// 加载专题
- (void)loadTopicData
{
    self.view.userInteractionEnabled = NO;
    WeakSelf(self);
    [[NetWorkingManager defualtManager] moreTopicWithArgCon:self.argCon page:self.currentPage success:^(id responseBody) {
        
        // 获取数据
        if (weakself.currentPage == 1) {
            weakself.dataArr = responseBody[@"models"];
        } else {
            [weakself.dataArr addObjectsFromArray:responseBody[@"models"]];
        }
        weakself.currentPage = [responseBody[@"page"] integerValue];
        weakself.hasMore = [responseBody[@"hasMore"] boolValue];
        
        [weakself.tableView reloadData];
        [RefreshManager stopRefreshInView:weakself.tableView];
        weakself.view.userInteractionEnabled = YES;
        
        if (weakself.dataArr.count == 0) {
            [AlertManager showInfo:@"没有相关数据"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [AlertManager showInfo:@"网络错误"];
        weakself.view.userInteractionEnabled = YES;
        [RefreshManager stopRefreshInView:weakself.tableView];
    }];
}

# pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreOtherCell *moreOtherCell = [tableView dequeueReusableCellWithIdentifier:kMoreOtherCell];
    if (!moreOtherCell) {
        moreOtherCell = [[MoreOtherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMoreOtherCell];
    }
    
    moreOtherCell.moreOtherModel = self.dataArr[indexPath.section];
    return moreOtherCell;
}

# pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.moreType == Topic) {
        return HEIGHT_CELL_MOREOTHER;
    } else {
        return HEIGHT_CELL_MOREOTHER - LABEL_HEIGHT;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEIGHT_SECTION_MAX;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return HEIGHT_SECTION_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
