//
//  RecommendVC.m
//  二次元境
//
//  Created by MS on 15/11/19.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "RecommendController.h"
#import "WebController.h"
#import "ComicController.h"
#import "MoreComicController.h"
#import "MoreOtherController.h"

#import "RecommendCell.h"
#import "RecommendRankCell.h"
#import "TitleViewHeader.h"
#import "BannerHeader.h"

#import "advertisementModel.h"
#import "RecommendTypeModel.h"
#import "ComicModel.h"

@interface RecommendController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong) NSArray *adArr;
@property (nonatomic ,strong) NSArray *typeArr;

@end

static NSString *const kScrollViewCell = @"scrollViewCell";
static NSString *const kOtherCell = @"otherCell";
static NSString *const kHorizontalCell = @"horizontalCell";
static NSString *const kVerticalCell = @"verticalCell";
static NSString *const kBannerHeader = @"bannerHeader";
static NSString *const kTitleHeader = @"titleHeader";

@implementation RecommendController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupViews];
}

# pragma mark - Getter



# pragma mark - 下载数据

- (void)downloadData
{
    self.view.userInteractionEnabled = NO;
    
    //开始请求
    WeakSelf(self);
    [[NetWorkingManager defualtManager] recommendSuccess:^(id responseBody) {
        weakself.adArr = responseBody[@"banners"];
        weakself.typeArr = responseBody[@"types"];
        
        [weakself.collectionView reloadData];
        [RefreshManager stopRefreshInView:weakself.collectionView];
        weakself.view.userInteractionEnabled = YES;
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [RefreshManager stopRefreshInView:weakself.collectionView];
        [AlertManager showInfo:@"网络错误"];
        weakself.view.userInteractionEnabled = YES;
    }];
}

# pragma mark - collectionView

- (void)setupViews
{
    self.collectionView.backgroundColor = COLOR_BACK_WHITE;
    
    // 注册cell
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kScrollViewCell];
    [self.collectionView registerClass:[RecommendCell class] forCellWithReuseIdentifier:kOtherCell];
    [self.collectionView registerClass:[RecommendCell class] forCellWithReuseIdentifier:kHorizontalCell];
    [self.collectionView registerClass:[RecommendCell class] forCellWithReuseIdentifier:kVerticalCell];
    
    // 注册头视图
    [self.collectionView registerClass:[BannerHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kBannerHeader];
    [self.collectionView registerClass:[TitleViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kTitleHeader];
    
    // 设置刷新header
    [RefreshManager pullDownRefreshInView:self.collectionView targer:self action:@selector(downloadData)];
}

# pragma mark - Resonse event

// 点击广告头
- (void)bannerClickedWithModel:(AdvertisementModel *)adModel
{
    WeakSelf(self);
    if (adModel.linkType == 2) {
        // 网页
        [adModel.ext enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = (NSDictionary *)obj;
            if ([dic[@"key"] isEqualToString:@"url"]) {
                WebController *webController = [[WebController alloc] init];
                webController.urlString = obj[@"val"];
                [webController startRequest];
                webController.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:webController animated:YES];
                *stop = YES;
            }
        }];
    } else {
        // 漫画
        [adModel.ext enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = (NSDictionary *)obj;
            if ([dic[@"key"] isEqualToString:@"comicId"]) {
                ComicController * comicController = [[ComicController alloc] init];
                comicController.comicId = [obj[@"val"] integerValue];
                comicController.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:comicController animated:YES];
                *stop = YES;
            }
        }];
    }
}

// 点击更多按钮
- (void)moreComicWithModel:(RecommendTypeModel *)model
{
    if (model.comicType == 3) {
        // 条漫每日更多
        MoreOtherController *dayComicController = [[MoreOtherController alloc] init];
        dayComicController.argName = model.argName;
        dayComicController.argValue = model.argValue;
        dayComicController.moreType = DayComic;
        dayComicController.title = model.itemTitle;
        dayComicController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dayComicController animated:YES];
    } else if (model.comicType == 5) {
        // 专题
        MoreOtherController *topicController = [[MoreOtherController alloc] init];
        topicController.moreType = Topic;
        topicController.title = model.itemTitle;
        topicController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:topicController animated:YES];
    } else if (model.comicType == 9) {
        // 最新动画
        WebController *webController = [[WebController alloc] init];
        webController.urlString = Cartoon_URL;
        [webController startRequest];
        webController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webController animated:YES];
    } else {
        // 其他
        MoreComicController *moreComicController = [[MoreComicController alloc] init];
        moreComicController.argName = model.argName;
        moreComicController.argValue = model.argValue;
        moreComicController.title = model.itemTitle;
        moreComicController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:moreComicController animated:YES];
    }
}

