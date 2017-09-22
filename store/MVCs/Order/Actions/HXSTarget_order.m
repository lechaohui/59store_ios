//
//  HXSTarget_order.m
//  store
//
//  Created by ArthurWang on 16/9/2.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTarget_order.h"

#import "HXSOrderDetialViewController.h"

@implementation HXSTarget_order

/** 跳转订单详情 */
// hxstore://order/detail?type=123&order_sn=456
- (UIViewController *)Action_detail:(NSDictionary *)paramsDic
{
    NSString *orderSNStr = [paramsDic objectForKey:@"order_sn"];
    
    HXSOrderDetialViewController *orderDetailVC = [HXSOrderDetialViewController controllerWithMyOrder:orderSNStr];
    
    return orderDetailVC;
}

@end
