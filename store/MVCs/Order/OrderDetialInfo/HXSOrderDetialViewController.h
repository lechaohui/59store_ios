//
//  HXSOrderDetialViewController.h
//  store
//
//  Created by 格格 on 16/8/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  订单详情

#import "HXSBaseViewController.h"

@class HXSMyOrder;

@protocol HXSOrderDetialViewControllerDelegate <NSObject>

- (void)orderStatusChange;

@end

@interface HXSOrderDetialViewController : HXSBaseViewController

@property (nonatomic, weak) id <HXSOrderDetialViewControllerDelegate> delegate;

+ (instancetype)controllerWithMyOrder:(NSString *)order_sn;

@end
