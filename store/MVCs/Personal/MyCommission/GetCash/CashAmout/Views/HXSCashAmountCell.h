//
//  HXSCashAmountCell.h
//  store
//
//  Created by 格格 on 16/10/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXSCashBankInfo.h"

@interface HXSCashAmountCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UITextField *cashTextField;
@property (nonatomic, weak) IBOutlet UILabel *placeholderLabel;

@property (nonatomic, strong) HXSCashBankInfo *cashBankInfo;
@property (nonatomic, strong) NSString *allAmountStr;

@end
