//
//  CMBWebViewController.h
//  SKeyboardDemo
//
//  Created by zk on 15/12/2.
//  Copyright © 2015年 zk. All rights reserved.
//

#import "HXSBaseViewController.h"

@protocol HXSCMBPayViewControllerDelegate <NSObject>

- (void)cmbPaySuccess;

- (void)cmbPayFailure;

@end

@interface HXSCMBPayViewController : HXSBaseViewController

// url: http://192.168.30.111:8080/pay/cmb?order_id=1234567890&money=0.01&token=e2e22e12e21
+ (instancetype)createCMBPayWithUrl:(NSString *)outerURL delegate:(id<HXSCMBPayViewControllerDelegate>)delegate;

@end
