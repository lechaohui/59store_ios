//
//  HXSCashAmountBankCell.m
//  store
//
//  Created by 格格 on 16/10/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCashAmountBankCell.h"

@interface HXSCashAmountBankCell()

@property (nonatomic, weak) IBOutlet UIImageView *bankLogoImageView;
@property (nonatomic, weak) IBOutlet UILabel *bankNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *bankNoLabel;

@end

@implementation HXSCashAmountBankCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)refresh
{
    [self.bankLogoImageView sd_setImageWithURL:[NSURL URLWithString:self.cashBankInfo.bankIconStr]];
    self.bankNameLabel.text = self.cashBankInfo.bankNameStr;
    
    NSString *str;
    if (self.cashBankInfo.bankCardNoStr.length >= 4) {
       str  = [self.cashBankInfo.bankCardNoStr substringFromIndex:self.cashBankInfo.bankCardNoStr.length - 4];
    } else {
        str = self.cashBankInfo.bankCardNoStr;
    }
    self.bankNoLabel.text = [NSString stringWithFormat:@"尾号：%@",str];
}

- (void)setCashBankInfo:(HXSCashBankInfo *)cashBankInfo
{
    _cashBankInfo = cashBankInfo;
    
    [self refresh];
}

@end
