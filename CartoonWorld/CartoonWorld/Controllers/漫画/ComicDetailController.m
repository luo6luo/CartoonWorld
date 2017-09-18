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

#import "IntroductionCell.h"
#import "MonthlyTicketCell.h"
#import "GuessLikeCell.h"

#import "ComicInfoModel.h"
#import "ComicDetailModel.h"
#import "GuessLikeModel.h"

static NSString *kIntroductionCell = @"introductionCell";
static NSString *kMonthlyTicketCell = @"monthlyTicketCell";
static NSString *kGuessLickCell = @"guessLikeCell";

@interface ComicDetailController ()<UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isGetDescription;
@property (nonatomic, assign) BOOL isGetMonthlyTicket;
@property (nonatomic, assign) BOOL isGetGuessLike;

@end

@implementation ComicDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_BACK_GRAY;
    self.isGetDescription = NO;
    self.isGetMonthlyTicket = NO;
    self.isGetGuessLike = NO;
    
    [self setupDetailTableView];
}

- (void)setupDetailTableView
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerClass:[IntroductionCell class] forCellReuseIdentifier:kIntroductionCell];
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
    [self.navigationController pushViewController:comicController animated:YES];
}

# pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        IntroductionCell *introductionCell = [tableView dequeueReusableCellWithIdentifier:kIntroductionCell forIndexPath:indexPath];
        introductionCell.contentStr = self.comicInfoModel.descriptionStr;
        return introductionCell;
    } else if (indexPath.section == 1) {
        MonthlyTicketCell *ticketCell = [tableView dequeueReusableCellWithIdentifier:kMonthlyTicketCell forIndexPath:indexPath];
        ticketCell.detailModel = self.detailModel;
        return ticketCell;
    } else {
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
        CGSize textSize = [self.comicInfoModel.descriptionStr adaptiveSizeWithWidth:SCREEN_WIDTH - 2*LEFT_RIGHT height:MAXFLOAT fontSize:FONT_CONTENT];
        return 2*TOP_BOTTOM + MIDDLE_SPASE + textSize.height;
    } else if (indexPath.section == 1) {
        return HEIGHT_CELL_MONTHLYTICKET;
    } else {
        return HEIGHT_CELL_GUESSLIKE;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return HEIGHT_SECTION_MIN;
    } else {
        return HEIGHT_SECTION_MAX;
    }
}

# pragma mark - Scroll view delegate

@end
