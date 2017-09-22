//
//  HXSOrderStatusCell.m
//  store
//
//  Created by 格格 on 16/8/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSOrderStatusCell.h"

@interface HXSOrderStatusCell ()

@property (nonatomic, weak) IBOutlet UIImageView *logoImageView;  // 图标
@property (nonatomic, weak) IBOutlet UILabel     *statusLabel;    // 订单状态

@end

@implementation HXSOrderStatusCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (instancetype)orderStatusCell
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSOrderStatusCell class])
                                                owner:nil options:nil].firstObject;
}

- (void)refresh
{
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:self.orderStatus.statusIconStr]];
    self.statusLabel.text = self.orderStatus.statusTextStr;
    
    [self.statusLabel setTextColor:[UIColor colorWithHexString:self.orderStatus.statusColorStr]];
}

- (void)setOrderStatus:(HXSOrderStatus *)orderStatus
{
    _orderStatus = orderStatus;
    
    [self refresh];
}

@end
