//
//  SearchTabelView.m
//  二次元境
//
//  Created by MS on 15/11/27.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "SearchTabelView.h"
#import "SearchTabelViewCell.h"
#import "SearchTabelViewModel.h"
#import "CartoonVC.h"

@interface SearchTabelView ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic ,assign) NSInteger page;
@property (nonatomic ,strong) NSMutableArray * dataArr;
@property (nonatomic ,strong) NSString * comicNum;
@property (nonatomic ,strong) UITableView * myTabelView;
@property (nonatomic ,strong) UITextField * textF;

@end

@implementation SearchTabelView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COLOR_BACK_WHITE;
    
    [self downloadData];

}

#pragma mark - tabBar相关
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //隐藏TabBar
    CGRect frame = self.tabBarController.tabBar.frame;
    if (frame.origin.y == SCREEN_HEIGHT - HEIGHT_OF_TABBAR) {
        frame.origin.y += HEIGHT_OF_TABBAR;
        [UIView animateWithDuration:0.3 animations:^{
            self.tabBarController.tabBar.frame = frame;
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //显示TabBar
    CGRect frame = self.tabBarController.tabBar.frame;
    if (frame.origin.y == SCREEN_HEIGHT) {
        frame.origin.y -= HEIGHT_OF_TABBAR;
        [UIView animateWithDuration:0.3 animations:^{
            self.tabBarController.tabBar.frame = frame;
        }];
    }
}

//创建数据源
- (void)downloadData
{
    
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }else  {
        [_dataArr removeAllObjects];
    }
   
    _page = 1;
    //添加活动指示器
    
    [[NetWorkingManager defualtManager] searchWithString:self.string page:self.page success:^(id responseBody) {
        self.dataArr.array = responseBody[@"array"];
        self.comicNum = responseBody[@"num"];
        [self createTabel];
        if (self.myTabelView) {
//            [self.myTabelView.mj_header endRefreshing];
        }
        //取消活动指示器
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        if (self.myTabelView) {
//            [self.myTabelView.mj_header endRefreshing];
        }
        //取消活动指示器
        
    }];
}

- (void)loadMoreData
{
    self.page ++;
    //添加活动指示器
    
    [[NetWorkingManager defualtManager] searchWithString:self.string page:self.page success:^(id responseBody) {
        if (0 == [responseBody[@"array"] count]) {
//            [self.myTabelView.mj_footer endRefreshing];
            //取消活动指示器
            
        }else {
            [responseBody[@"array"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.dataArr addObject:obj];
            }];
//            [self.myTabelView.mj_footer endRefreshing];
            //取消活动指示器
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
//        [self.myTabelView.mj_footer endRefreshing];
        //取消活动指示器
        
    }];
}

- (void)createTabel
{
    //添加搜索条
    UIView * searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
    searchView.backgroundColor = COLOR_PINK;
    searchView.tag = 233;
    _textF = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, SCREEN_WIDTH - 25 - 30, 44 - 14)];
    _textF.layer.cornerRadius = 15;
    _textF.layer.masksToBounds = YES;
    _textF.borderStyle = UITextBorderStyleRoundedRect;
    _textF.font = [UIFont systemFontOfSize:13];
    _textF.textColor = TEXT_COLOR;
    _textF.placeholder = @"好多精彩内容等着你哟~~O(∩_∩)O~~";
    _textF.text = _string;
    _textF.delegate = self;
    _textF.clearButtonMode = UITextFieldViewModeAlways;
    [_textF resignFirstResponder];
    
    UIButton * searButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 35, 10, 24, 24)];
    [searButton setBackgroundImage:[UIImage imageNamed:@"icnav_search_light"] forState:UIControlStateNormal];
    [searButton addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchView];
    [searchView addSubview:searButton];
    [searchView addSubview:_textF];
    
    _myTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 44, SCREEN_WIDTH, SCREEN_HEIGHT - 108) style:UITableViewStylePlain];
    _myTabelView.delegate = self;
    _myTabelView.dataSource = self;
    _myTabelView.backgroundColor = COLOR_BACK_WHITE;
    
    // 设置刷新header
//    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downloadData)];
//    header.automaticallyChangeAlpha = YES;
//    header.lastUpdatedTimeLabel.hidden = YES;
//    self.myTabelView.mj_header = header;
    
    // 设置上拉加载
//    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    footer.automaticallyChangeAlpha = YES;
//    self.myTabelView.mj_footer = footer;
    
    [_myTabelView registerClass:[SearchTabelViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_myTabelView];
}

- (void)searchButtonClicked:(UIButton *)button
{
    if (_textF.text.length == 0) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = @"输入的内容不能为空";
        hud.detailsLabelFont = [UIFont systemFontOfSize:13];
        hud.margin = 5.0f;
        hud.minShowTime = 2.0f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    }else {
        SearchTabelView * tabelView = [[SearchTabelView alloc] init];
        tabelView.string = _textF.text;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tabelView animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTabelViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    SearchTabelViewModel * model = _dataArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!headerView) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 10, 44)];
        label.backgroundColor = COLOR_BACK_WHITE;
        label.textColor = TEXT_COLOR;
        label.text = [NSString stringWithFormat:@"   搜索到与'%@'有关的漫画'%@'部哟O(∩_∩)O~~",_string,self.comicNum];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        [headerView addSubview:label];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_WIDTH/3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartoonVC * vc = [[CartoonVC alloc] init];
    vc.comicID = [_dataArr[indexPath.row] comic_id] ;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_textF.text.length == 0) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"输入内容不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * actionY = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [_textF resignFirstResponder];
        }];
        [alert addAction:actionY];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        SearchTabelView * tabelView = [[SearchTabelView alloc] init];
        tabelView.string = _textF.text;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tabelView animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    [_textF resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textF resignFirstResponder];
}


@end
