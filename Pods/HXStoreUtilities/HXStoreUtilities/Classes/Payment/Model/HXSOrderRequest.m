//
//  HXSOrderRequest.m
//  store
//
//  Created by chsasaw on 14/12/3.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSOrderRequest.h"

#import "HXSCreateOrderParams.h"
#import "HXSDormItem.h"
#import "HXSOrderCreateModel.h"

static NSString * const kOrderapiOperateBuyerCreateURL = @"orderapi/operate/buyer/create";
static NSString * const kOrderCashOnDeliveryNotifyURL  = @"cash_on_delivery/notify";
static NSString * const kURLOrderapiQueryBuyerBeforepaycheck = @"orderapi/query/buyer/beforepaycheck";

@implementation HXSOrderRequest

- (void)getOrderInfoWithToken:(NSString *)token
                      orderSn:(NSString *)orderSn
                     complete:(void (^)(HXSErrorCode, NSString *, HXSOrderInfo *))block
{
    if (token == nil || orderSn == nil) {
        block(kHXSParamError, @"参数错误", nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:token forKey:SYNC_USER_TOKEN];
    [dic setObject:orderSn forKey:@"order_sn"];

    [HXStoreWebService getRequest:HXS_ORDER_INFO
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if(status == kHXSNoError) {
                           HXSOrderInfo * info = [[HXSOrderInfo alloc] initWithDictionary:data];
                           block(kHXSNoError, msg, info);
                       } else {
                           block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

- (void)newDormOrderWithCreateOrderParams:(HXSCreateOrderParams *)createOrderParams
                                 compelte:(void (^)(HXSErrorCode code, NSString * message, HXSOrderInfo * orderInfo)) block
{
    if (nil == createOrderParams) {
        block(kHXSParamError, @"参数错误", nil);
        return;
    }
    
    NSMutableArray *itemsArray = [NSMutableArray array];
    
    for (HXSDormItem *itemModel in createOrderParams.itemsArr) {
        NSMutableDictionary *itemDict = [NSMutableDictionary dictionary];
        
        [itemDict setValue:itemModel.productIDStr forKey:@"product_id"];
        [itemDict setValue:itemModel.quantity forKey:@"quantity"];
        [itemDict setValue:itemModel.name forKey:@"item_name"];
        
        [itemsArray addObject:itemDict];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:itemsArray
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];
    
    NSDictionary *paramsDic = @{
                                @"dormentry_id":        createOrderParams.dormentryIDIntNum,
                                @"shop_id":             createOrderParams.shopIDIntNum,
                                @"phone":               createOrderParams.phoneStr,
                                @"coupon_code":         createOrderParams.couponCodeStr,
                                @"verification_code":   createOrderParams.verificationCodeStr,
                                @"remark":              createOrderParams.remarkStr,
                                @"address_id":          createOrderParams.addressIdStr,
                                @"items":               jsonStr,
                                };
    
    [HXStoreWebService postRequest:kOrderapiOperateBuyerCreateURL
                 parameters:paramsDic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if(status == kHXSNoError) {
                            HXSOrderCreateModel *orderModel = [[HXSOrderCreateModel alloc] initWithDictionary:data error:nil];
                            
                            HXSOrderInfo * info = [[HXSOrderInfo alloc] initWithOrderInfo:orderModel];
                            block(kHXSNoError, msg, info);
                        } else {
                            block(status, msg, nil);
                        }
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
    
}

- (void)changeOrderPayTypeWithOrderSN:(NSString *)order_sn
                           compelte:(void (^)(HXSErrorCode, NSString *, NSDictionary *))block
{
    if (nil == order_sn) {
        block(kHXSParamError, @"参数错误", nil);
        
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:order_sn forKey:@"order_id"];
    
    [HXStoreWebService postRequest:kOrderCashOnDeliveryNotifyURL
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        block(status, msg, nil);
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
}

- (void)cancelOrderWithToken:(NSString *)token
                    order_sn:(NSString *)order_sn
                    compelte:(void (^)(HXSErrorCode, NSString *, HXSOrderInfo *))block
{
    if (token == nil || order_sn == nil) {
        block(kHXSParamError, @"参数错误", nil);
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:token forKey:SYNC_USER_TOKEN];
    [dic setObject:order_sn forKey:@"order_sn"];
    
    [HXStoreWebService postRequest:HXS_ORDER_CANCEL
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if(status == kHXSNoError) {
                            HXSOrderInfo * info = [[HXSOrderInfo alloc] initWithDictionary:data];
                            block(kHXSNoError, msg, info);
                        } else {
                            block(status, msg, nil);
                        }
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
    
}

- (void)fetchPayStatusWithOrderSN:(NSString *)orderSNStr
                         compelte:(void (^)(HXSErrorCode code, NSString * message, NSDictionary *dic)) block
{
    NSString *param = @{@"order_id":orderSNStr};
    
    [HXStoreWebService getRequest:kURLOrderapiQueryBuyerBeforepaycheck
                       parameters:param
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status, msg, data);
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status, msg, data);
                          }];
}


@end
