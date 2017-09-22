//
//  HXSTarget_credit.m
//  store
//
//  Created by ArthurWang on 16/6/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTarget_credit.h"

#import "HXSCreditWalletViewController.h"
#import "HXSCreditViewController.h"
#import "HXSSubscribeViewController.h"

@implementation HXSTarget_credit

/** 跳转信用钱包页面 */
- (UIViewController *)Action_creditWallet:(NSDictionary *)paramsDic
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:nil];
    HXSCreditWalletViewController *creditWalletVC = [storyboard instantiateViewControllerWithIdentifier:@"HXSCreditWalletViewController"];
    
    return creditWalletVC;
}

/** 跳转59钱包首页 */
- (UIViewController *)Action_credit:(NSDictionary *)paramsDic
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:nil];
    HXSCreditViewController *creditVC = [storyboard instantiateViewControllerWithIdentifier:@"HXSCreditViewController"];
    
    return creditVC;
}

/** 跳转开通59钱包页面 */
- (UIViewController *)Action_subscribe:(NSDictionary *)paramsDic
{
    HXSSubscribeViewController *subscribeVC = [HXSSubscribeViewController createSubscribeVC];
    
    return subscribeVC;
}

@end
