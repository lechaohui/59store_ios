//
//  HXSBorrowRepaymentAmountCell.h
//  store
//
//  Created by hudezhi on 15/8/13.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//  近期应还款

#import <Foundation/Foundation.h>
#import "HXSBillRepaymentInfo.h"

@interface HXSBorrowRepaymentAmountCell : UITableViewCell

@property (nonatomic) HXSBillRepaymentItem *record;
@property (weak, nonatomic) IBOutlet UIButton *expandBtn;

@end
