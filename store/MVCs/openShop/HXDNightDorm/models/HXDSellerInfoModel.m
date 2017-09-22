//
//  HXDSellerInfoModel.m
//  59dorm
//
//  Created by BeyondChao on 16/8/29.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXDSellerInfoModel.h"
#import "HXDAddBankInforParamEntity.h"

@implementation HXDSellerInfoModel

+ (void)fetchSellerInforComplete:(void (^)(HXDErrorCode, NSString *, HXDSellerInfoViewModel *))block {
   
    
    /*
    [WebService getRequest:HXD_SELLER_INFO
                parameters:nil
                  progress:nil
                  encToken:nil
                   isLogin:YES
                   success:^(HXDErrorCode status, NSString *msg, NSDictionary *data) {
                       
                       if (kHXDNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       HXDSellerInfoViewModel *model = [[HXDSellerInfoViewModel alloc] initWithDictionary:data error:nil];
                       [HXDUserAccount currentAccount].accountType = model.roleNum.integerValue;
                       [HXDUserAccount currentAccount].dormID      = model.sellerIdentity.dormId;
                       [HXDUserAccount currentAccount].mankeepId   = model.sellerIdentity.mankeepId;
                       
                       block(kHXDNoError, msg, model);
                   }
                   failure:^(HXDErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];*/
    
    

}

+ (void)updateSellerDormitoryAddressWithDormitoryId:(NSNumber *)dormitoryId dormitoryAddress:(NSString *)dormitoryAddress complete:(void (^)(HXDErrorCode, NSString *, NSDictionary *))block {
    
    /*
    NSDictionary *parameterDic = @{
                                   @"dormentry_id":                     dormitoryId,
                                   @"delivery_address":                 dormitoryAddress
                                   };
    
    [WebService postRequest:HXD_UPDATE_SELLERINFO
                 parameters:parameterDic
                   progress:nil
                   encToken:nil
                    isLogin:YES
                    success:^(HXDErrorCode status, NSString *msg, NSDictionary *data) {
                        
                        if (kHXDNoError != status) {
                            block(status, msg, nil);
                            
                            return ;
                        }
                        
                        block(kHXDNoError, msg, data);
                    }
                    failure:^(HXDErrorCode status, NSString *msg, NSDictionary *data) {
                        block(kHXDNoError, msg, nil);
                    }];*/

}

+ (void)fetchSellerBankInfoComplete:(void (^)(HXDErrorCode, NSString *, HXDAddBankInforParamEntity *))block {
   
    /*
    [WebService getRequest:HXD_SELLER_BANK_INFO
                parameters:nil
                  progress:nil
                  encToken:nil
                   isLogin:YES
                   success:^(HXDErrorCode status, NSString *msg, NSDictionary *data) {
                       
                       if (kHXDNoError != status) {
                           block(status, msg, nil);
                           
                           return ;
                       }
                       
                       HXDAddBankInforParamEntity *model = [[HXDAddBankInforParamEntity alloc] initWithDictionary:data error:nil];
                       
                       block(kHXDNoError, msg, model);
                   }
                   failure:^(HXDErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status, msg, nil);
                   }];*/

}

    
@end
