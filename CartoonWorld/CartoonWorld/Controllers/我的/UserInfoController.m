//
//  UserInfoController.m
//  CartoonWorld
//
//  Created by dundun on 2017/11/20.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "UserInfoController.h"
#import "ChangeDetailController.h"
#import "ChangeNickNameController.h"

#import "UserRelatedCell.h"
#import "UserModel.h"

#import "DatebaseManager.h"
#import <QBImagePickerController.h>

static NSString *kHeaderCell = @"headerCell";
static NSString *kTextCell = @"textCell";

@interface UserInfoController ()<QBImagePickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) QBImagePickerController *pickerPhoto;
@property (nonatomic, strong) UIImagePickerController *pickerCamera;

@end

@implementation UserInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"账户信息";
    self.view.backgroundColor = COLOR_BACK_WHITE;
    
    [self setupTableView];
}

- (void)setupTableView
{
    self.tableView.backgroundColor = COLOR_BACK_WHITE;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

# pragma mark - Getter

- (QBImagePickerController *)pickerPhoto
{
    if (!_pickerPhoto) {
        _pickerPhoto = [QBImagePickerController new];
        _pickerPhoto.delegate = self;
    }
    return _pickerPhoto;
}

- (UIImagePickerController *)pickerCamera
{
    if (!_pickerCamera) {
        _pickerCamera = [UIImagePickerController new];
        _pickerCamera.delegate = self;
        _pickerCamera.allowsEditing = YES;
        _pickerCamera.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    return _pickerCamera;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserModel *user = [UserModel defaultUser];
    if (indexPath.row == 0) {
        // 更换头像
        UserRelatedCell *headerCell = [tableView dequeueReusableCellWithIdentifier:kHeaderCell];
        if (!headerCell) {
            headerCell = [[UserRelatedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHeaderCell cellRightType:RelatedCellRightTypeImage];
        }
        headerCell.title = @"头像";
        headerCell.rightImageData = user.headerIcon;
        return headerCell;
    } else {
        // 更换昵称和签名
        UserRelatedCell *textCell = [tableView dequeueReusableCellWithIdentifier:kTextCell];
        if (!textCell) {
            textCell = [[UserRelatedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTextCell cellRightType:RelatedCellRightTypeText];
        }
        if (indexPath.row == 1) {
            textCell.title = @"昵称";
            textCell.rightText = user.nickName;
        } else {
            textCell.title = @"签名";
            textCell.rightText = user.descriptionStr;
        }
        return textCell;
    }
}

# pragma mark - delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEIGHT_SECTION_MAX;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return HEIGHT_SECTION_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_CELL_OTHER;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        // 更换头像
        [self chooseCameraOrAlbum];
    } else if (indexPath.row == 1) {
        // 修改昵称
        [self changeNickName];
    } else {
        // 修改签名
        [self changeDescription];
    }
}

# pragma mark - Cell function

// 选择相机或者相册
- (void)chooseCameraOrAlbum
{
    WeakSelf(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [weakself presentViewController:weakself.pickerCamera animated:YES completion:nil];
        }
    }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [weakself presentViewController:weakself.pickerPhoto animated:YES completion:nil];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakself dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:cameraAction];
    [alert addAction:albumAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

// 更换昵称
- (void)changeNickName
{
    WeakSelf(self);
    ChangeNickNameController *nickNameController = [[ChangeNickNameController alloc] initWithStyle:UITableViewStyleGrouped];
    nickNameController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nickNameController animated:YES];
    
    // 更新用户信息，刷新数据
    nickNameController.nickNameChangedBlock = ^(NSString *newNickName) {
        UserModel *user = [UserModel defaultUser];
        [[DatebaseManager defaultDatebaseManager] modifyObject:^{
            user.nickName = newNickName;
        } completed:^{
            [weakself.tableView reloadData];
        }];
        
        // 刷新我的界面
        if (weakself.handleStatus) {
            weakself.handleStatus(YES);
        }
    };
}

// 更换签名
- (void)changeDescription
{
    WeakSelf(self);
    ChangeDetailController *detailController = [[ChangeDetailController alloc] init];
    detailController.title = @"修改签名";
    detailController.placeholder = @"请输入个性签名";
    detailController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailController animated:YES];
    
    // 更新用户信息，刷新数据
    detailController.edictTextBlock = ^(NSString *text) {
        UserModel *user = [UserModel defaultUser];
        [[DatebaseManager defaultDatebaseManager] modifyObject:^{
            user.descriptionStr = text;
        } completed:^{
            [weakself.tableView reloadData];
        }];
        
        // 刷新我的数据
        if (weakself.handleStatus) {
            weakself.handleStatus(YES);
        }
    };
}

# pragma mark - QBImage picke controller delegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets
{
    if (assets.count > 0) {
        WeakSelf(self);
        [[PHImageManager defaultManager] requestImageDataForAsset:assets.firstObject options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            UserModel *user = [UserModel defaultUser];
            [[DatebaseManager defaultDatebaseManager] modifyObject:^{
                user.headerIcon = imageData;
            } completed:^{
                [weakself.tableView reloadData];
            }];
            
            if (weakself.handleStatus) {
                weakself.handleStatus(YES);
            }
        }];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - UIImage picker controller delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *photoImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *photoData = UIImagePNGRepresentation(photoImage);
    UserModel *user = [UserModel defaultUser];
    
    WeakSelf(self);
    [[DatebaseManager defaultDatebaseManager] modifyObject:^{
        user.headerIcon = photoData;
    } completed:^{
        [weakself.tableView reloadData];
    }];
    
    if (self.handleStatus) {
        self.handleStatus(YES);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
