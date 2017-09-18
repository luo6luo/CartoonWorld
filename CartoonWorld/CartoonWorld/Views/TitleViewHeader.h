//
//  TitleViewHeader.h
//  二次元境
//
//  Created by 顿顿 on 16/4/6.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RecommendTypeModel;

@interface TitleViewHeader : UICollectionReusableView

@property (nonatomic ,strong) RecommendTypeModel *typeModel;
@property (nonatomic, assign) BOOL isShow; // 是否显示更多按钮

@property (nonatomic ,copy) void(^moreBtnClickedBlock)();

@end
