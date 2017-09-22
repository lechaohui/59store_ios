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

@end
