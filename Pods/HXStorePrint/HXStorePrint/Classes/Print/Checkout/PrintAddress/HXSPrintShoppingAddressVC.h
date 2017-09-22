//
//  HXSShippingAddressVC.h
//  store
//
//  Created by 格格 on 16/8/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  收货地址

#import "HXSBaseViewController.h"
#import "HXSPrintShoppingAddress.h"

@protocol HXSPrintShoppingAddressVCDelegate <NSObject>

@optional

- (void)saveAddressFinishedWithAddress:(HXSPrintShoppingAddress *)shopAddress;

@end

@interface HXSPrintShoppingAddressVC : HXSBaseViewController

@property (nonatomic, weak) id<HXSPrintShoppingAddressVCDelegate> delegate;

@end
