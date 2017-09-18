//
//  BaseCell.h
//  二次元境
//
//  Created by MS on 15/11/22.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

@interface BaseCell : UITableViewCell

@property (nonatomic ,strong) NSString * type;
@property (nonatomic ,strong) BaseModel * model;

@end
