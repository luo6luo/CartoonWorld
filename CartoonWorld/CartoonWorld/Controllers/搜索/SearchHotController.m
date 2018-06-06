//
//  SearchHotController.m
//  CartoonWorld
//
//  Created by dundun on 2017/11/6.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "SearchHotController.h"
#import "SearchResultController.h"
#import "ComicController.h"

#import "SearchBarView.h"
#import "SearchHotHeader.h"
#import "SearchHistoryHeader.h"
#import "SearchHotCell.h"
#import "SearchHistoryCell.h"

#import "SearchHotModel.h"
#import "UserModel.h"
#import "StringObject.h"

#import "DatebaseManager.h"

static NSString *kSearchHotCell = @"searchHotCell";
static NSString *kSearchHistoryCell = @"searchHistoryCell";
static NSString *kSearchHotHeader = @"searchHotHeader";
static NSString *kSearchHistoryHeader = @"searchHistryHeader";

@interface SearchHotController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SearchBarView *searchBar; // 搜索条
@property (nonatomic, strong) UITableView *searchList;  // 搜索表格
@property (nonatomic, strong) NSString *searchString;   // 搜索关键词
@property (nonatomic, strong) NSArray *searchHotArr;    // 热搜
@property (nonatomic, strong) NSMutableArray *searchHistoryArr; // 搜索历史

@end

@implementation SearchHotController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_WHITE;
    
    self.searchHistoryArr = [NSMutableArray array];
    for (StringObject *string in [UserModel defaultUser].searchHistories) {
        [self.searchHistoryArr addObject:string.realmString];
    }
    
    [self setupSubviews];
    [self loadSearchHotData];
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

# pragma mark - Setter & Getter

- (SearchBarView *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[SearchBarView alloc] init];
        WeakSelf(self);
        // 获取搜索名字
        _searchBar.searchContentBlock = ^(NSString *content) {
            weakself.searchString = content;
            
            // 储存搜索历史
            UserModel *user = [UserModel defaultUser];
            StringObject *string = [StringObject new];
            string.realmString = weakself.searchString;
            [[DatebaseManager defaultDatebaseManager] modifyObject:^{
                [user.searchHistories addObject:string];
            } completed:^{
                // 刷新搜索历史
                [weakself.searchHistoryArr addObject:content];
                [weakself.searchList reloadData];
            }];
            
            // 跳转搜索结果
            SearchResultController *searchResultController = [[SearchResultController alloc] init];
            searchResultController.searchString = content;
            [weakself.navigationController pushViewController:searchResultController animated:YES];
        };
        
        // 取消
        _searchBar.cancelBlock = ^{
            [weakself.navigationController popViewControllerAnimated:YES];
        };
    }
    
    return _searchBar;
}

# pragma mark - Set up

- (void)setupSubviews
{
    // 搜索条
    [self.view addSubview:self.searchBar];
    
    // 热门列表
    self.searchList = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                    NAVIGATIONBAR_HEIGHT_V,
                                                                    SCREEN_WIDTH,
                                                                    SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT_V)
                                                   style:UITableViewStyleGrouped];
    self.searchList.delegate = self;
    self.searchList.dataSource = self;
    self.searchList.bounces = NO;
    self.searchList.backgroundColor = COLOR_WHITE;
    self.searchList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.searchList];
}

# pragma mark - Data

- (void)loadSearchHotData
{
    WeakSelf(self);
    [ActivityManager showLoadingInView:self.view];
    [[NetWorkingManager defualtManager] hotSearchSuccess:^(id responseBody) {
        weakself.searchHotArr = responseBody;
        [weakself.searchList reloadData];
        [ActivityManager dismissLoadingInView:self.view status:ShowSuccess];
    } failure:^(NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        [ActivityManager dismissLoadingInView:self.view status:ShowFailure];
    }];
}

# pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.searchHistoryArr.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 搜索历史
        SearchHistoryCell *searchHistroyCell = [tableView dequeueReusableCellWithIdentifier:kSearchHistoryCell];
        if (!searchHistroyCell) {
            searchHistroyCell = [[SearchHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSearchHistoryCell];
        }
        searchHistroyCell.text = self.searchHistoryArr[indexPath.row];
        return searchHistroyCell;
    } else {
        // 搜索热门
        SearchHotCell *searchHotCell = [tableView dequeueReusableCellWithIdentifier:kSearchHotCell];
        if (!searchHotCell) {
            searchHotCell = [[SearchHotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSearchHotCell];
            
            WeakSelf(self);
            searchHotCell.tagBtnClickedBlock = ^(SearchHotModel *model) {
                // 存入数据库
                [[DatebaseManager defaultDatebaseManager] modifyObject:^{
                    StringObject *realmString = [StringObject new];
                    realmString.realmString = model.tagName;
                    [[UserModel defaultUser].searchHistories addObject:realmString];
                } completed:^{
                    // 刷新搜索历史列表
                    [weakself.searchHistoryArr addObject:model.tagName];
                    [weakself.searchList reloadData];
                }];
                
                ComicController *comicController = [[ComicController alloc] init];
                comicController.comicId = model.search_num;
                [weakself.navigationController pushViewController:comicController animated:YES];
            };
        }
        searchHotCell.hotArr = self.searchHotArr;
        return searchHotCell;
    }
}

# pragma mark - Table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        // 搜索历史头
        SearchHistoryHeader *historyHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSearchHistoryHeader];
        if (!historyHeader) {
            historyHeader = [[SearchHistoryHeader alloc] initWithReuseIdentifier:kSearchHistoryHeader];
            
            WeakSelf(self);
            historyHeader.deleteSearchHistoryBlock = ^{
                [weakself.searchHistoryArr removeAllObjects];
                [[DatebaseManager defaultDatebaseManager] deleteAllObjectCompleted:^{
                    [weakself.searchList reloadData];
                }];
            };
        }
        return historyHeader;
    } else {
        // 搜索热门头
        SearchHotHeader *hotHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSearchHotHeader];
        if (!hotHeader) {
            hotHeader = [[SearchHotHeader alloc] initWithReuseIdentifier:kSearchHotHeader];
        }
        return hotHeader;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return HEIGHT_CELL_SEARCH_HOT;
    } else {
        return [self searchHotHeaderHeight];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return HEIGHT_HEADER_SEARCH_HISTORY;
    } else {
        return HEIGHT_HEADER_SEARCH_HOT;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return HEIGHT_SECTION_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 点击搜索历史
        SearchResultController *resultController = [[SearchResultController alloc] init];
        resultController.searchString = self.searchHistoryArr[indexPath.row];
        [self.navigationController pushViewController:resultController animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return YES;
    } else {
        return NO;
    }
}

# pragma mark - Other

- (CGFloat )searchHotHeaderHeight
{
    NSInteger row = 0;
    CGFloat totalX = LEFT_RIGHT;
    CGFloat totalY = 0.0;
    
    for (int i = 0; i < self.searchHotArr.count; i++) {
        SearchHotModel *model = self.searchHotArr[i];
        CGSize titleSize = [model.tagName adaptiveSizeWithWidth:MAXFLOAT height:TAG_BUTTON_HEIGHT fontSize:FONT_CONTENT];
        
        // 设置x位置
        if (totalX == LEFT_RIGHT) {
            // 每行中第一个
            totalX = LEFT_RIGHT;
        } else {
            CGFloat curruntX = totalX + 2*MIDDLE_SPASE + titleSize.width + 10;
            if (curruntX > SCREEN_WIDTH - LEFT_RIGHT) {
                // 当前X位置大于能显示的位置，换行
                row++;
                totalX = LEFT_RIGHT;
            } else {
                totalX += 2*MIDDLE_SPASE;
            }
        }
        totalX += (titleSize.width + 10);
        
        // 设置y位置
        if (row == 0) {
            totalY = TOP_BOTTOM;
        } else {
            totalY = TOP_BOTTOM +  row * (TAG_BUTTON_HEIGHT + 2*MIDDLE_SPASE);
        }
    }
    return totalY + TOP_BOTTOM + TAG_BUTTON_HEIGHT + 2*MIDDLE_SPASE;
}

@end
