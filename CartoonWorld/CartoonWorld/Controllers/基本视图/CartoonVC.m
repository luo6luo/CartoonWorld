//
//  CartoonVC.m
//  二次元境
//
//  Created by MS on 15/11/25.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "CartoonVC.h"
#import "ReadVC.h"
#import "CartoonModel.h"
#import "ComicModel.h"
#import "ComicCell.h"

@interface CartoonVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) NSMutableArray * dataArr;
@property (nonatomic ,strong) ComicModel * comicModel;
@property (nonatomic ,strong) UITableView * listTabel;
@property (nonatomic ,assign) CGFloat detailViewHeight;
@property (nonatomic ,strong) NSString * myDescription;
@property (nonatomic ,strong) NSString * btnTitle;
@property (nonatomic ,assign) BOOL isShow;

@end

@implementation CartoonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"漫画详情";
    
    //默认收起详情
    self.isShow = NO;
    self.detailViewHeight = SCREEN_WIDTH/2 + 100;
    self.btnTitle = @"展";
    //下载数据
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

- (void)downloadData
{
    
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }else  {
        [_dataArr removeAllObjects];
    }

    //添加活动指示器

    //开始请求
//    [[NetWorkingManager defualtManager] cartoonWithcomicID:self.comicID success:^(id responseBody) {
//        self.dataArr.array = responseBody[@"chapter_list"];
//        self.comicModel = responseBody[@"comic"];
//        [self createTabelView];
//        //取消活动指示器
//
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//        //取消活动指示器
//
//    }];
}

//建表
- (void)createTabelView
{
    _listTabel = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _listTabel.delegate = self;
    _listTabel.dataSource = self;
    _listTabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_listTabel];
    
    //注册cell
    [_listTabel registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.listTabel registerClass:[ComicCell class] forCellReuseIdentifier:@"comicCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ComicCell * comicCell = [tableView dequeueReusableCellWithIdentifier:@"comicCell" forIndexPath:indexPath];
        [comicCell.button addTarget:self action:@selector(bookDetail:) forControlEvents:UIControlEventTouchUpInside];
        comicCell.backgroundColor = [UIColor whiteColor];
        comicCell.comicModel = self.comicModel;
        comicCell.myDescription = self.myDescription;
        comicCell.buttonTitle = self.btnTitle;
        comicCell.lookCartoonBlock = ^(){
            ReadVC * readVC = [[ReadVC alloc] init];
            readVC.chapter_id = [_dataArr[0] chapter_id];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:readVC animated:YES];
        };
        return comicCell;
    }else {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        CartoonModel * model = _dataArr[indexPath.row - 1];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = model.name;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        return self.detailViewHeight;
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (0 != indexPath.row) {
        CartoonModel * model = _dataArr[indexPath.row - 1];
        if (model.is_free) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = @"改章节已锁%>_<%";
            hud.detailsLabelFont = [UIFont systemFontOfSize:15];
            hud.margin = 5.0f;
            hud.minShowTime = 2.0f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
        }else {
            ReadVC * readVC = [[ReadVC alloc] init];
            readVC.chapter_id = model.chapter_id;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:readVC animated:YES];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        return NO;
    }
    return YES;
}

- (void)bookDetail:(UIButton *)button
{
    if (!self.isShow) {
//        CGSize size = [self.comicModel.myDescription sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(Screen_Size.width - 30 , MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
//        self.detailViewHeight = Screen_Size.width/2 + 100 + size.height;
//        self.myDescription = self.comicModel.description;
        self.btnTitle = @"卷";
        [self.listTabel reloadData];
        self.isShow = YES;
        
    }else if (self.isShow) {
        self.detailViewHeight = SCREEN_WIDTH/2 + 100;
        self.myDescription = nil;
        self.btnTitle = @"展";
        [self.listTabel reloadData];
        self.isShow = NO;
        
    }
}


@end
