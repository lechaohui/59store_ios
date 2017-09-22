//
//  HXSTarget_order.h
//  store
//
//  Created by ArthurWang on 16/9/2.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSTarget_order : NSObject

/** 跳转订单详情 */
// hxstore://order/detail?type=123&order_sn=456
- (UIViewController *)Action_detail:(NSDictionary *)paramsDic;

@end
