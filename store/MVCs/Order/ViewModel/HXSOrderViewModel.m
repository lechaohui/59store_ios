//
//  HXSOrderViewModel.m
//  store
//
//  Created by 格格 on 16/8/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSOrderViewModel.h"
#import "HXSActionSheetEntity.h"
#import "HXMacrosUtils.h"

@implementation HXSOrderViewModel

+ (void)fecthMyordersWithQueryStatus:(NSString *)query_status
                                page:(NSInteger)page
                            pageSize:(NSInteger)page_size
                            complete:(void(^)(HXSErrorCode status, NSString *message, NSArray *ordersArr))block
{
    NSDictionary *prama = @{
                            @"page"     : @(page),
                            @"page_size": @(page_size),
                            @"query_status" :query_status,
                            };
    
    [HXStoreWebService getRequest:kOrderapiQueryBuyerMyorders
                       parameters:prama
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              
                              if (kHXSNoError == status) {
                                  
                                  if(DIC_HAS_ARRAY(data, @"orders")) {
                                      
                                      NSArray *resultArr = [HXSMyOrder arrayOfModelsFromDictionaries:[data objectForKey:@"orders"] error:nil];
                                      block(status,msg,resultArr);
                                      
                                      return;
                                  }
                                  
                                  block(status,msg,@[]);
                                  
                                  return;
                              }
                              
                              block(status,msg,nil);
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];

}

+ (void)fecthOrderDetialWithOrderId:(NSString *)order_id
                           complete:(void (^)(HXSErrorCode status, NSString *message, HXSMyOrder *myOrder))block
{
    NSDictionary *prama = @{ @"order_id":order_id };
    
    [HXStoreWebService getRequest:kOrderapiQueryBuyerOrderdetail
                       parameters:prama
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                             
                              if (kHXSNoError == status) {
                              
                                  HXSMyOrder *myOrder = [[HXSMyOrder alloc]initWithDictionary:[data objectForKey:@"order"] error:nil];
                                  block(status,msg,myOrder);
                                  
                                  return;
                              }
                              
                              block(status,msg,nil);
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}


+ (void)cancleOrderWithOrderId:(NSString *)order_id
                      complete:(void (^)(HXSErrorCode status, NSString *message, NSDictionary *dic))block
{
     NSDictionary *prama = @{ @"order_id":order_id };
    
    [HXStoreWebService postRequest:kOrderapiOperateBuyerCancel
                       parameters:prama
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status,msg,data);
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status,msg,nil);
                          }];

}

+ (void)evaluateOrderWithOrderId:(NSString *)order_id
                          itemId:(NSString *)item_id
                           score:(int)score
                         content:(NSString *)content
                        complete:(void (^)(HXSErrorCode status, NSString *message, NSDictionary *dic))block
{
    NSDictionary *prama = @{
                            @"order_id":order_id,
                            @"item_id" :item_id,
                            @"score"   :@(score),
                            @"content" :content
                            };
    
    [HXStoreWebService postRequest:kOrderapiOperateBuyerComment
                        parameters:prama
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               block(status,msg,data);
                               
                           } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               block(status,msg,nil);
                           }];

}

+ (void)fetchPayMethodsWith:(NSString *)orderTypeStr
                  payAmount:(NSNumber *)payAmountFloatNum
                installment:(NSString *)isInstallmentIntStr
                   complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *payArr))block
{
    NSDictionary *paramsDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                               orderTypeStr,                @"order_type",
                               payAmountFloatNum,           @"pay_amount",
                               [NSNumber numberWithInt:0],  @"device_type",  //0为iOS，1为Android
                               isInstallmentIntStr,         @"installment",
                               nil];
    
    [HXStoreWebService getRequest:kPayMethods
                       parameters:paramsDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(status, msg, nil);
                                  
                                  return ;
                              }
                              
                              NSArray *methodsArr = nil;
                              if (DIC_HAS_ARRAY(data, @"paymethods")) {
                                  methodsArr = [HXSActionSheetEntity createActionSheetEntityWithPaymentArr:[data objectForKey:@"paymethods"]];
                              }
                              
                              block(status, msg, methodsArr);
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                              block(status, msg, nil);
                          }];
}


+ (void)facthMyOrderCountComplete:(void (^)(HXSErrorCode status, NSString *message, HXSOrderCount *orderCount))block
{
    [HXStoreWebService getRequest:kOrderapiQueryBuyerOrdercount parameters:nil progress:nil success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
        if (kHXSNoError == status) {
            HXSOrderCount *count = [[HXSOrderCount alloc]initWithDictionary:data error:nil];
            block(status,msg,count);
            return ;
        }
        block(status,msg,nil);
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

+ (void)cashOnDeliveryWithOrderId:(NSString *)order_id
                         complete:(void (^)(HXSErrorCode status, NSString *message, NSDictionary *dic))block
{
    NSDictionary *prama = @{
                            @"order_id":order_id
                            };
    
    [HXStoreWebService postRequest:kCashOnDeliveryNotify
                        parameters:prama progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
                               block(status,msg,data);
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
        block(status,msg,nil);
        
    }];
}

+ (void)payCheckWithOrderId:(NSString *)order_id
                   complete:(void (^)(HXSErrorCode status, NSString *message, NSDictionary *dic))block
{
    NSDictionary *prama = @{
                            @"order_id":order_id
                            };
    
    [HXStoreWebService getRequest:kOrderapiQueryBuyerBeforepaycheck
                       parameters:prama
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status,msg,data);
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
        block(status,msg,data);
        
    }];
    
}

@end
