//
//  ComicListCell.h
//  CartoonWorld
//
//  Created by dundun on 2017/8/16.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ComicModel;

@interface ComicListCell : UITableViewCell

@property (nonatomic, strong) ComicModel *comicModel;
@property (nonatomic, strong) NSString *promptInfoStr;

@end
