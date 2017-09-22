//
//  HXSCouponViewCell.h
//  store
//
//  Created by 格格 on 16/5/27.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSCoupon.h"

/** 优惠券状态 */
typedef NS_ENUM(NSInteger, HXSCouponStatusType)
{
    HXSCouponStatusTypeNotStarted   = 0,
    HXSCouponStatusTypeNormal       = 1,
    HXSCouponStatusTypeUsed         = 2,
    HXSCouponStatusTypeOverdue      = 3,
    HXSCouponStatusTypeWillOverdue  = 4  // 即将过期
};

@interface HXSCouponViewCell : UITableViewCell

@property (nonatomic, strong) HXSCoupon *coupon;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
