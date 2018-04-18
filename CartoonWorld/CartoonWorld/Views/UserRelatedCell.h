//
//  UserRelatedCell.h
//  CartoonWorld
//
//  Created by dundun on 2017/11/21.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RelatedCellRightType) {
    RelatedCellRightTypeImage = 0, // 右侧是图片
    RelatedCellRightTypeText,      // 右侧是文字
    RelatedCellRightTypeNone       // 右侧是空
};

@interface UserRelatedCell : UITableViewCell

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSData *rightImageData;
@property (nonatomic, strong) NSString *rightText;

/**
 初始化cell

 @param style           cell的样式
 @param reuseIdentifier cell的标识符
 @param rightType       cell右边控件类型
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                cellRightType:(RelatedCellRightType)rightType;

@end
