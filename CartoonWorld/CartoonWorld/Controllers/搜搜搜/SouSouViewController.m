//
//  SouSouViewController.m
//  二次元境
//
//  Created by HecH on 15-11-18.
//  Copyright (c) 2015年 CK. All rights reserved.
//

#import "SouSouViewController.h"
#import "SouSouCell.h"
//#import "DZRSearchController.h"
#import "SearchTVCell.h"
#import "SearchTabelView.h"
//#import "IntroductionVC.h"
#import "CartoonVC.h"
#import "HotSearchHeader.h"

@interface SouSouViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SearchTabelViewCellDelegate>

@property (nonatomic ,strong) UICollectionView * myCollectionView;
@property (nonatomic ,strong) NSMutableArray * dataArr;
@property (nonatomic ,strong) NSString * textFieldText;

@end

@implementation SouSouViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //创建数据源
    [self downloadData];
}

//创建数据源
- (void)downloadData
{
    
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }else  {
        [_dataArr removeAllObjects];
    }
    NSArray * imageArr = @[@[@"hd_homepage_thread_more_5",@"推荐"],
                           @[@"hd_homepage_thread_more_0",@"生活"],
                           @[@"hd_homepage_thread_more_2",@"科幻"],
                           @[@"hd_homepage_thread_more_8",@"动作"],
                           @[@"435590b0bd9c3591c435ed7578f1e6f3.jpeg",@"恋爱"],
                           @[@"hd_homepage_thread_more_3",@"搞笑"]];
    
    [_dataArr addObject:imageArr];
    [[NetWorkingManager defualtManager] hotSearchSuccess:^(id responseBody) {
        [self.dataArr addObject:responseBody];
        [self createCollection];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

//创建collection
- (void)createCollection
{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 ) collectionViewLayout:layout];
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    _myCollectionView.backgroundColor = COLOR_BACK_WHITE;
    [self.view addSubview:_myCollectionView];
    
    //注册cell
    [_myCollectionView registerClass:[SouSouCell class] forCellWithReuseIdentifier:@"cell"];
    [_myCollectionView registerClass:[SearchTVCell class] forCellWithReuseIdentifier:@"tabelCell"];
    //注册头视图
    [_myCollectionView registerClass:[HotSearchHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    [_myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"tabelHeader"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_dataArr[0] count];
    }else {
        return 1;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake((SCREEN_WIDTH - 80)/3, (SCREEN_WIDTH/3 - 80/3) * 4/3);
    }else {
        return CGSizeMake(SCREEN_WIDTH, 40 * [self.dataArr[1] count]);
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 44);
    }else {
        return CGSizeMake(SCREEN_WIDTH, 20);
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(20, 20, 20, 20);
    }
    return UIEdgeInsetsMake(20, 20, 20, 20);

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SouSouCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.model = self.dataArr[0][indexPath.row];
        return cell;
    }else {
        SearchTVCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tabelCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.array = self.dataArr[1];
        return cell;
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HotSearchHeader * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
        header.textFieldText = self.textFieldText;
        header.searchTextBlock = ^(NSString * inputcontent){
            self.textFieldText = inputcontent;
        };
        header.searchBtnBlock = ^(){
            if (self.textFieldText.length == 0) {
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
                tabelView.string = self.textFieldText;
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:tabelView animated:YES];
            }
        };
        return header;
    }else {
        UICollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"tabelHeader" forIndexPath:indexPath];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        label.textColor = TEXT_COLOR;
        label.text = @"     最近热搜";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        [header addSubview:label];
        return header;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        IntroductionVC * vc = [[IntroductionVC alloc] init];
//        switch (indexPath.row) {
//            case 0://推荐
//            {
//                vc.argName = @"theme";
//                vc.argValue = @"9";
//                vc.name = @"推荐";
//            }
//                break;
//            case 1://生活
//            {
//                vc.argName = @"theme";
//                vc.argValue = @"3";
//                vc.name = @"生活";
//            }
//                break;
//            case 2://科幻
//            {
//                vc.argName = @"theme";
//                vc.argValue = @"6";
//                vc.name = @"科幻";
//            }
//                break;
//            case 3://动作
//            {
//                vc.argName = @"theme";
//                vc.argValue = @"5";
//                vc.name = @"动作";
//            }
//                break;
//            case 4://恋爱
//            {
//                vc.argName = @"theme";
//                vc.argValue = @"4";
//                vc.name = @"恋爱";
//            }
//                break;
//            case 5://搞笑
//            {
//                vc.argName = @"theme";
//                vc.argValue = @"1";
//                vc.name = @"搞笑";
//            }
//                break;
//            default:
//                break;
//        }
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

- (void)cellWithText:(NSString *)searchStr
{
    self.textFieldText = searchStr;
    [self.myCollectionView reloadData];
    SearchTabelView * tabelView = [[SearchTabelView alloc] init];
    tabelView.string = self.textFieldText;
    [self.navigationController pushViewController:tabelView animated:YES];
}

@end
