//
//  HXSMediator+HXCreditModule.m
//  Pods
//
//  Created by ArthurWang on 16/6/23.
//
//

#import "HXSMediator+HXCreditModule.h"

static NSString const *kHXSMediatorTargetCredit       = @"credit";

static NSString const *kHXSMediatorActionCreditWallet = @"creditWallet";
static NSString const *kHXSMediatorActionCredit       = @"credit";
static NSString const *kHXSMediatorActionSubscrible   = @"subscrible";

@implementation HXSMediator (HXCreditModule)

- (UIViewController *)HXSMediator_creditWalletViewController
{
    UIViewController *viewController = [self performTarget:kHXSMediatorTargetCredit
                                                    action:kHXSMediatorActionCreditWallet
                                                    params:nil];
    
    return viewController;
}

- (UIViewController *)HXSMediator_creditViewController
{
    UIViewController *viewController = [self performTarget:kHXSMediatorTargetCredit
                                                    action:kHXSMediatorActionCredit
                                                    params:nil];
    
    return viewController;
}

- (UIViewController *)HXSMediator_subscribleViewController
{
    UIViewController *viewController = [self performTarget:kHXSMediatorTargetCredit
                                                    action:kHXSMediatorActionSubscrible
                                                    params:nil];
    
    return viewController;
}

@end
