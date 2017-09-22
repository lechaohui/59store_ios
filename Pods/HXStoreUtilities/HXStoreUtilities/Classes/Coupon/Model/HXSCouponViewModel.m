//
//  HXSCouponListRequest.m
//  store
//
//  Created by chsasaw on 14/12/4.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSCouponViewModel.h"

#import "HXSCoupon.h"
#import "HXMacrosUtils.h"

#define HXS_PRINT_COUPONPIC_LIST        @"print/couponpic/list" // 云印店 获取优惠券

@implementation HXSCouponViewModel

+ (void)fatchCouponsWithAvailable:(NSNumber *)available
                            scope:(HXSCouponScope)couponScope
                         complete:(void (^)(HXSErrorCode code, NSString * message, NSArray * coupons,NSNumber *dueCountNum))block
{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:available forKey:@"available"];
    if (kHXSCouponScopeNone != couponScope) {
        [dic setObject:[NSNumber numberWithInt:couponScope] forKey:@"scope"];
    }

    [HXStoreWebService getRequest:HXS_COUPON_LIST
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if(status == kHXSNoError) {
                           DLog(@"----------------- 优惠券数据:%@", data);
                           NSMutableArray * coupons = [NSMutableArray array];
                           if(DIC_HAS_ARRAY(data, @"coupons")) {
                               for(NSDictionary * dic in [data objectForKey:@"coupons"]) {
                                   HXSCoupon * coupon = [[HXSCoupon alloc] initWithDictionary:dic];
                                   if(coupon != nil) {
                                       [coupons addObject:coupon];
                                   }
                               }
                           }
                           NSNumber *due_count = [data objectForKey:@"due_count"];
                           
                           block(kHXSNoError, msg, coupons,due_count);
                       }else {
                           block(status, msg, nil,nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil,nil);
                   }];
    
}

+ (void)getPrintCouponpicListWithType:(NSNumber *)type
                               amount:(NSNumber *)amount
                                isAll:(BOOL)isAll
                             complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *printCoupons))block{
    
    NSMutableDictionary *prama = [NSMutableDictionary dictionary];
    [prama setObject:type forKey:@"type"];
    [prama setObject:amount forKey:@"amount"];
    
    [HXStoreWebService getRequest:HXS_PRINT_COUPONPIC_LIST parameters:prama progress:nil success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
        if(kHXSNoError == status){
            NSMutableArray *resultArray = [NSMutableArray array];
            NSArray *arr = [data objectForKey:@"coupons"];
            if(arr){
                for(NSDictionary *dic in arr){
                    HXSCoupon *temp = [HXSCoupon objectFromJSONObject:dic];
                    [resultArray addObject:temp];
                }
            }
            block(status,msg,resultArray);
        } else {
            block(status,msg,nil);
        }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
    
}

+ (void)bindCouponWithCode:(NSString *)codeString
                  complete:(void (^)(HXSErrorCode code, NSString * message, NSDictionary * dic))block
{
    NSDictionary *prama = @{@"code":codeString};
    
    [HXStoreWebService getRequest:kUserCouponBind
                       parameters:prama progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              
                              block(status,msg,data);
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
        block(status,msg,data);
        
    }];
}

@end
