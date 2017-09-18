//
//  BaseViewController.m
//  二次元境
//
//  Created by MS on 15/11/23.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseCollectionModel.h"
#import "BaseCollectionViewCell.h"
#import "ZBFlowView.h"
#import "ZBWaterView.h"
#import "ShowVC.h"
#import "BaseCollectionModel.h"

@interface BaseViewController ()<ZBWaterViewDatasource,ZBWaterViewDelegate,BaseCollectionViewCellDelegate>

@property (nonatomic ,strong) ZBWaterView * myWaterView;
@property (nonatomic ,strong) NSMutableArray * dataArr;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BACK_WHITE;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createWaterView];
}

//下载数据
- (void)downloadData
{
    
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }else  {
        [_dataArr removeAllObjects];
    }
    
    //添加活动指示器
    
    //开始请求
    [[NetWorkingManager defualtManager] drawWithURL:self.url success:^(id responseBody) {
        self.dataArr.array = responseBody;
        [self.myWaterView reloadData];
        if (self.myWaterView) {
//            [self.myWaterView.mj_header endRefreshing];
        }
        //取消活动指示器
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        if (self.myWaterView) {
//            [self.myWaterView.mj_header endRefreshing];
        }
        //取消活动指示器
        
    }];
}

- (void)createWaterView
{
    if (!self.myWaterView) {
        _myWaterView = [[ZBWaterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
        _myWaterView.waterDataSource = self;
        _myWaterView.waterDelegate = self;
        _myWaterView.isDataEnd = NO;
        self.myWaterView.backgroundColor = TEXT_COLOR;
        [self.view addSubview:_myWaterView];
        
        // 设置刷新header
//        MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downloadData)];
//        header.automaticallyChangeAlpha = YES;
//        header.lastUpdatedTimeLabel.hidden = YES;
//        self.myWaterView.mj_header = header;
    }
}

#pragma mark - 瀑布流代理

- (CGFloat)waterView:(ZBWaterView *)waterView heightOfFlowViewAtIndex:(NSInteger)index
{
    //    //宽:  10 + 30 + 10 + ((Screen_Size.width - 30)/2 - 60)
    //    //高: image_H + 10 + 30 + 10 + size_H + 10 + 1 + 5+20+5
    BaseCollectionModel * model = self.dataArr[index];
    return ([model.img[@"h"] floatValue]/[model.img[@"w"] floatValue]) * (SCREEN_WIDTH - 30)/2 + 10 + 30 + 10 + [self contentSize:model.introduce] + 10 + 1 + 30;

}

- (NSInteger)numberOfFlowViewInWaterView:(ZBWaterView *)waterView
{
    return _dataArr.count;
}

- (CustomWaterInfo *)infoOfWaterView:(ZBWaterView *)waterView
{
    CustomWaterInfo * info = [[CustomWaterInfo alloc] init];
    info.topMargin = 15;
    info.bottomMargin = 15;
    info.leftMargin = 10;
    info.rightMargin = 10;
    info.horizonPadding = 10;
    info.veticalPadding = 10;
    info.numOfColumn = 2;
    return info;
}

- (ZBFlowView *)waterView:(ZBWaterView *)waterView flowViewAtIndex:(NSInteger)index
{
    BaseCollectionViewCell * flowView = [waterView dequeueReusableCellWithIdentifier:@"cell"];
    if (!flowView) {
        flowView = [[BaseCollectionViewCell alloc] initWithFrame:CGRectZero];
        flowView.reuseIdentifier = @"cell";
    }
    BaseCollectionModel * model = _dataArr[index];
    flowView.index = index;
    flowView.model = model;
    flowView.delegate = self;
    return flowView;
}

- (void)makeImageToBigWithURL:(NSString *)url andWidth:(NSInteger)width andHeight:(NSInteger)height
{
    ShowVC * showVC = [[ShowVC alloc] init];
    showVC.url = url;
    showVC.width = width;
    showVC.height = height;
    [self presentViewController:showVC animated:YES completion:nil];
}

- (CGFloat)contentSize:(NSString *)text
{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
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
