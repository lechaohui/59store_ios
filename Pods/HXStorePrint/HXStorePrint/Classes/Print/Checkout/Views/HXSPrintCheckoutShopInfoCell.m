//
//  HXSPrintCheckoutShopInfoCell.m
//  store
//
//  Created by J.006 on 16/9/2.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSPrintCheckoutShopInfoCell.h"

@interface HXSPrintCheckoutShopInfoCell()

@property (weak, nonatomic) IBOutlet UILabel *shopInforLabel;

@end

@implementation HXSPrintCheckoutShopInfoCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - init

- (void)initPrintCheckoutShopInfoCellWithEntity:(HXSShopEntity *)entity
{
    if(entity.shopNameStr)
    {
        [_shopInforLabel setText:entity.shopNameStr];
    }
}

@end
