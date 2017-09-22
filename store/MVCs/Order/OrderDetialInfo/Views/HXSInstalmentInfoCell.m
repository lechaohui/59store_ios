//
//  HXSInstalmentInfoCell.m
//  store
//
//  Created by 格格 on 16/9/1.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSInstalmentInfoCell.h"

@interface HXSInstalmentInfoCell()

@property (nonatomic,weak) IBOutlet UILabel *downPaymentLable;       // 首付金额
@property (nonatomic,weak) IBOutlet UILabel *instalmentAmountLable;  // 分期总金额
@property (nonatomic,weak) IBOutlet UILabel *stageAmountLable;       // 分期金额
@property (nonatomic,weak) IBOutlet UILabel *poundageLabel;          // 说明

@end

@implementation HXSInstalmentInfoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (instancetype)instalmentInfoCell
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

- (void)refresh
{
    self.downPaymentLable.text = [self.stagingInfo.firstPayAmountDecNum yuanString];
    self.instalmentAmountLable.text = [self.stagingInfo.stagingAmountDecNum yuanString];
    self.stageAmountLable.text = [NSString stringWithFormat:@"%@x%@",[self.stagingInfo.stagingPerMonthDecNum yuanString ],self.stagingInfo.stagingNumStr];
    self.poundageLabel.text = [NSString stringWithFormat:@"（含手续费：%@/期）",[self.stagingInfo.stagingFeeDecNum yuanString]];
}

- (void)setStagingInfo:(HXStagingInfo *)stagingInfo
{
    _stagingInfo = stagingInfo;
    
    [self refresh];
}

@end
