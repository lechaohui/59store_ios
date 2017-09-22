//
//  HXSWithdrawalRecordViewModel.m
//  store
//
//  Created by 格格 on 16/10/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSWithdrawalRecordViewModel.h"

@implementation HXSWithdrawalRecordViewModel

+ (void)addWithdrawWithbankCardId:(NSString *)bank_card_id
                            money:(NSNumber *)money
                         complete:(void (^) (HXSErrorCode code, NSString * message, NSDictionary * dic))block
{
    NSDictionary *dic = @{
                          @"bank_card_id":bank_card_id,
                          @"money":money
                          };
    
    [HXStoreWebService postRequest:kWithdrawAdd
                        parameters:dic
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
                               block(status,msg,data);
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
        block(status,msg,data);
        
    }];
}

+ (void)fatchWithdrawRecordWithPage:(NSNumber *)page
                               size:(NSNumber *)size
                           complete:(void (^) (HXSErrorCode code, NSString * message, NSArray * withdrawRecords,NSNumber *amount))block
{
    
    NSDictionary *prama = @{
                            @"page_num":page,
                            @"page_size":size
                            };
    [HXStoreWebService getRequest:kWithdrawDetail
                       parameters:prama progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        
        if(status == kHXSNoError) {
            NSArray *withdrawRecords;
            if(DIC_HAS_ARRAY(data, @"items")) {
                withdrawRecords = [HXSWithdrawRecode arrayOfModelsFromDictionaries:[data objectForKey:@"items"] error:nil];
            }
            
            NSNumber *number = [data objectForKey:@"amount"];
            
            block(status,msg,withdrawRecords,number);
            
            return;
        }
       
     block(status,msg,@[],@(0));
     
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
         block(status,msg,nil,nil);
    }];
}

@end
