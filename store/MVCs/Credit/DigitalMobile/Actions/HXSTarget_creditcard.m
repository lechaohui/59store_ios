//
//  HXSTarget_creditcard.m
//  store
//
//  Created by ArthurWang on 16/5/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTarget_creditcard.h"

#import "HXSDigitalMobileViewController.h"
#import "HXSMyBillViewController.h"
#import "HXSBorrowCashRecordViewController.h"
#import "HXSCreditWalletViewController.h"
#import "HXSDigitalMobileDetailViewController.h"

@implementation HXSTarget_creditcard

/** 跳转分期商城页面 */
// hxstore://creditcard/tip
- (UIViewController *)Action_tip:(NSDictionary *)paramsDic
{
    HXSDigitalMobileViewController *mobileVC = [HXSDigitalMobileViewController controllerFromXib];
    
    return mobileVC;
}

/** 跳转信用钱包分期类账单页面 */
// hxstore://creditcard/installment/bill
- (UIViewController *)Action_bill:(NSDictionary *)paramsDic
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:nil];
    HXSMyBillViewController *myBillVC = [story instantiateViewControllerWithIdentifier:@"HXSMyBillViewController"];
    /** 0 @"消费类账单"  1  @"分期类账单" */
    NSString *billTypeStr = [paramsDic objectForKey:@"bill_type"];
    myBillVC.selectedSegmentIndexIntNum = [NSNumber numberWithInt:billTypeStr.intValue];
    
    return myBillVC;
}

/** 跳转信用钱包分期纪录页面 */
// hxstore://creditcard/installment/record
- (UIViewController *)Action_installmentrecord:(NSDictionary *)paramsDic
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:nil];
    HXSBorrowCashRecordViewController *cashRecordVC = [story instantiateViewControllerWithIdentifier:@"HXSBorrowCashRecordViewController"];
    
    return cashRecordVC;
}

/** 跳转信用钱包页面页面 */
// hxstore://creditcard/wallet
- (UIViewController *)Action_wallet:(NSDictionary *)paramsDic
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:nil];
    HXSCreditWalletViewController *creditWalletVC = [storyboard instantiateViewControllerWithIdentifier:@"HXSCreditWalletViewController"];
    
    return creditWalletVC;
}

/** 跳转分期购商品详情页面 */
// hxstore://creditcard/tip/group/item?group_id=123
- (UIViewController *)Action_tipgroupitem:(NSDictionary *)paramsDic
{
    HXSDigitalMobileDetailViewController *detailVC = [HXSDigitalMobileDetailViewController controllerFromXib];
    
    NSString *groupIDStr = [paramsDic objectForKey:@"group_id"];
    detailVC.itemIDIntNum = [NSNumber numberWithInt:[groupIDStr intValue]];
    
    return detailVC;
}

@end
