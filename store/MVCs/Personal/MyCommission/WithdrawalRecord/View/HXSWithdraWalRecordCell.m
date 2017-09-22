//
//  HXSWithdraWalRecordCell.m
//  store
//
//  Created by 格格 on 16/10/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSWithdraWalRecordCell.h"

@interface HXSWithdraWalRecordCell()

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *amoubtLabel;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;

@end

@implementation HXSWithdraWalRecordCell

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
    self.timeLabel.text = [NSDate stringFromSecondsSince1970:self.withdrawRecode.updateTimeStr.longLongValue format:@"YYYY-MM-dd"];
    self.amoubtLabel.text = [NSString stringWithFormat:@"￥%.2f",self.withdrawRecode.moneyStr.floatValue];
    [self statusLabelFitWithdrawRecodeStatus];

}

- (void)statusLabelFitWithdrawRecodeStatus
{
    switch (self.withdrawRecode.statusStr.integerValue) {
        case HXSWithdrawRecodeStatusWithdrawaling:
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0xff9500];
            self.statusLabel.text = @"处理中";
            break;
        case HXSWithdrawRecodeStatusFinish:
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0x999999];
            self.statusLabel.text = @"已完成";
            break;
        case HXSWithdrawRecodeStatusFailed:
            self.statusLabel.textColor = [UIColor colorWithRGBHex:0xfa4d4d];
            self.statusLabel.text = @"提现失败";
            break;
        default:
            break;
    }

}

- (void)setWithdrawRecode:(HXSWithdrawRecode *)withdrawRecode
{
    _withdrawRecode = withdrawRecode;
    [self refresh];
}

@end
