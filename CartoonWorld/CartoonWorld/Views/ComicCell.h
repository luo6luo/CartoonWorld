//
//  ComicCell.h
//  二次元境
//
//  Created by 顿顿 on 16/4/8.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicModel.h"

@interface ComicCell : UITableViewCell

@property (nonatomic ,strong) ComicModel * comicModel;
@property (nonatomic ,strong) UIButton * button;
@property (nonatomic ,strong) NSString * myDescription;
@property (nonatomic ,strong) NSString * buttonTitle;
@property (nonatomic ,strong) void(^lookCartoonBlock)();

@end
