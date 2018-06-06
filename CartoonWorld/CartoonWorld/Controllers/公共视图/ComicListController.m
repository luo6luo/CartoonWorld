//
//  MoreController.m
//  CartoonWorld
//
//  Created by dundun on 2017/8/16.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "ComicListController.h"
#import "ComicController.h"
#import "ComicListCell.h"
#import "ComicModel.h"

static NSString *kComicListCell = @"comicListCell";

@interface ComicListController()

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSString *promptInfo;
@property (nonatomic, assign) BOOL hasMore;

@end

@implementation ComicListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_BACK_WHITE;
    self.currentPage = 1;
    self.hasMore = NO;
    
    [self setupComicListView];
}

- (void)setupComicListView
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [RefreshManager pullDownRefreshInView:self.tableView targer:self action:@selector(loadComicData)];
    [RefreshManager pullUpRefreshInView:self.tableView targer:self action:@selector(loadMoreComicData)];
}

// 转换时间
- (NSString *)formatterDate:(NSInteger)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat  = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:date];
}

# pragma mark - Setter & Getter

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

# pragma mark - data

- (void)loadData
{
    self.view.userInteractionEnabled = NO;
    
    WeakSelf(self);
    [[NetWorkingManager defualtManager] moreComicWithPage:self.currentPage argCon:self.argCon argName:self.argName argValue:self.argValue success:^(id responseBody) {
        
        // 获取数据
        weakself.hasMore = [responseBody[@"hasMore"] boolValue];
        weakself.promptInfo = responseBody[@"promptInfo"];
        if (weakself.currentPage > 1) {
            [weakself.dataArr addObjectsFromArray:responseBody[@"data"]];
        } else {
            weakself.dataArr = responseBody[@"data"];
        }
        
        [weakself.tableView reloadData];
        [RefreshManager stopRefreshInView:weakself.tableView];
        
        if (weakself.dataArr.count == 0) {
            [AlertManager showInfo:@"没有相关数据"];
        }
        
        weakself.view.userInteractionEnabled = YES;
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [RefreshManager stopRefreshInView:weakself.tableView];
        [AlertManager showInfo:@"网络错误"];
        weakself.view.userInteractionEnabled = YES;
    }];
}

- (void)loadComicData
{
    self.currentPage = 1;
    [self.dataArr removeAllObjects];
    [self loadData];
}

- (void)loadMoreComicData
{
    if (self.hasMore) {
        self.currentPage++;
        [self loadData];
    } else {
        [AlertManager showInfo:@"没有更多数据了"];
    }
}

# pragma mark - Tabel view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComicListCell *comicListCell = [tableView dequeueReusableCellWithIdentifier:kComicListCell];
    if (!comicListCell) {
        comicListCell = [[ComicListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kComicListCell];
    }
    
    ComicModel *comicModel = self.dataArr[indexPath.row];
    comicListCell.comicModel = comicModel;
    
    // 提示信息
    if ([self.promptInfo containsString:@"时间"]) {
        comicListCell.promptInfoStr = [NSString stringWithFormat:@"%@：%@", self.promptInfo, [self formatterDate:comicModel.conTag]];
    } else {
        comicListCell.promptInfoStr = [NSString stringWithFormat:@"%@：%.2f万",self.promptInfo,(CGFloat)(comicModel.conTag / 10000.0)];;
    }
    
    return comicListCell;
}

# pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_CELL_MORECOMIC;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComicController *comicController = [[ComicController alloc] init];
    comicController.comicId = [self.dataArr[indexPath.row] comicId];
    comicController.model = self.dataArr[indexPath.row];
    comicController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:comicController animated:YES];
}

@end
