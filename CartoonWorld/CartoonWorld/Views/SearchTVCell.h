//
//  SearchTabelViewCell.h
//  二次元境
//
//  Created by MS on 15/11/27.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchTabelViewCellDelegate <NSObject>

- (void)cellWithText:(NSString *)searchStr;

@end

@interface SearchTVCell : UICollectionViewCell<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) NSArray * array;

@property (nonatomic ,weak) id<SearchTabelViewCellDelegate> delegate;

@end