# pragma mark - collectionView data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.typeArr.count + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    RecommendTypeModel *typeModel = nil;
    if (section != 0) {
        typeModel = self.typeArr[section - 1];
    }

    if (section == 0) {
        return 0;
    } else if (section == 1) {
        return 6;
    } else if (typeModel.comicType == 5 || typeModel.comicType == 9) {
        // 网站
        return 2;
    } else if (typeModel.comicType == 3) {
        // 条漫每日更新
        return 2;
    } else {
        return 3;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendTypeModel *model = nil;
    if (indexPath.section != 0) {
        model = self.typeArr[indexPath.section - 1];
    }
    
    if (indexPath.section == 0) {
        // 广告cell
        UICollectionViewCell * adCell = [collectionView dequeueReusableCellWithReuseIdentifier:kScrollViewCell
                                                                                  forIndexPath:indexPath];
        return adCell;
    } else if (model.comicType == 3 || model.comicType == 9) {
        // 漫画（横着cell，条漫每日）
        // 网页类型(水平cell，每日动漫)
        RecommendCell *comicHCell = [collectionView dequeueReusableCellWithReuseIdentifier:kHorizontalCell
                                                                             forIndexPath:indexPath];
        RecommendTypeModel *typeModel = self.typeArr[indexPath.section - 1];
        comicHCell.model = typeModel.comics[indexPath.row];
        comicHCell.cellType = HorizontalCell;
        return comicHCell;
    } else if (model.comicType == 5) {
        // 网页类型(水平cell，无描述，专题)
        RecommendCell * horizontalCell = [collectionView dequeueReusableCellWithReuseIdentifier:kOtherCell
                                                                                   forIndexPath:indexPath];
        RecommendTypeModel *typeModel = self.typeArr[indexPath.section - 1];
        horizontalCell.model = typeModel.comics[indexPath.row];
        horizontalCell.cellType = OtherCell;
        return horizontalCell;
    } else {
        // 漫画（竖直cell）
        RecommendCell *comicVCell = [collectionView dequeueReusableCellWithReuseIdentifier:kVerticalCell
                                                                             forIndexPath:indexPath];
        RecommendTypeModel *typeModel = self.typeArr[indexPath.section - 1];
        comicVCell.model = typeModel.comics[indexPath.row];
        comicVCell.cellType = VerticalCell;
        return comicVCell;
    }
}


//设置头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf(self);
    if (indexPath.section == 0) {
        BannerHeader * bannerHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                         withReuseIdentifier:kBannerHeader
                                                                                forIndexPath:indexPath];
        bannerHeader.selectedAdBlock = ^(AdvertisementModel *adModel) {
            [weakself bannerClickedWithModel:adModel];
        };
        bannerHeader.adModels = self.adArr;
        return bannerHeader;
    } else {
        TitleViewHeader * titleHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                           withReuseIdentifier:kTitleHeader
                                                                                  forIndexPath:indexPath];
        titleHeader.isShow = YES;
        titleHeader.moreBtnClickedBlock = ^() {
            // 点击更多
            [weakself moreComicWithModel:weakself.typeArr[indexPath.section - 1]];
        };
        titleHeader.typeModel = self.typeArr[indexPath.section - 1];
        return titleHeader;
    }
}

# pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //设置cell大小
    RecommendTypeModel *model = nil;
    if (indexPath.section != 0) {
        model = self.typeArr[indexPath.section - 1];
    }
    
    if (indexPath.section == 0) {
        return CGSizeMake(0, 0);
    } else if (model.comicType == 5) {
        // 专题
        return CGSizeMake(HORIZONTAL_CELL_WIDTH, HORIZONTAL_CELL_HEIGHT - 2*LABEL_HEIGHT);
    } else if (model.comicType == 3 || model.comicType == 9) {
        // 条漫每日，动漫
        return CGSizeMake(HORIZONTAL_CELL_WIDTH, HORIZONTAL_CELL_HEIGHT);
    } else {
        return CGSizeMake(VERTICAL_CELL_WIDTH, VERTICAL_CELL_HEIGHT);
    }
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
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, AD_HEADER_HEIGHT);
    } else {
        return CGSizeMake(SCREEN_WIDTH, TITLE_HEADER_HEIGHT);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 0) {
        
        RecommendTypeModel *typeModel = self.typeArr[indexPath.section - 1];
        if (typeModel.comicType == 5 || typeModel.comicType == 9) {
            // 专题，动漫（网页）
            AdvertisementModel *webModel = typeModel.comics[indexPath.row];
            WeakSelf(self);
            [webModel.ext enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = (NSDictionary *)obj;
                if ([dic[@"key"] isEqualToString:@"url"]) {
                    WebController *webController = [[WebController alloc] init];
                    webController.urlString = obj[@"val"];
                    [webController startRequest];
                    webController.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:webController animated:YES];
                    *stop = YES;
                }
            }];
        } else {
            // 其他（漫画）
            ComicModel * comicModel = typeModel.comics[indexPath.row];
            ComicController * comicController = [[ComicController alloc] init];
            comicController.comicId = comicModel.comicId;
            comicController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:comicController animated:YES];
        }
    }
}

@end
