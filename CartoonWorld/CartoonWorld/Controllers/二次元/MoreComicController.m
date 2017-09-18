//
//  MoreController.m
//  CartoonWorld
//
//  Created by dundun on 2017/8/16.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "MoreComicController.h"
#import "MoreComicCell.h"
#import "ComicModel.h"

static NSString *kMoreComicCell = @"moreComicCell";

@interface MoreComicController()

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSString *promptInfo;
@property (nonatomic, assign) NSInteger argCon;
@property (nonatomic, assign) BOOL hasMore;

@end

@implementation MoreComicController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_BACK_WHITE;
    self.currentPage = 1;
    self.argCon = 0;
    self.hasMore = NO;
    
    [self setupMoreComicView];
    [self loadComicData];
    
}

- (void)setupMoreComicView
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [RefreshManager pullDownRefreshInView:self.tableView targer:self action:@selector(loadComicData)];
    [RefreshManager pullUpRefreshInView:self.tableView targer:self action:@selector(loadMoreComicData)];
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

// 转换时间
- (NSString *)formatterDate:(NSInteger)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat  = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:date];
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
    MoreComicCell *moreComicCell = [tableView dequeueReusableCellWithIdentifier:kMoreComicCell];
    if (!moreComicCell) {
        moreComicCell = [[MoreComicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMoreComicCell];
    }
    
    ComicModel *comicModel = self.dataArr[indexPath.row];
    moreComicCell.comicModel = comicModel;
    if ([self.promptInfo containsString:@"时间"]) {
        moreComicCell.promptInfoStr = [NSString stringWithFormat:@"%@：%@", self.promptInfo, [self formatterDate:comicModel.conTag]];
    } else {
        moreComicCell.promptInfoStr = [NSString stringWithFormat:@"%@：%.2f万",self.promptInfo,(CGFloat)(comicModel.conTag / 10000.0)];;
    }
    
    return moreComicCell;
}

# pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_CELL_MORECOMIC;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
