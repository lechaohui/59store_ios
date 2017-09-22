//
//  HXSCouponValidate.m
//  store
//
//  Created by J.006 on 16/8/25.
//  Copyright (c) 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintCouponValidate.h"

static NSString *shopDeliveryRange = @"/shop/delivery/range";

@implementation HXSPrintCouponValidate

- (void)validateWithToken:(NSString *)token
               couponCode:(NSString *)couponCode
                     type:(HXSCouponScope)type
                 complete:(void (^)(HXSErrorCode code, NSString * message, HXSCoupon * coupon))block
{
    if (token == nil)
    {
        block(kHXSParamError, @"参数错误", nil);
        
        return;
    }
    
    if (couponCode == nil)
    {
        block(kHXSParamError, @"券号不能为空", nil);
        
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:token forKey:SYNC_USER_TOKEN];
    [dic setObject:couponCode forKey:@"code"];
    [dic setObject:@(type) forKey:@"scope"];

    [HXStoreWebService postRequest:HXS_COUPON_VALIDATE
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if(status == kHXSNoError) {
                            HXSCoupon * coupon = [[HXSCoupon alloc] initWithDictionary:data];
                            block(kHXSNoError, msg, coupon);
                        } else {
                            block(status, msg, nil);
                        }
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
}

- (void)fetchExpectTimeList:(NSNumber *)shopIDIntNum
                   compelte:(void (^)(HXSErrorCode code, NSString *message, NSArray *expectTimeArr))block
{
    NSDictionary *paramsDic = @{@"shop_id": shopIDIntNum};
    
    [HXStoreWebService getRequest:HXS_SHOP_EXPECT_TIME_LIST
                parameters:paramsDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(status, msg, nil);
                           
                           return;
                       }
                       NSMutableArray *timesMArr = [[NSMutableArray alloc] initWithCapacity:5];
                       if (DIC_HAS_ARRAY(data, @"times")) {
                           NSArray *timesArr = [data objectForKey:@"times"];
                           
                           timesMArr = [HXSPrintExpectTimeEntity arrayOfModelsFromDictionaries:timesArr error:nil];
                       }
                       
                       block(status, msg, timesMArr);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

- (void)checkAddressInScope:(NSNumber *)shopID
                     dormId:(NSString *)dormIdStr
                   compelte:(void (^)(HXSErrorCode code, NSString *message, BOOL inScope))block
{
    NSDictionary *paramsDic = @{@"shop_id": shopID};
    
    [HXStoreWebService getRequest:shopDeliveryRange
                       parameters:paramsDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              
                              if(kHXSNoError == status) {
                                  
                                  NSMutableArray *values = [[NSMutableArray alloc] init];
                                  
                                  if([data.allKeys containsObject:@"groups"]) {
                                      NSArray *groups = data[@"groups"];
                                      for(NSDictionary *dict in groups) {
                                          NSArray *dormentries = dict[@"dormentries"];
                                          for(NSDictionary *dic in dormentries) {
                                              NSString *str = [NSString stringWithFormat:@"%@",dic[@"dormentry_id"]];
                                              [values addObject:str];
                                          }
                                      }
                                      
                                      if([values containsObject:dormIdStr]) {
                                          
                                          block(status,msg, YES);
                                      } else {
                                          
                                          block(status,msg, NO);
                                      }
                                      
                                  } else {
                                      
                                      block(status,@"数据错误", YES);
                                  }
                              } else {
                                  block(status,msg, YES);
                              }
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status,msg, YES);
                          }];
}

@end