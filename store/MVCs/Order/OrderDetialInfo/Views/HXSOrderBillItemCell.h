//
//  HXSOrderCouponItemCll.h
//  store
//
//  Created by 格格 on 16/9/6.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSMyOrder.h"

@interface HXSOrderBillItemCell : UITableViewCell

/** 优惠信息 */
@property (nonatomic, strong) HXSCouponItem *couponItem;
/** 配送费 */
@property (nonatomic, strong) NSString *deliveryFeeStr;
/** 实付金额 */
@property (nonatomic, strong) NSString *totalAmountStr;

+ (instancetype)orderBillItemCell;

@end
