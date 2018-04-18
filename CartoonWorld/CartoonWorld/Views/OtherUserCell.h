//
//  OtherUserCell.h
//  二次元境
//
//  Created by 顿顿 on 16/4/11.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RelatedCellType) {
    RelatedCellTypeHeaderInfo, // 用户头像更换
    RelatedCellTypeNickName,   // 用户昵称更换
    RelatedCellTypeSecret,     // 用户介绍
    RelatedCellTypeOther       // 其他
};

@interface OtherUserCell : UITableViewCell

@property (nonatomic ,strong) NSArray *infoArr;

@end
