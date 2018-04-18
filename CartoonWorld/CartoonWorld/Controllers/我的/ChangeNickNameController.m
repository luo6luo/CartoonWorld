//
//  ChangeNickNameController.m
//  CartoonWorld
//
//  Created by dundun on 2017/11/29.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "ChangeNickNameController.h"
#import "InputContentCell.h"

static NSString * const kInputContentCell = @"inputContentCell";

@interface ChangeNickNameController ()

@property (nonatomic, strong) NSString *changedNickName;

@end

@implementation ChangeNickNameController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"昵称";
    self.view.backgroundColor = COLOR_BACK_WHITE;
    
    [self setupRightButton];
    [self setupTableView];
}

# pragma mark - Right button

- (void)setupRightButton
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishedChangeNickName)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)finishedChangeNickName
{
    if (self.changedNickName.length < 1) {
        [AlertManager showInfo:@"请输入新昵称"];
    } else {
        if (self.nickNameChangedBlock) {
            self.nickNameChangedBlock(self.changedNickName);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

# pragma mark - Set up table view

- (void)setupTableView
{
    self.tableView.backgroundColor = COLOR_BACK_WHITE;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"InputContentCell" bundle:nil] forCellReuseIdentifier:kInputContentCell];
}

# pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InputContentCell *cell = [tableView dequeueReusableCellWithIdentifier:kInputContentCell];
    cell.inputContent = self.changedNickName;
    cell.placeholder = @"请输入新昵称";
    
    WeakSelf(self);
    cell.changeInputBlock = ^(NSString *inputStr) {
        weakself.changedNickName = inputStr;
    };
    
    return cell;
}

# pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_CELL_INPUT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEIGHT_SECTION_MAX;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return HEIGHT_SECTION_MIN;
}

@end
