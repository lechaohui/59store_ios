//
//  HXSMediator+HXSCreditCardModule.h
//  store
//
//  Created by ArthurWang on 16/5/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMediator.h"

@interface HXSMediator (HXSCreditCardModule)

- (UIViewController *)HXSMediator_creditCardViewControllerWithParams:(NSDictionary *)params;

- (UIViewController *)HXSMediator_billViewControllerWithParams:(NSDictionary *)params;

- (UIViewController *)HXSMediator_installmentRecordViewController;

- (UIViewController *)HXSMediator_walletViewController;

- (UIViewController *)HXSMediator_tipGroupItemViewControllerWithParams:(NSDictionary *)params;

@end
