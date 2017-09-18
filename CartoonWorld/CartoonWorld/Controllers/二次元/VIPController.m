//
//  VIPController.m
//  CartoonWorld
//
//  Created by dundun on 2017/6/19.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "VIPController.h"

#import "RecommendCell.h"
#import "TitleViewHeader.h"

#import "VIPTypeModel.h"
#import "ComicModel.h"

@interface VIPController ()

@property (nonatomic ,strong) NSArray *typeArr;

@end

@implementation VIPController

static NSString *const kVIPCell = @"vipCell";
static NSString *const kTitleHeader = @"titleHeader";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupViews];
}

# pragma mark - 下载数据

- (void)downloadData
{
    //添加活动指示器
    if (!self.isFinishedDownload) {
        [AlertManager showLoading];
    }
    
    //开始请求
    self.view.userInteractionEnabled = NO;
    [[NetWorkingManager defualtManager] VIPSuccess:^(id responseBody) {
        self.typeArr = responseBody;
        
        [self.collectionView reloadData];
        [RefreshManager stopRefreshInView:self.collectionView];
        [AlertManager dismissLoadingWithstatus:ShowSuccess];
        self.view.userInteractionEnabled = YES;
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [RefreshManager stopRefreshInView:self.collectionView];
        [AlertManager dismissLoadingWithstatus:ShowFailure];
        self.view.userInteractionEnabled = YES;
    }];
}

# pragma mark - collectionView

- (void)setupViews
{
    self.collectionView.backgroundColor = COLOR_BACK_WHITE;
    
    // 注册cell
    [self.collectionView registerClass:[RecommendCell class] forCellWithReuseIdentifier:kVIPCell];
    
    // 注册头视图
    [self.collectionView registerClass:[TitleViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kTitleHeader];
    
    // 设置刷新header
    [RefreshManager pullDownRefreshInView:self.collectionView targer:self action:@selector(downloadData)];
}

# pragma mark - collectionView data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.typeArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.typeArr) {
        return [self.typeArr[section] maxSize];
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendCell *vipCell = [collectionView dequeueReusableCellWithReuseIdentifier:kVIPCell
                                                                       forIndexPath:indexPath];
    VIPTypeModel *typeModel = self.typeArr[indexPath.section];
    vipCell.model = typeModel.comics[indexPath.row];
    vipCell.cellType = VIPCell;
    return vipCell;
}

//设置头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    TitleViewHeader * titleHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kTitleHeader forIndexPath:indexPath];
    if ([self.typeArr[indexPath.section] canMore]) {
        titleHeader.isShow = YES;
    } else {
        titleHeader.isShow = NO;
    }
    
    titleHeader.moreBtnClickedBlock = ^() {
        
    };
    titleHeader.typeModel = self.typeArr[indexPath.section];
    return titleHeader;
}

# pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //设置cell大小
    return CGSizeMake(VERTICAL_CELL_WIDTH, VERTICAL_CELL_HEIGHT - LABEL_HEIGHT);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    //设置cell与cell间竖直间最小距离
    return LEFT_RIGHT;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    // 设置每行间的最小水平间隔
    return TOP_BOTTOM;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    //设置边距
    if (section == collectionView.numberOfSections - 1) {
        return UIEdgeInsetsMake(0.0, LEFT_RIGHT, TOP_BOTTOM, LEFT_RIGHT);
    } else {
        return UIEdgeInsetsMake(0.0, LEFT_RIGHT, 0.0, LEFT_RIGHT);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, TITLE_HEADER_HEIGHT);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
