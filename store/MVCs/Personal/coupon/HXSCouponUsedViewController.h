//
//  HXSCouponUsedViewController.h
//  Pods
//
//  Created by caixinye on 2017/9/18.
//
//

#import "HXSBaseViewController.h"
/**
 
 已使用优惠券
 
 */
#import "HXSCoupon.h"
#import "HXMacrosEnum.h"

@protocol HXSCouponUsedViewControllerDelegate <NSObject>

- (void)didSelectCoupon:(HXSCoupon *)coupon;

@end



@interface HXSCouponUsedViewController : HXSBaseViewController

@property (nonatomic, weak) id<HXSCouponUsedViewControllerDelegate> delegate;

@property (nonatomic, assign) HXSCouponScope couponScope;//使用范围


@property (nonatomic, assign) BOOL fromPersonalVC;

@property (nonatomic, assign) BOOL     isAll;



@end
