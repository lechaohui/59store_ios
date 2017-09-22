//
//  HXSWithdrawalRecordViewModel.h
//  store
//
//  Created by 格格 on 16/10/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSWithdrawRecode.h"

static NSString * const kWithdrawAdd     = @"withdraw/add";    // 发起提现
static NSString * const kWithdrawDetail  = @"withdraw/detail"; // 提现记录

@interface HXSWithdrawalRecordViewModel : NSObject


/**
 * 发起提现
 * @prama bank_card_id: 银行卡id, 我们平台生成的, 非银行卡号
 * @prama money:提现金额
 */
+ (void)addWithdrawWithbankCardId:(NSString *)bank_card_id
                            money:(NSNumber *)money
                         complete:(void (^) (HXSErrorCode code, NSString * message, NSDictionary * dic))block;

/**
 *  提现记录
 */
+ (void)fatchWithdrawRecordWithPage:(NSNumber *)page
                               size:(NSNumber *)size
                           complete:(void (^) (HXSErrorCode code, NSString * message, NSArray * withdrawRecords,NSNumber *amount))block;



@end
