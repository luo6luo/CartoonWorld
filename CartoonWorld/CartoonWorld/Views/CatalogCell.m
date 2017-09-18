//
//  CatalogCell.m
//  CartoonWorld
//
//  Created by dundun on 2017/8/24.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "CatalogCell.h"
#import "CatalogModel.h"

@interface CatalogCell()

@property (weak, nonatomic) IBOutlet UIImageView *cornerImage;
@property (weak, nonatomic) IBOutlet UILabel *catalogLabel;


@end

@implementation CatalogCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupCatalogCell];
}

- (void)setupCatalogCell
{
    self.contentView.backgroundColor = COLOR_WHITE;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = COLOR_APP_LINE.CGColor;
    
    self.catalogLabel.textColor = COLOR_TEXT_BLACK;
    
    // 设置变黄
}

- (void)setCatalogModel:(CatalogModel *)catalogModel
{
    _catalogModel = catalogModel;
    
    self.catalogLabel.text = catalogModel.name;
    if (catalogModel.type == 0) {
        self.cornerImage.hidden = YES;
    } else {
        self.cornerImage.hidden = NO;
    }
}

@end
