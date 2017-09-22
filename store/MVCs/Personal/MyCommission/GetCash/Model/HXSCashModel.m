//
//  HXSCashModel.m
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCashModel.h"

@implementation HXSCashModel

+ (void)getBankCordList:(void(^)(HXSErrorCode code, NSString * message, NSArray * bankList))block;
{
    
    NSDictionary *dic = [NSDictionary dictionary];
    [HXStoreWebService getRequest:kbankList
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       
                       if (kHXSNoError == status) {
                           
                           if(DIC_HAS_ARRAY(data, @"items")) {
                               
                               NSArray *bankList = [HXSCashBankInfo arrayOfModelsFromDictionaries:[data objectForKey:@"items"] error:nil];
                               block(status,msg,bankList);
                               return ;
                           }
                           
                           block(status,msg,@[]);
                           return;
                       }
                       
                       block(status,msg,nil);
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

+ (void)addWithdrawWithCashBankInfo:(HXSCashBankInfo *)cashBankInfo
                           complete:(void(^)(HXSErrorCode code, NSString * message, NSDictionary *data))block
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:cashBankInfo.bankUserNameStr forKey:@"bank_user_name"];
    [dic setObject:cashBankInfo.bankCardNoStr forKey:@"bank_card_no"];
    [dic setObject:cashBankInfo.bankCodeStr forKey:@"bank_code"];
    [dic setObject:cashBankInfo.bankCityStr forKey:@"bank_city"];
    [dic setObject:cashBankInfo.bankSiteStr forKey:@"bank_site"];
    
    [HXStoreWebService postRequest:kBankCardAdd
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);        
    }];
}

+ (void)updateBankCardInfoWithCashBankInfo:(HXSCashBankInfo *)cashBankInfo
                                  complete:(void(^)(HXSErrorCode code, NSString * message, NSDictionary *data))block
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:cashBankInfo.bankUserNameStr forKey:@"bank_user_name"];
    [dic setObject:cashBankInfo.bankCardNoStr forKey:@"bank_card_no"];
    [dic setObject:cashBankInfo.bankCodeStr forKey:@"bank_code"];
    [dic setObject:cashBankInfo.bankCityStr forKey:@"bank_city"];
    [dic setObject:cashBankInfo.bankSiteStr forKey:@"bank_site"];
    [dic setObject:cashBankInfo.bankCardIdStr forKey:@"bank_card_id"];

    [HXStoreWebService postRequest:kBankCardUpdate
                        parameters:dic
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               block(status,msg,data);
                               
                           } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               block(status,msg,nil);        
                           }];

}

@end
