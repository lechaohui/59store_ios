//
//  HXSCommission.h
//  store
//
//  Created by 格格 on 16/10/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXBaseJSONModel.h"

#import "HXSCommissionEntity.h"

@interface HXSCommission : HXBaseJSONModel

/** 钱包余额(可提现的) */
@property (nonatomic, strong) NSString *amountWalletStr;
/** 总收入 单位元 */
@property (nonatomic, strong) NSString *incomeStr;
/** 总支出, 单位元*/
@property (nonatomic, strong) NSString *outlayStr;

@property (nonatomic, strong) NSArray<HXSCommissionEntity> *itemsArr;


@end
