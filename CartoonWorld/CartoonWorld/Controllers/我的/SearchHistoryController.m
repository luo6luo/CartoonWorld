//
//  SearchHistoryController.m
//  CartoonWorld
//
//  Created by dundun on 2018/6/1.
//  Copyright © 2018年 顿顿. All rights reserved.
//

#import "SearchHistoryController.h"
#import "SearchResultController.h"

#import "SearchHistoryHeader.h"
#import "SearchHistoryCell.h"

#import "UserModel.h"
#import "StringObject.h"
#import "DatebaseManager.h"

#import "UIImageView+FindingView.h"

static NSString *const kHistoryHeader = @"historyHeader";
static NSString *const kHistoryNilHeader = @"nilHeader";
static NSString *const kHistoryCell = @"historyCell";

@interface SearchHistoryController ()

@property (nonatomic, strong) UIImageView *line; // 导航栏下的分割线
@property (nonatomic, strong) NSMutableArray *searchHistoryArr; // 搜索历史

@end

@implementation SearchHistoryController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = COLOR_BACK_WHITE;
    self.title = @"历史记录";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 隐藏导航栏下面的线条
    self.line.hidden = YES;
    
    [self setupData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 显示导航栏下面的线条
    self.line.hidden = NO;
}

# pragma mark - Getter

- (UIImageView *)line
{
    if (!_line) {
        _line = [UIImageView findingSeparationLineWithView:self.navigationController.navigationBar];
    }
    return _line;
}

// 设置数据
- (void)setupData
{
    self.searchHistoryArr = [NSMutableArray array];
    for (StringObject *string in [UserModel defaultUser].searchHistories) {
        [self.searchHistoryArr addObject:string.realmString];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchHistoryArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchHistoryCell *searchHistroyCell = [tableView dequeueReusableCellWithIdentifier:kHistoryCell];
    if (!searchHistroyCell) {
        searchHistroyCell = [[SearchHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHistoryCell];
        searchHistroyCell.type = ColorTypeLightBlue;
    }
    searchHistroyCell.text = self.searchHistoryArr[indexPath.row];
    return searchHistroyCell;
}

# pragma mark - Table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 搜索历史头
    SearchHistoryHeader *historyHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kHistoryHeader];
    if (!historyHeader) {
        historyHeader = [[SearchHistoryHeader alloc] initWithReuseIdentifier:kHistoryHeader];
        
        WeakSelf(self);
        historyHeader.deleteSearchHistoryBlock = ^{
            [weakself.searchHistoryArr removeAllObjects];
            [[DatebaseManager defaultDatebaseManager] deleteAllObjectCompleted:^{
                [weakself.tableView reloadData];
            }];
        };
    }
    return historyHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_CELL_SEARCH_HOT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEIGHT_HEADER_SEARCH_HISTORY;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return HEIGHT_SECTION_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击搜索历史
    SearchResultController *resultController = [[SearchResultController alloc] init];
    resultController.searchString = self.searchHistoryArr[indexPath.row];
    [self.navigationController pushViewController:resultController animated:YES];
}

@end
