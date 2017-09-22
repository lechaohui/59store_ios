//
//  HXSOrderConsigneeInfoCell.m
//  store
//
//  Created by 格格 on 16/8/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSOrderConsigneeInfoCell.h"

@interface HXSOrderConsigneeInfoCell ()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;     // 收货人
@property (nonatomic, weak) IBOutlet UILabel *phoneLabel;    // 联系电话
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;  // 收货地址
@property (nonatomic, weak) IBOutlet UILabel *remarkLabel;   // 备注
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *addressLabelHeightLayout; // 收货地址高度
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *remarkLabelHeightLayout;  // 备注高度

@end

@implementation HXSOrderConsigneeInfoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (instancetype)orderConsigneeInfoCell
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                         owner:nil options:nil].firstObject;
}

- (void)resfresh
{
    self.nameLabel.text = [NSString stringWithFormat:@"收货人：%@",self.buyerAddress.buyerNameStr];
    self.phoneLabel.text = self.buyerAddress.buyerPhoneStr;
    self.addressLabel.text = [NSString stringWithFormat:@"收货地址：%@",self.buyerAddress.buyerAddressStr];
    self.remarkLabel.text = [NSString stringWithFormat:@"备注：%@",self.buyerAddress.addressRemarkStr.length > 0 ?self.buyerAddress.addressRemarkStr : @"无"];

    self.addressLabelHeightLayout.constant = self.buyerAddress.buyerAddressTextHeight;
    self.remarkLabelHeightLayout.constant = self.buyerAddress.addressRemarkTextHeight;
    [self layoutIfNeeded];
}

- (void)setBuyerAddress:(HXSBuyerAddress *)buyerAddress
{
    _buyerAddress = buyerAddress;
    [self resfresh];
}

@end
