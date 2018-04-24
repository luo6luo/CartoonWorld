//
//  ComicCatalogController.m
//  CartoonWorld
//
//  Created by dundun on 2017/7/7.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "ComicCatalogController.h"
#import "ComicContentController.h"
#import "CatalogCell.h"
#import "CatalogHeader.h"
#import "CatalogModel.h"

@interface ComicCatalogController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) BOOL isPosiviteOrder; // 正序
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ComicCatalogController

static NSString * const kCatalogCell = @"catalogCell";
static NSString * const kCatalogHeader = @"catalogHeader";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BACK_WHITE;
    self.isPosiviteOrder = YES;
    
    [self setupCollectionView];
}

- (void)setupCollectionView
{
    CGRect collectionViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT_V);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = COLOR_BACK_WHITE;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.view addSubview:self.collectionView];
    
    // 注册
    [self.collectionView registerNib:[UINib nibWithNibName:@"CatalogCell" bundle:nil] forCellWithReuseIdentifier:kCatalogCell];
    [self.collectionView registerClass:[CatalogHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCatalogHeader];
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
    
    ComicContentController *controller = [[ComicContentController alloc] init];
    controller.title = model.name;
    controller.model = model;
    controller.hidesBottomBarWhenPushed = YES;
    [self.rootController.navigationController pushViewController:controller animated:YES];
}

# pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 3*LEFT_RIGHT)/2, HEIGHT_CELL_CATALOG);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.0, LEFT_RIGHT, 2*TOP_BOTTOM, LEFT_RIGHT);
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

@end
