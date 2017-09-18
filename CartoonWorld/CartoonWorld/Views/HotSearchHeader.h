//
//  HotSearchHeader.h
//  二次元境
//
//  Created by 顿顿 on 16/4/8.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotSearchHeader : UICollectionReusableView

@property (nonatomic ,strong) NSString * textFieldText;
@property (nonatomic ,copy) void(^searchTextBlock)(NSString * inputcontent);
@property (nonatomic ,copy) void(^searchBtnBlock)();

@end
