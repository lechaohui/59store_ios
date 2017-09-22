//
//  HXSCommissionModel.m
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommissionModel.h"

static NSString * const kAccountAmountDetail = @"account/amount/detail";

@implementation HXSCommissionModel

+ (void)getCommissionRewardsWithPage:(NSNumber *)page
                                      size:(NSNumber *)size
                                 startTime:(NSNumber *)start_time
                                   endTime:(NSNumber *)end_time
                                  complete:(void(^)(HXSErrorCode code, NSString * message, HXSCommission *commission))block
{
    NSDictionary *prama = @{
                            @"start_time":start_time,
                            @"end_time":end_time,
                            @"page_num":page,
                            @"page_size":size
                            };
    
    [HXStoreWebService getRequest:kAccountDetail
                parameters:prama
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                      
                       if (kHXSNoError == status) {
                           
                           HXSCommission *commission = [[HXSCommission alloc]initWithDictionary:data error:nil];
                           
                           block(status,msg,commission);
                           
                           return ;
                       }

                       block(status,msg,nil);
                       
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

@end
