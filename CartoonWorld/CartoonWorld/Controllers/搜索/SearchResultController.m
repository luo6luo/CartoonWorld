//
//  SearchResultController.m
//  CartoonWorld
//
//  Created by dundun on 2017/11/9.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "SearchResultController.h"
#import "ComicController.h"

#import "ComicListCell.h"
#import "SearchBarView.h"
#import "SearchResultHeader.h"

#import "ComicModel.h"

static NSString *kResultCell = @"resultCell";
static NSString *kResultHeader = @"resultHeader";

@interface SearchResultController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SearchBarView *searchBar;  // 搜索条
@property (nonatomic, strong) UITableView *tableView;    // 表格
@property (nonatomic, strong) NSMutableArray *resultArr; // 结果数组
@property (nonatomic, assign) BOOL hasMore;              // 更多
@property (nonatomic, assign) NSInteger currentPage;     // 当前页
@property (nonatomic, assign) NSInteger totalComic;      // 总共漫画数量

@end

@implementation SearchResultController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BACK_WHITE;
    self.title = @"搜索结果";
    
    self.resultArr = [NSMutableArray array];
    self.hasMore = NO;
    self.currentPage = 1;
    
    [self setupSubview];
    
    // 开始刷新，加载数据
    [RefreshManager Refreshing:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

# pragma mark - Set up

- (void)setupSubview
{
    // 搜索条
    self.searchBar = [[SearchBarView alloc] init];
    [self.view addSubview:self.searchBar];
    
    WeakSelf(self);
    self.searchBar.cancelBlock = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    
    self.searchBar.searchContentBlock = ^(NSString *content) {
        weakself.searchString = content;
        [weakself.tableView reloadData];
    };
    
    // 搜索列表
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.maxY, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT_V) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = COLOR_BACK_WHITE;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    // 刷新
    [RefreshManager pullDownRefreshInView:self.tableView targer:self action:@selector(loadNewData)];
    [RefreshManager pullUpRefreshInView:self.tableView targer:self action:@selector(loadMoreData)];
}

# pragma mark - Load data

- (void)loadNewData
{
    self.currentPage = 1;
    [self.resultArr removeAllObjects];
    [self loadSearchReultData];
}

- (void)loadMoreData
{
    if (self.hasMore) {
        self.currentPage++;
        [self loadSearchReultData];
    } else {
        [RefreshManager stopRefreshInView:self.tableView];
        self.view.userInteractionEnabled = YES;
    }
}

- (void)loadSearchReultData
{
    WeakSelf(self);
    self.view.userInteractionEnabled = NO;
    [[NetWorkingManager defualtManager] searchWithString:self.searchString page:self.currentPage success:^(id responseBody) {
        if (responseBody) {
            weakself.hasMore = [responseBody[@"hasMore"] boolValue];
            weakself.totalComic = [responseBody[@"comicNum"] integerValue];
            
            if (weakself.currentPage == 1) {
                weakself.resultArr = responseBody[@"comics"];
            } else {
                [weakself.resultArr arrayByAddingObjectsFromArray:responseBody[@"comics"]];
            }
        }
        
        [weakself.tableView reloadData];
        [RefreshManager stopRefreshInView:weakself.tableView];
        weakself.view.userInteractionEnabled = YES;
    } failure:^(NSError *error) {
        [RefreshManager stopRefreshInView:weakself.tableView];
        weakself.view.userInteractionEnabled = YES;
        NSLog(@"%@", error.localizedDescription);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComicListCell *resultCell = [tableView dequeueReusableCellWithIdentifier:kResultCell];
    if (!resultCell) {
        resultCell = [[ComicListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kResultCell];
    }
    ComicModel *model = self.resultArr[indexPath.row];
    resultCell.comicModel = model;
    resultCell.promptInfoStr = [NSString stringWithFormat:@"总点击：%0.2f万",model.conTag/10000.0];
    return resultCell;
}

# pragma mark - Table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SearchResultHeader *resultHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kResultHeader];
    if (!resultHeader) {
        resultHeader = [[SearchResultHeader alloc] initWithReuseIdentifier:kResultHeader];
    }
    resultHeader.totalComic = self.totalComic;
    return resultHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEIGHT_HEADER_SEARCH_RESULT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_CELL_MORECOMIC;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComicModel *model = self.resultArr[indexPath.row];
    ComicController *comicController = [[ComicController alloc] init];
    comicController.comicId = model.comicId;
    comicController.model = model;
    comicController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:comicController animated:YES];
}

@end
