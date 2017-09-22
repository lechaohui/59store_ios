//
//  HXSMediator+RootViewController.m
//  Pods
//
//  Created by J006 on 16/8/22.
//
//

#import "HXSMediator+RootViewController.h"

static NSString *kHXSMediatorTargetRootViewController = @"rootViewController";

static NSString *kHXSMediatorActionRootVC             = @"rootVC";

@implementation HXSMediator (RootViewController)

- (UINavigationController *)HXSMediator_rootViewControllerNavigation
{
    UINavigationController *navi = [self performTarget:kHXSMediatorTargetRootViewController
                                                action:kHXSMediatorActionRootVC
                                                params:nil];
    
    return navi;
}

@end
