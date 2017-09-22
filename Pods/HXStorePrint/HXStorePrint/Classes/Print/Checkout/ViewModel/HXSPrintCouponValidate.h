//
//  HXSPrintCouponValidate.h
//  store
//
//  Created by J.006 on 16/8/25.
//  Copyright (c) 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSCoupon.h"
#import "HXSPrintExpectTimeEntity.h"
#import "HXSPrintHeaderImport.h"

@interface HXSPrintCouponValidate : NSObject

- (void)validateWithToken:(NSString *)token
               couponCode:(NSString *)couponCode
                     type:(HXSCouponScope)type
                 complete:(void (^)(HXSErrorCode code, NSString * message, HXSCoupon * coupon))block;

/**
 *  获取店铺可配送时间列表
 *
 *  @param shopIDIntNum 店铺shopid
 *  @param block        返回结果
 */
- (void)fetchExpectTimeList:(NSNumber *)shopIDIntNum
                   compelte:(void (^)(HXSErrorCode code, NSString *message, NSArray *expectTimeArr))block;

/**
 *  检测收货地址是否在配送范围内
 *
 *  @param shopID
 *  @param block
 */
- (void)checkAddressInScope:(NSNumber *)shopID
                     dormId:(NSString *)dormIdStr
                   compelte:(void (^)(HXSErrorCode code, NSString *message, BOOL inScope))block;

@end