//
//  HXSCashAmountViewController.h
//  store
//
//  Created by 格格 on 16/10/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSCashBankInfo.h"

@interface HXSCashAmountViewController : HXSBaseViewController

+ (instancetype)controllerWithAllAmount:(NSString *)allAmount cashBankInfo:(HXSCashBankInfo *)cashBankInfo;

@end
