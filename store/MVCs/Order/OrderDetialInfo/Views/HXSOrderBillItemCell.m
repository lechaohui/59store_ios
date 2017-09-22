//
//  HXSOrderCouponItemCll.m
//  store
//
//  Created by 格格 on 16/9/6.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  优惠信息

#import "HXSOrderBillItemCell.h"

@interface HXSOrderBillItemCell ()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;

@end


@implementation HXSOrderBillItemCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (instancetype)orderBillItemCell
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

/*****************************************************************/

- (void)refresh
{
    self.nameLabel.text = self.couponItem.couponTypeStr;
    
    if ([self.couponItem.couponShowType isEqualToString:@"money"]) {
        self.valueLabel.text = [NSString stringWithFormat:@"-%@",[self.couponItem.couponAmountDecNum yuanString]];
    } else {
        if([self.couponItem.couponTypeStr isEqualToString:@"免费打印张数:"]) {
            self.valueLabel.text = [self.couponItem.couponAmountDecNum stringValue];
        } else {
            self.valueLabel.text = [self.couponItem.couponAmountDecNum stringOfDecimalPlaces:0];
        }
    }
}

- (void)setCouponItem:(HXSCouponItem *)couponItem
{
    _couponItem = couponItem;
    
    [self refresh];
}

/*****************************************************************/

- (void)refreshDeliveryFee
{
    self.nameLabel.text = @"配送费";
    self.valueLabel.text = self.deliveryFeeStr;
}

- (void)setDeliveryFeeStr:(NSString *)deliveryFeeStr
{
    _deliveryFeeStr = deliveryFeeStr;
    
    [self refreshDeliveryFee];
}

/*****************************************************************/

- (void)refreshTotalAmount
{
    [self.nameLabel setFont:[UIFont systemFontOfSize:15]];
    [self.valueLabel setTextColor:[UIColor colorWithRGBHex:0xF54642]];
    
    self.nameLabel.text = @"实付";
    self.valueLabel.text = self.totalAmountStr;
}

- (void)setTotalAmountStr:(NSString *)totalAmountStr
{
    _totalAmountStr = totalAmountStr;
    
    [self refreshTotalAmount];
}

@end
