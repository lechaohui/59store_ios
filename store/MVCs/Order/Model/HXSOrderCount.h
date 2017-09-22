//
//  HXSOrderCount.h
//  store
//
//  Created by 格格 on 16/9/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXBaseJSONModel.h"

@interface HXSOrderCount : HXBaseJSONModel

/** 待支付数量 */
@property (nonatomic, strong) NSString *waitingpayCountStr;
/** 进行中数量 */
@property (nonatomic, strong) NSString *processingCountStr;
/** 待评价数量 */
@property (nonatomic, strong) NSString *tobecommentCountStr;
/** 退款/售后数量 */
@property (nonatomic, strong) NSString *refundCountStr;

@end
