//
//  SearchController.m
//  二次元境
//
//  Created by HecH on 15-11-18.
//  Copyright (c) 2015年 CK. All rights reserved.
//

#import "SearchController.h"
#import "ClassificationTopListDetailController.h"
#import "ComicListController.h"
#import "SearchHotController.h"

#import "ClassifitionSearchCell.h"

#import "ClassificationRankListModel.h"
#import "ClassificationTopListModel.h"

static NSString *kSearchCell = @"searchCll";

@interface SearchController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *classificationTopListArr;
@property (nonatomic, strong) NSArray *classificationRankListArr;

@end

@implementation SearchController

# pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BACK_WHITE;
    
    // 创建搜索条
    [self setupSearchBar];
    
    // 创建表格
    [self setupCollection];
    
    //创建数据源
    [self downloadData];
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

- (void)setupSearchBar
{
    // 搜索导航栏
    UIView *searchNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT_V)];
    searchNavigationBar.backgroundColor = COLOR_PINK;
    [self.view addSubview:searchNavigationBar];
    
    // 搜索条
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(LEFT_RIGHT, searchNavigationBar.minY + searchNavigationBar.height/2 + STATUSBAR_HEIGHT/2 - SEARCH_BAR_HEIGHT/2, SCREEN_WIDTH - 2*LEFT_RIGHT, SEARCH_BAR_HEIGHT);
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_CONTENT];
    searchBtn.backgroundColor = COLOR_WHITE;
    searchBtn.layer.cornerRadius = SEARCH_BAR_HEIGHT/2;
    searchBtn.layer.masksToBounds = YES;
    [searchBtn setTitle:@"精彩漫画O(∩_∩)O~~" forState:UIControlStateNormal];
    [searchBtn setTitleColor:COLOR_TEXT_GRAY forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
}

//创建collection
- (void)setupCollection
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT_V, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT_V - TABBAR_HEIGHT ) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = COLOR_BACK_WHITE;
    [self.view addSubview:self.collectionView];
    
    //注册cell
    [self.collectionView registerClass:[ClassifitionSearchCell class] forCellWithReuseIdentifier:kSearchCell];
}

# pragma mark - Response event

- (void)searchBtnClicked:(UIButton *)searchBtn
{
    // 跳转详细搜索界面
    SearchHotController *searchHotController = [[SearchHotController alloc] init];
    searchHotController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchHotController animated:YES];
}

# pragma mark - Data

//创建数据源
- (void)downloadData
{
    WeakSelf(self);
    [[NetWorkingManager defualtManager] searchClassificationSuccess:^(id responseBody) {
        weakself.classificationTopListArr = responseBody[@"topList"];
        weakself.classificationRankListArr = responseBody[@"rankingList"];
        [weakself.collectionView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
}

# pragma mark - Collection view data sourse

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.classificationTopListArr.count;
    } else {
        return self.classificationRankListArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClassifitionSearchCell *searCell = [collectionView dequeueReusableCellWithReuseIdentifier:kSearchCell forIndexPath:indexPath];
    if (indexPath.section == 0) {
        searCell.model = self.classificationTopListArr[indexPath.row];
    } else {
        searCell.model = self.classificationRankListArr[indexPath.row];
    }
    return searCell;
}

# pragma mark - Collection view delegate flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat kCellWidth = (SCREEN_WIDTH - 4*LEFT_RIGHT) / 3;
    if (indexPath.section == 0) {
        return CGSizeMake(kCellWidth, HEIGHT_CELL_TOPLIST);
    } else {
        return CGSizeMake(kCellWidth, HEIGHT_CELL_RANKLIST);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(TOP_BOTTOM, LEFT_RIGHT, TOP_BOTTOM, LEFT_RIGHT);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return LEFT_RIGHT;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return TOP_BOTTOM;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 独家，彩漫，完结
        ClassificationTopListModel *model = self.classificationTopListArr[indexPath.row];
        ClassificationTopListDetailController *topListDetailController = [[ClassificationTopListDetailController alloc] init];
        topListDetailController.tapList = model.extra[@"tabList"];
        topListDetailController.hidesBottomBarWhenPushed = YES;
        topListDetailController.title = model.sortName;
        [self.navigationController pushViewController:topListDetailController animated:YES];
    } else {
        // 其他分类
        ClassificationRankListModel *rankListModel = self.classificationRankListArr[indexPath.row];
        ComicListController *comicListController = [[ComicListController alloc] init];
        comicListController.argCon = 0;
        comicListController.title = rankListModel.sortName;
        comicListController.argName = rankListModel.argName;
        comicListController.argValue = rankListModel.argValue;
        comicListController.hidesBottomBarWhenPushed = YES;
        
        [RefreshManager Refreshing:comicListController.tableView];
        [self.navigationController pushViewController:comicListController animated:YES];
    }
}

@end
