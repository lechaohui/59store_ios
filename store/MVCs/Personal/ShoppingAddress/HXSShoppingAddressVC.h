//
//  HXSShippingAddressVC.h
//  store
//
//  Created by 格格 on 16/8/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  收货地址

#import "HXSBaseViewController.h"

@protocol HXSShoppingAddressVCDelegate <NSObject>

- (void)saveAddressFinished;

@end

@interface HXSShoppingAddressVC : HXSBaseViewController

@property (nonatomic, weak) id<HXSShoppingAddressVCDelegate>  delegate;

@end
