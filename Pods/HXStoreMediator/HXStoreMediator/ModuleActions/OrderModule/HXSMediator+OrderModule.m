//
//  HXSMediator+OrderModule.m
//  Pods
//
//  Created by ArthurWang on 16/9/2.
//
//

#import "HXSMediator+OrderModule.h"

static NSString *kHXSMediatorTargetOrder  = @"order";
static NSString *kHXSMediatorActionDetail = @"detail";

@implementation HXSMediator (OrderModule)

- (UIViewController *)HXSMediator_orderDetailViewControllerWithParams:(NSDictionary *)params;
{
    UIViewController *viewController = [self performTarget:kHXSMediatorTargetOrder
                                                    action:kHXSMediatorActionDetail
                                                    params:params];
    
    return viewController;
}

@end
