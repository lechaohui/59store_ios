//
//  HXShopNameAndOrderStatusCell.m
//  store
//
//  Created by 格格 on 16/8/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXShopNameAndOrderStatusCell.h"

@interface HXShopNameAndOrderStatusCell ()

@property (nonatomic, weak) IBOutlet UILabel     *shopNameLabel;      // 店铺名称
@property (nonatomic, weak) IBOutlet UILabel     *orderStatusLabel;   // 订单状态
@property (nonatomic, weak) IBOutlet UIImageView *shopLogoImageView;  // 卖家头像

@end

@implementation HXShopNameAndOrderStatusCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.shopLogoImageView.layer.cornerRadius = 8;
    self.shopLogoImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

+ (instancetype)shopNameAndOrderStatusCell
{
  return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil
                                     options:nil].firstObject;
}


/**********************************订单列表****************************************/

- (void)refreshMyOrderInfo
{
    [self.shopHeadImageView sd_setImageWithURL:[NSURL URLWithString:self.myOrder.shopInfo.shopIconStr]];
    [self.shopLogoImageView sd_setImageWithURL:[NSURL URLWithString:self.myOrder.shopInfo.shopAvatarStr] placeholderImage:[UIImage imageNamed:@"ic_shop_logo"]];
    [self.orderStatusLabel setTextColor:[UIColor colorWithHexString:self.myOrder.orderStatus.statusColorStr]];
    
    self.shopNameLabel.text    = self.myOrder.shopInfo.shopNameStr;
    self.orderStatusLabel.text = self.myOrder.orderStatus.statusTextStr;
    
}

- (void)setMyOrder:(HXSMyOrder *)myOrder
{
    _myOrder = myOrder;
    [self refreshMyOrderInfo];
}


/********************************订单详情*******************************************/

- (void)refreshShopInfo
{
    [self.shopHeadImageView sd_setImageWithURL:[NSURL URLWithString:self.shopInfo.shopIconStr]];
    [self.shopLogoImageView sd_setImageWithURL:[NSURL URLWithString:self.shopInfo.shopAvatarStr] placeholderImage:[UIImage imageNamed:@"ic_shop_logo"]];

    self.shopNameLabel.text    = self.shopInfo.shopNameStr;
    self.orderStatusLabel.hidden = YES;
}

- (void)setShopInfo:(HXShopInfo *)shopInfo
{
    _shopInfo = shopInfo;
    
    [self refreshShopInfo];
}


@end
