//
//  HXSCashAmountCell.m
//  store
//
//  Created by 格格 on 16/10/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCashAmountCell.h"

@interface HXSCashAmountCell ()

@property (nonatomic, weak) IBOutlet UILabel *allAmountLabel;

@end

@implementation HXSCashAmountCell

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
    self.allAmountLabel.text = [NSString stringWithFormat:@"可提现余额：￥%.2f",self.allAmountStr.floatValue];
}

- (IBAction)cashAllButtonClicked:(id)sender
{
    self.cashTextField.text = [NSString stringWithFormat:@"%.2f",self.allAmountStr.floatValue];
    self.placeholderLabel.hidden = YES;
}

- (void)setCashBankInfo:(HXSCashBankInfo *)cashBankInfo
{
    _cashBankInfo = cashBankInfo;
}

- (void)setAllAmountStr:(NSString *)allAmountStr
{
    _allAmountStr = allAmountStr;
    [self refresh];
}

@end
