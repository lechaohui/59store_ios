//
//  HXSBorrowRepaymentPlanViewController.h
//  store
//
//  Created by hudezhi on 15/7/28.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@interface HXSBorrowRepaymentPlanViewController : HXSBaseViewController

@property (nonatomic) NSString *serialNumber;

@property (nonatomic, strong) NSString *itemTitleStr;

/** 分期id */
@property(nonatomic) NSNumber *installmentIdNum;
/** 分期类型 */
@property(nonatomic) NSString *installmentTypeStr;

@end
