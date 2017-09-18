//
//  BaseVC.m
//  二次元境
//
//  Created by MS on 15/11/22.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "ZEDChildController.h"
#import "BaseModel.h"
#import "BaseCell.h"

@interface ZEDChildController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic ,strong) UITableView * mytabelView; // 表格
@property (nonatomic ,strong) NSMutableArray * dataArr;  // 模型数据

@property (nonatomic ,strong) NSString * url;  // 网络请求链接
@property (nonatomic ,strong) NSString * type; // 页面类型

@end

@implementation ZEDChildController

- (instancetype)initWithType:(NSString *)type url:(NSString *)url
{
    if (self = [super init]) {
        self.type = type;
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BACK_WHITE;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [AlertManager dismissBackView];
}

//下载数据
- (void)downloadData {

    // 初始化数据源
    self.dataArr = [NSMutableArray array];
    
    //添加活动指示器
//    [AlertManager showLoadingToView:self.view];
    __weak typeof(self) weakSelf = self;
    [[NetWorkingManager defualtManager] zhongErWithURL:self.url success:^(id responseBody) {
        weakSelf.dataArr.array = responseBody;
        [weakSelf setupTabelView];
        //取消活动指示器
        [AlertManager dismissLoadingWithstatus:ShowSuccess];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [AlertManager dismissLoadingWithstatus:ShowFailure];
    }];
}

// 刷新数据
- (void)refreshDataSourch
{
    [self.dataArr removeAllObjects];
    
    __weak typeof(self) weakSelf = self;
    [[NetWorkingManager defualtManager] zhongErWithURL:self.url success:^(id responseBody) {
        weakSelf.dataArr.array = responseBody;
        [weakSelf.mytabelView reloadData];
//        [AlertManager dismissBackView];
//        [weakSelf.mytabelView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [weakSelf.mytabelView reloadData];
//        [AlertManager showRefreshFailureToView:self.view];
//        [weakSelf.mytabelView.mj_header endRefreshing];
    }];
}

- (void)setupTabelView {
    self.mytabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64) style:UITableViewStylePlain];
    self.mytabelView.backgroundColor = COLOR_BACK_WHITE;
    self.mytabelView.delegate = self;
    self.mytabelView.dataSource = self;
    self.mytabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mytabelView];
    
    //注册cell
    [self.mytabelView registerClass:[BaseCell class] forCellReuseIdentifier:@"cell"];
    
    // 刷新的动画图
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i < 5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_header_annimation_%d",i]];
        [images addObject:image];
    }
    
    // 设置刷新header
//    MJRefreshGifHeader * header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDataSourch)];
//    [header setImages:@[images.firstObject] forState:MJRefreshStateIdle];
//    [header setImages:@[images.firstObject] forState:MJRefreshStatePulling];
//    [header setImages:images forState:MJRefreshStateRefreshing];
//    header.automaticallyChangeAlpha = YES;
//    header.lastUpdatedTimeLabel.hidden = YES;
//    header.stateLabel.hidden = YES;
//    self.mytabelView.mj_header = header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    BaseModel * model = _dataArr[indexPath.row];
    cell.model = model;
    cell.type = self.type;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseModel * model = _dataArr[indexPath.row];
    return 5 + 30 + 20 + 5 + [self contentSize:model.content] + 5 + 1 + 5 + 20 + 5;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (CGFloat)contentSize:(NSString *)text {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:12],
                                  NSParagraphStyleAttributeName : paragraphStyle};
    CGSize contentSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes:attributes
                                                 context:nil].size;
    return contentSize.height;
}

@end
