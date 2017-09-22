//
//  HXSCashModel.h
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSCashBankInfo.h"

static NSString * const kBankCardAdd    = @"bank_card/add";
static NSString * const kBankCardUpdate = @"bank_card/update";
static NSString * const kbankList       = @"bank_card/list";

@interface HXSCashModel : NSObject


/**
 *  获取银行卡信息
 *
 *  @param block
 */
+ (void)getBankCordList:(void(^)(HXSErrorCode code, NSString * message, NSArray * bankList))block;

/**
 *  新增银行卡信息
 *  @param block
 */
+ (void)addWithdrawWithCashBankInfo:(HXSCashBankInfo *)cashBankInfo
                              complete:(void(^)(HXSErrorCode code, NSString * message, NSDictionary *data))block;

/**
 * 修改银行卡信息
 */
+ (void)updateBankCardInfoWithCashBankInfo:(HXSCashBankInfo *)cashBankInfo
                                  complete:(void(^)(HXSErrorCode code, NSString * message, NSDictionary *data))block;



@end
