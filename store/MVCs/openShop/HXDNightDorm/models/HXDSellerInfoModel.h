//
//  HXDSellerInfoModel.h
//  59dorm
//
//  Created by BeyondChao on 16/8/29.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXDSellerInfoViewModel.h"
@class HXDAddBankInforParamEntity;

@interface HXDSellerInfoModel : NSObject

/**
 *  获取商家信息
 *
 *  @param block
 */
+ (void)fetchSellerInforComplete:(void (^)(HXDErrorCode status, NSString *message, HXDSellerInfoViewModel *model))block;

/**
 *  更新寝室地址信息： 详细地址(宿舍号) 和 所在楼栋
 *
 *  @param dormitoryId      楼栋ID
 *  @param dormitoryAddress 寝室地址（3层301）
 *
 */
+ (void)updateSellerDormitoryAddressWithDormitoryId:(NSNumber *)dormitoryId
                                   dormitoryAddress:(NSString *)dormitoryAddress
                                           complete:(void (^)(HXDErrorCode status, NSString *message, NSDictionary *data))block;

/**
 *  银行卡信息
 */
+ (void)fetchSellerBankInfoComplete:(void (^)(HXDErrorCode status, NSString *msg, HXDAddBankInforParamEntity *bankInfoModel))block;

@end
