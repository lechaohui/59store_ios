//
//  HXSShoppingAddressViewModel.h
//  store
//
//  Created by 格格 on 16/8/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSPrintShoppingAddress.h"
#import "HXSPrintHeaderImport.h"

static NSString * const kUserAddressList   = @"user/address/list";  // 获取收货地址
static NSString * const kUserAddressAdd    = @"user/address/add";   // 新增用户地址
static NSString * const kUserAddressUpdate = @"user/address/update";// 更新地址

@interface HXSPrintShoppingAddressViewModel : NSObject

/**
 * 获取收货地址
 */
+ (void)fetchShoppingAddressComplete:(void (^)(HXSErrorCode code, NSString * message, NSArray *shoppingAddressArr))block;

/**
 *  修改收货地址
 
 */
+ (void)updateShoppingAddressWithModel:(HXSPrintShoppingAddress *)shoppingAddress
                              complete:(void (^) (HXSErrorCode code, NSString * message,NSDictionary *dic))block;

/**
 *  新增收货地址
 */
+ (void)addNewShoppingAddressWithModel:(HXSPrintShoppingAddress *)shoppingAddress
                              complete:(void (^) (HXSErrorCode code, NSString * message,NSDictionary *dic))block;

@end
