//
//  HXSMyCommissionCell.m
//  store
//
//  Created by 格格 on 16/4/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyCommissionCell.h"


@interface HXSMyCommissionCell ()

@property (nonatomic, weak) IBOutlet UILabel *timeLael;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UILabel *moneyLabel;

@end

@implementation HXSMyCommissionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)setupCommissionCellWithCommissionEntity:(HXSCommissionEntity *)commissionEntity
                                           from:(BOOL)isDetail
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:commissionEntity.timeLongNum.longValue];
    if (isDetail) {
        _timeLael.text = [NSString stringWithFormat:@"%@",[NSDate stringFromDate:date formatString:@"yyyy-MM-dd HH:mm"]];
    } else {
        _timeLael.text = [NSString stringWithFormat:@"%@",[NSDate stringFromDate:date formatString:@"MM-dd"]];
    }
    
    _contentLabel.text = commissionEntity.contentStr;
    
    NSString *momeyStr;
    if(commissionEntity.amountIntNum.doubleValue >= 0.00) {
        momeyStr = [NSString stringWithFormat:@"+￥%.2f",fabs(commissionEntity.amountIntNum.doubleValue) ];
    } else {
        momeyStr = [NSString stringWithFormat:@"-￥%.2f",fabs(commissionEntity.amountIntNum.doubleValue)];
    }
    
    _moneyLabel.textColor = [UIColor colorWithRGBHex:0x666666];
    _moneyLabel.text = momeyStr;
}

@end
