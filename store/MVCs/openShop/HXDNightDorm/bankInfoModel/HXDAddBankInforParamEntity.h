//
//  HXDAddBankInforParamEntity.h
//  59dorm
//
//  Created by J006 on 16/3/3.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXDAddBankInforParamEntity : HXBaseJSONModel

/** 开户行id */
@property (nonatomic, copy) NSString *bankIdStr;//bank_id
/** 开户行名称 */
@property (nonatomic, copy) NSString *bankNameStr;//bankName
/** 开户地 */
@property (nonatomic, copy) NSString *openLocationStr;//open_location
/** 开户网点 */
@property (nonatomic, copy) NSString *openAccountStr;//open_account
/** 银行卡号 */
@property (nonatomic, copy) NSString *cardNumberStr;//card_number
/** 持卡人姓名 */
@property (nonatomic, copy) NSString *cardHolderNameStr;//cardholder_name://持卡人姓名
/** 开户行图标 */
@property (nonatomic, copy) NSString *bankImageStr;


@end
