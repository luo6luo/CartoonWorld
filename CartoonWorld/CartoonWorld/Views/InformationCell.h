//
//  InformationCell.h
//  二次元境
//
//  Created by MS on 15/11/21.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationModel.h"

@interface InformationCell : UITableViewCell

@property (nonatomic ,assign) CGFloat height;
@property (nonatomic ,strong) InformationModel * model;

@end
