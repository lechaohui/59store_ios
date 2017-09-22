//
//  HXSOrderBillCell.m
//  store
//
//  Created by 格格 on 16/8/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSOrderBillCell.h"

@interface HXSOrderBillCell()

@property (nonatomic, weak) IBOutlet UILabel *totalNumLabel;   // 商品总件数
@property (nonatomic, weak) IBOutlet UILabel *totalPriceLabel; // 商品总价

@end

@implementation HXSOrderBillCell

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
    self.totalNumLabel.text = [NSString stringWithFormat:@"共%@件商品",self.myOrder.orderDetailInfo.itemQuantityStr];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"合计：%@",[self.myOrder.orderDetailInfo.payAmountDecNum yuanString]] ;
}

- (void)setMyOrder:(HXSMyOrder *)myOrder
{
    _myOrder = myOrder;
    
    [self refresh];
}

@end
