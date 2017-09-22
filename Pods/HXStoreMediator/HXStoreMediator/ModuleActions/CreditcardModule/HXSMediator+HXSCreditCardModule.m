//
//  HXSMediator+HXSCreditCardModule.m
//  store
//
//  Created by ArthurWang on 16/5/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMediator+HXSCreditCardModule.h"

static NSString *kHXSMediatorTargetCreditCard = @"creditcard";

static NSString *kHXSMediatorActionTip               = @"tip";
static NSString *kHXSMediatorActionBill              = @"bill";
static NSString *kHXSMediatorActionInstallmentRecord = @"installmentrecord";
static NSString *kHXSMediatorActionWallet            = @"wallet";
static NSString *kHXSMediatorActionTipGroupItem      = @"tipgroupitem";


@implementation HXSMediator (HXSCreditCardModule)

- (UIViewController *)HXSMediator_creditCardViewControllerWithParams:(NSDictionary *)params
{
    UIViewController *viewController = [self performTarget:kHXSMediatorTargetCreditCard
                                                    action:kHXSMediatorActionTip
                                                    params:params];
    
    return viewController;
}

- (UIViewController *)HXSMediator_billViewControllerWithParams:(NSDictionary *)params
{
    UIViewController *viewController = [self performTarget:kHXSMediatorTargetCreditCard
                                                    action:kHXSMediatorActionBill
                                                    params:params];
    
    return viewController;
}

- (UIViewController *)HXSMediator_installmentRecordViewController
{
    UIViewController *viewController = [self performTarget:kHXSMediatorTargetCreditCard
                                                    action:kHXSMediatorActionInstallmentRecord
                                                    params:nil];
    
    return viewController;
}

- (UIViewController *)HXSMediator_walletViewController
{
    UIViewController *viewController = [self performTarget:kHXSMediatorTargetCreditCard
                                                    action:kHXSMediatorActionWallet
                                                    params:nil];
    
    return viewController;
}

- (UIViewController *)HXSMediator_tipGroupItemViewControllerWithParams:(NSDictionary *)params
{
    UIViewController *viewController = [self performTarget:kHXSMediatorTargetCreditCard
                                                    action:kHXSMediatorActionTipGroupItem
                                                    params:params];
    
    return viewController;
}

@end
