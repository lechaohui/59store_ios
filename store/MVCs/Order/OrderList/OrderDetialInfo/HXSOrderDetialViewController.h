//
//  HXSOrderDetialViewController.h
//  store
//
//  Created by 格格 on 16/8/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  订单详情

#import "HXSBaseViewController.h"

@class HXSMyOrder;

@interface HXSOrderDetialViewController : HXSBaseViewController

+ (instancetype)controllerWithMyOrder:(NSString *)order_sn;

@end
