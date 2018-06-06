//
//  ComicCommentController.m
//  CartoonWorld
//
//  Created by dundun on 2017/7/7.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "ComicCommentController.h"
#import "CommentCell.h"
#import "CommentModel.h"

static NSString *kCommentCell = @"commentCell";

@interface ComicCommentController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;        // 表格
@property (nonatomic, assign) NSInteger commentPage;         // 评论当前页数
@property (nonatomic, strong) NSMutableArray *commentModels; // 评论内容
@property (nonatomic, assign) BOOL hasMore;                  // 是否有更多

@end

@implementation ComicCommentController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_BACK_WHITE;
    self.commentModels = [NSMutableArray array];
    
    [self setupTabelView];
}

- (void)setupTabelView
{
    CGRect tableViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT_V + 44);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = COLOR_BACK_WHITE;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
        
    [self.view addSubview:self.tableView];
    
    // 添加上拉刷新
    [RefreshManager pullUpRefreshInView:self.tableView targer:self action:@selector(loadMoreCommentData)];
}

# pragma mark - Load data

// 加载评论类容
- (void)loadCommentData
{
    [ActivityManager showLoadingInView:self.view];
    
    // 加载评论
    WeakSelf(self);
    [[NetWorkingManager defualtManager] comicCommentWithComicID:self.comicId page:self.commentPage threadID:self.thread_id success:^(id responseBody) {
        weakself.hasMore = [responseBody[@"hasMore"] boolValue];
        if (self.commentPage == 1) {
            [weakself.commentModels removeAllObjects];
            weakself.commentModels = responseBody[@"models"];
        } else {
            [weakself.commentModels addObjectsFromArray:responseBody[@"models"]];
        }
        
        [weakself.tableView reloadData];
        [ActivityManager dismissLoadingInView:weakself.view status:ShowSuccess];
        [RefreshManager stopRefreshInView:weakself.tableView];
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        [ActivityManager dismissLoadingInView:weakself.view status:ShowFailure];
        [RefreshManager stopRefreshInView:weakself.tableView];
    }];
}

// 加载新的数据
- (void)loadNewCommentData
{
    self.commentPage = 1;
    [self.commentModels removeAllObjects];
    [self loadCommentData];
}

// 加载更多数据
- (void)loadMoreCommentData
{
    if (self.hasMore) {
        self.commentPage++;
        [self loadCommentData];
    } else {
        [RefreshManager stopRefreshInView:self.tableView];
        [AlertManager showInfo:@"没有更多了~"];
    }
}

# pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:kCommentCell];
    if (!commentCell) {
        commentCell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCommentCell];
        commentCell.commentModel = self.commentModels[indexPath.row];
    }
    return commentCell;
}

# pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel *model = self.commentModels[indexPath.row];
    CGFloat textWidth = SCREEN_WIDTH - 2*LEFT_RIGHT - ICON_HEIGHT - MIDDLE_SPASE;
    CGSize labelSize = [model.content_filter adaptiveSizeWithWidth:textWidth height:MAXFLOAT fontSize:FONT_SUBTITLE];
    return labelSize.height + 2*TOP_BOTTOM + 2*LABEL_HEIGHT;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

@end
