//
//  HXSOrderCount.m
//  store
//
//  Created by 格格 on 16/9/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSOrderCount.h"

@implementation HXSOrderCount

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"waitingpay_count" , @"waitingpayCountStr",
                             @"processing_count" , @"processingCountStr",
                             @"tobecomment_count", @"tobecommentCountStr",
                             @"refund_count"     , @"refundCountStr", nil];
    
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:mapping];
}

@end
