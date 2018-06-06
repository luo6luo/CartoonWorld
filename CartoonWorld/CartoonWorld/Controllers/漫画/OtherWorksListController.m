//
//  OtherWorksListController.m
//  CartoonWorld
//
//  Created by dundun on 2017/10/19.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "OtherWorksListController.h"

#import "ComicController.h"
#import "RecommendCell.h"

#import "OtherWorksModel.h"
#import "ComicModel.h"

static NSString *kRecommendCell = @"recommendCell";
@interface OtherWorksListController ()<UICollectionViewDelegateFlowLayout>


@end

@implementation OtherWorksListController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = COLOR_BACK_WHITE;
    
    self.collectionView.backgroundColor = COLOR_BACK_WHITE;
    self.collectionView.alwaysBounceVertical = YES;
    
    // 注册cell
    [self.collectionView registerClass:[RecommendCell class] forCellWithReuseIdentifier:kRecommendCell];
    
    // 判断是否有内容
    if (self.otherWorks.count <= 0) {
        [AlertManager showInfo:[NSString stringWithFormat:@"没有%@哟",self.title]];
    }
}

#pragma mark - Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.otherWorks.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendCell *otherWorkCell = [collectionView dequeueReusableCellWithReuseIdentifier:kRecommendCell forIndexPath:indexPath];
    otherWorkCell.cellType = VerticalCell;
    otherWorkCell.model = self.otherWorks[indexPath.row];
    return otherWorkCell;
}

# pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.otherWorks[indexPath.row];
    
    // 转换模拟数据
    ComicModel *comicModel = [ComicModel new];
    if ([model isKindOfClass:[OtherWorksModel class]]) {
        comicModel.comicId = [model comicId];
        comicModel.cover = [model coverUrl];
        comicModel.name = [model name];
        comicModel.cornerInfo = [NSString stringWithFormat:@"%ld",[model passChapterNum]];
    } else if ([model isKindOfClass:[ComicModel class]]) {
        comicModel = model;
    }
    
    ComicController *comicController = [[ComicController alloc] init];
    comicController.comicId = [model comicId];
    comicController.model = comicModel;
    comicController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:comicController animated:YES];
}

# pragma mark - Collection view delegate flow layout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return MIDDLE_SPASE;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return LEFT_RIGHT;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(TOP_BOTTOM, LEFT_RIGHT, TOP_BOTTOM, LEFT_RIGHT);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(VERTICAL_CELL_WIDTH, VERTICAL_CELL_HEIGHT);
}

@end
