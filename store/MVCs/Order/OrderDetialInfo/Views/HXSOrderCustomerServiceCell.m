//
//  HXSOrderCustomerServiceCell.m
//  store
//
//  Created by 格格 on 16/9/1.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSOrderCustomerServiceCell.h"

@implementation HXSOrderCustomerServiceCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (instancetype)orderCustomerServiceCell
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

- (IBAction)phoneButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(contactMerchant)]) {
        [self.delegate contactMerchant];
    }
}

@end
