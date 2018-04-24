//
//  ComicDetailController.m
//  CartoonWorld
//
//  Created by dundun on 2017/7/7.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "ComicDetailController.h"
#import "ComicDetailModel.h"
#import "ComicDetailController.h"
#import "ComicController.h"
#import "OtherWorksListController.h"

#import "IntroductionCell.h"
#import "OtherWorksCell.h"
#import "MonthlyTicketCell.h"
#import "GuessLikeCell.h"

#import "ComicInfoModel.h"
#import "ComicDetailModel.h"
#import "GuessLikeModel.h"

static NSString *kIntroductionCell = @"introductionCell";
static NSString *kOtherWorkCell = @"otherWorkCell";
static NSString *kMonthlyTicketCell = @"monthlyTicketCell";
static NSString *kGuessLickCell = @"guessLikeCell";

@interface ComicDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL isGetDescription;
@property (nonatomic, assign) BOOL isGetMonthlyTicket;
@property (nonatomic, assign) BOOL isGetGuessLike;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ComicDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_BACK_WHITE;
    self.isGetDescription = NO;
    self.isGetMonthlyTicket = NO;
    self.isGetGuessLike = NO;
    
    [self setupDetailTableView];
}

- (void)setupDetailTableView
{
    CGRect tableViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -NAVIGATIONBAR_HEIGHT_V);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = COLOR_BACK_WHITE;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight =0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:self.tableView];
    
    // 注册cell
    [self.tableView registerClass:[IntroductionCell class] forCellReuseIdentifier:kIntroductionCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"OtherWorksCell" bundle:nil] forCellReuseIdentifier:kOtherWorkCell];
    [self.tableView registerClass:[MonthlyTicketCell class] forCellReuseIdentifier:kMonthlyTicketCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"GuessLikeCell" bundle:nil] forCellReuseIdentifier:kGuessLickCell];
}

# pragma mark - Setter

- (void)setDetailModel:(ComicDetailModel *)detailModel
{
    _detailModel = detailModel;
    self.isGetMonthlyTicket = YES;
    
    if (self.isGetDescription && self.isGetMonthlyTicket && self.isGetGuessLike) {
        [self.tableView reloadData];
    }
}

- (void)setComicInfoModel:(ComicInfoModel *)comicInfoModel
{
    _comicInfoModel = comicInfoModel;
    self.isGetDescription = YES;
    
    if (self.isGetDescription && self.isGetMonthlyTicket && self.isGetGuessLike) {
        [self.tableView reloadData];
    }
}

- (void)setGuessLikeModels:(NSArray *)guessLikeModels
{
    _guessLikeModels = guessLikeModels;
    self.isGetGuessLike = YES;
    
    if (self.isGetDescription && self.isGetMonthlyTicket && self.isGetGuessLike) {
        [self.tableView reloadData];
    }
}

# pragma mark - Block

- (void)imageViewClickedWithModel:(GuessLikeModel *)model
{
    // 漫画
    ComicController * comicController = [[ComicController alloc] init];
    comicController.comicId = model.comic_id;
    comicController.hidesBottomBarWhenPushed = YES;
    
    [self.rootController.navigationController pushViewController:comicController animated:YES];
}

# pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.otherWorkModels.count > 0 ? 4 : 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 作品介绍
        IntroductionCell *introductionCell = [tableView dequeueReusableCellWithIdentifier:kIntroductionCell forIndexPath:indexPath];
        introductionCell.contentStr = self.comicInfoModel.descriptionStr;
        return introductionCell;
    } else if (indexPath.section == 1) {
        // 其他作品
        OtherWorksCell *otherWorkCell = [tableView dequeueReusableCellWithIdentifier:kOtherWorkCell forIndexPath:indexPath];
        otherWorkCell.count = self.otherWorkModels.count;
        return otherWorkCell;
    } else if (indexPath.section == 2) {
        // 月票
        MonthlyTicketCell *ticketCell = [tableView dequeueReusableCellWithIdentifier:kMonthlyTicketCell forIndexPath:indexPath];
        ticketCell.detailModel = self.detailModel;
        return ticketCell;
    } else {
        // 猜你喜欢
        GuessLikeCell *guessLickCell = [tableView dequeueReusableCellWithIdentifier:kGuessLickCell forIndexPath:indexPath];
        guessLickCell.guesLikeModels = self.guessLikeModels;
        
        // 点击跳转作品
        WeakSelf(self);
        guessLickCell.firstImageClickedBlock = ^(GuessLikeModel *model) {
            [weakself imageViewClickedWithModel:model];
        };
        guessLickCell.secondImageClickedBlock = ^(GuessLikeModel *model) {
            [weakself imageViewClickedWithModel:model];
        };
        guessLickCell.thirdImageClickedBlock = ^(GuessLikeModel *model) {
            [weakself imageViewClickedWithModel:model];
        };
        guessLickCell.fourthImageClickedBlock = ^(GuessLikeModel *model) {
            [weakself imageViewClickedWithModel:model];
        };
        
        return guessLickCell;
    }
}

# pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CGSize textSize = [self.comicInfoModel.descriptionStr adaptiveSizeWithWidth:SCREEN_WIDTH - 2*LEFT_RIGHT height:MAXFLOAT fontSize:FONT_SUBTITLE];
        return 2*TOP_BOTTOM + LABEL_HEIGHT + MIDDLE_SPASE + textSize.height;
    } else if (indexPath.section == 1) {
        return self.otherWorkModels.count > 0 ? HEIGHT_CELL_OTHERWORK : 0;
    } else if (indexPath.section == 2) {
        return HEIGHT_CELL_MONTHLYTICKET;
    } else {
        return HEIGHT_CELL_GUESSLIKE;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return HEIGHT_SECTION_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return HEIGHT_SECTION_MIN;
    } else if (section == 2) {
        return self.otherWorkModels.count > 0 ? HEIGHT_SECTION_MAX : HEIGHT_SECTION_MIN;
    } else {
        return HEIGHT_SECTION_MAX;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && self.otherWorkModels.count > 0) {
        // 跳转其他作品集
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        OtherWorksListController *otherWorksListController = [[OtherWorksListController alloc] initWithCollectionViewLayout:layout];
        otherWorksListController.hidesBottomBarWhenPushed = YES;
        otherWorksListController.otherWorks = self.otherWorkModels;
        [self.rootController.navigationController pushViewController:otherWorksListController animated:YES];
    }
}

@end
