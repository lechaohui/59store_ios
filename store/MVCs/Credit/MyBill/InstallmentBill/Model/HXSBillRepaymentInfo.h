//
//  HXSBillRepaymentInfo.h
//  store
//
//  Created by hudezhi on 15/8/18.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSBillRepaymentItem : NSObject

/** 分期说明 */
@property (nonatomic) NSString *installmentTextStr;
/** 分期类型  0.消费分期 1.取现分期 2.分期购分期 */
@property (nonatomic) NSString *installmentTypeStr;
/** 分期类型icon */
@property (nonatomic) NSString *installmentImageStr;
/** 还款金额 */
@property (nonatomic) NSNumber *repaymentAmountNum;
/** 还款时间 */
@property (nonatomic) NSDate *repaymentDate;
/** 分期时间 */
@property (nonatomic) NSDate *installmentDate;
/** 分期id */
@property (nonatomic) NSString *installmentIdStr;
/** 分期总金额 */
@property (nonatomic) NSNumber *installmentAmountNum;
/** 分期总期数 */
@property (nonatomic) NSNumber *installmentNumberNum;
/**当前期数 */
@property (nonatomic) NSNumber *repaymentNumberNum;
/** 分期用途  取现  分期购物  账单分期 */
@property (nonatomic) NSString *installmentPurposeStr;
/** 还款状态 0:待还款 1:已还款 2:已逾期 */
@property (nonatomic) NSNumber *repaymentStatusNum;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end


@interface HXSBillRepaymentInfo : NSObject

/** 近期应还款总额 */
@property (nonatomic) NSNumber *recentBillAmountNum;
@property (nonatomic) NSArray *billsArr;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
