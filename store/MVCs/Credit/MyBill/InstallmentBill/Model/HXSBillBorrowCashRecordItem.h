//
//  HXSBillBorrowCashRecordItem.h
//  store
//
//  Created by hudezhi on 15/8/14.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSBillBorrowCashRecordItem : NSObject

/** 分期id */
@property(nonatomic) NSNumber *installmentIdNum;
/** 分期说明 */
@property(nonatomic) NSString *installmentTextStr;
/** 分期类型 0.消费账单分期 1.取现分期 2.分期购分期 */
@property(nonatomic) NSString *installmentTypeStr;
/** 分期类型icon */
@property(nonatomic) NSString *installmentImageStr;
/** 分期时间 */
@property(nonatomic) NSDate *installmentDate;
/** 分期总金额 */
@property(nonatomic) NSNumber *installmentAmountNum;
/** 分期总期数 */
@property(nonatomic) NSNumber *installmentNumberNum;
/** 分期用途 取现  分期购物  账单分期 */
@property(nonatomic) NSString *installmentPurposeStr;
/** 分期状态 0待放款 1待还款 2还款中 3已还完 */
@property(nonatomic) NSNumber *installmentStatusNum;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
