//
//  HXSOrderStatusDescribeCell.m
//  store
//
//  Created by 格格 on 16/9/2.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSOrderStatusDescribeCell.h"

@interface HXSOrderStatusDescribeCell()

@property (nonatomic,weak) IBOutlet UILabel *describeLabel;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *describeLabelHeight;

@end

@implementation HXSOrderStatusDescribeCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)orderStatusDescribeCell
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSOrderStatusDescribeCell class])
                                         owner:nil options:nil].firstObject;
}

- (void)refresh
{
    self.describeLabel.text = self.orderStatus.statusSpecStr;
    
    self.describeLabelHeight.constant = self.orderStatus.statusTextHeight;
    [self layoutIfNeeded];

}

- (void)setOrderStatus:(HXSOrderStatus *)orderStatus
{
    _orderStatus = orderStatus;
    
    [self refresh];
}

@end
