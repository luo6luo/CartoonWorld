//
//  ComicCatalogController.m
//  CartoonWorld
//
//  Created by dundun on 2017/7/7.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "ComicCatalogController.h"
#import "CatalogCell.h"
#import "CatalogHeader.h"
#import "CatalogModel.h"

@interface ComicCatalogController ()<UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isPosiviteOrder; // 正序
@property (nonatomic, assign) CGFloat lastOffsetY;  // 上次y轴偏移量

@end

@implementation ComicCatalogController

static NSString * const kCatalogCell = @"catalogCell";
static NSString * const kCatalogHeader = @"catalogHeader";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BACK_WHITE;
    self.isPosiviteOrder = YES;
    self.lastOffsetY = 0;
    
    [self setupCollectionView];
}

- (void)setupCollectionView
{
    self.collectionView.bounces = YES;
    self.collectionView.backgroundColor = COLOR_BACK_WHITE;
    [self.collectionView registerNib:[UINib nibWithNibName:@"CatalogCell" bundle:nil] forCellWithReuseIdentifier:kCatalogCell];
    [self.collectionView registerClass:[CatalogHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCatalogHeader];
}

- (void)setMainViewIsUp:(BOOL)mainViewIsUp
{
    _mainViewIsUp = mainViewIsUp;
    
    self.collectionView.scrollEnabled = YES;
}

# pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CatalogCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCatalogCell forIndexPath:indexPath];
    if (self.isPosiviteOrder) {
        cell.catalogModel = self.dataArr[indexPath.row];
    } else {
        cell.catalogModel = self.dataArr[self.dataArr.count - indexPath.row - 1];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CatalogHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCatalogHeader forIndexPath:indexPath];
        header.model = self.dataArr.lastObject;
        
        WeakSelf(self);
        header.sortBtnBlock = ^(BOOL isPositiveOrder) {
            weakself.isPosiviteOrder = isPositiveOrder;
            [weakself.collectionView reloadData];
        };
        return header;
    }
    return nil;
}

# pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CatalogModel *model = nil;
    if (self.isPosiviteOrder) {
        model = self.dataArr[indexPath.row];
    } else {
        model = self.dataArr[self.dataArr.count - 1 - indexPath.row];
    }
}

# pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 3*LEFT_RIGHT)/2, HEIGHT_CELL_CATALOG);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.0, LEFT_RIGHT, TOP_BOTTOM, LEFT_RIGHT);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return TOP_BOTTOM;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return LEFT_RIGHT;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, HEIGHT_HEADER_CATALOG);
}

# pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView) {
        // 设置滑动方向
        CGFloat offsetY = scrollView.contentOffset.y;
        CatalogScrollDirection direciton = CatalogOther;
        if (self.lastOffsetY - offsetY > 0) {
            direciton = CatalogDown;
        } else if (self.lastOffsetY - offsetY < 0) {
            direciton = CatalogUp;
        } 
        
        if (self.mainViewIsUp) {
            if (direciton == CatalogDown && self.collectionView.contentOffset.y <= 0) {
                // 目录不动，整体视图下滑动
                if (self.catalogScrollBlock) {
                    self.collectionView.scrollEnabled = NO;
                    self.catalogScrollBlock(CatalogDown);
                }
            }
        } else if (!self.mainViewIsUp) {
            if (direciton == CatalogUp) {
                // 目录不动，整体视图上滑动
                if (self.catalogScrollBlock) {
                    self.collectionView.scrollEnabled = NO;
                    self.collectionView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
                    self.catalogScrollBlock(CatalogUp);
                }
            } else if (direciton == CatalogDown) {
                self.collectionView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
            }
        }
        
        self.lastOffsetY = scrollView.contentOffset.y;
    }
}

@end
