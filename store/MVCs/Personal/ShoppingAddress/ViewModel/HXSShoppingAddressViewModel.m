//
//  HXSShoppingAddressViewModel.m
//  store
//
//  Created by 格格 on 16/8/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSShoppingAddressViewModel.h"

@implementation HXSShoppingAddressViewModel

+ (void)fetchShoppingAddressComplete:(void (^)(HXSErrorCode code, NSString * message, NSArray *shoppingAddressArr))block
{
    [HXStoreWebService getRequest:kUserAddressList
                       parameters:nil
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if(kHXSNoError == status) {
                                  NSArray *arr = [data objectForKey:@"list"];
                                  if(arr) {
                                      NSArray *resultArray = [HXSShoppingAddress arrayOfModelsFromDictionaries:arr error:nil];
                                      block(status,msg,resultArray);
                                  } else {
                                      block(status,msg,@[]);
                                  }
                              } else {
                                  block(status,msg,nil);
                              }
                              
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

+ (void)updateShoppingAddressWithModel:(HXSShoppingAddress *)shoppingAddress
                              complete:(void (^) (HXSErrorCode code, NSString * message,NSDictionary *dic))block
{
    NSDictionary *prama = @{
                            @"id"            : shoppingAddress.idStr,
                            @"gender"        : shoppingAddress.genderStr,
                            @"site_id"       : shoppingAddress.siteIdStr,
                            @"dormentry_id"  : shoppingAddress.dormentryIdStr,
                            @"contact_name"  : shoppingAddress.contactNameStr,
                            @"contact_phone" : shoppingAddress.contactPhoneStr,
                            @"detail_address": shoppingAddress.detailAddressStr
                            };
    [HXStoreWebService postRequest:kUserAddressUpdate
                        parameters:prama
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               block(status,msg,data);
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
 }

+ (void)addNewShoppingAddressWithModel:(HXSShoppingAddress *)shoppingAddress
                              complete:(void (^) (HXSErrorCode code, NSString * message,NSDictionary *dic))block
{
    NSDictionary *prama = @{
                            @"gender"        : shoppingAddress.genderStr,
                            @"site_id"       : shoppingAddress.siteIdStr,
                            @"dormentry_id"  : shoppingAddress.dormentryIdStr,
                            @"contact_name"  : shoppingAddress.contactNameStr,
                            @"contact_phone" : shoppingAddress.contactPhoneStr,
                            @"detail_address": shoppingAddress.detailAddressStr
                            };
    [HXStoreWebService postRequest:kUserAddressAdd
                        parameters:prama
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               block(status,msg,data);
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
    }];
}

@end
