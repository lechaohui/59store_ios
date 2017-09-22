//
//  HXSDatedViewController.h
//  Pods
//
//  Created by caixinye on 2017/9/18.
//
//

#import "HXSBaseViewController.h"

/**
 
 已过期
 
 */
#import "HXSCoupon.h"
#import "HXMacrosEnum.h"

@protocol HXSDatedViewControllerDelegate <NSObject>

- (void)didSelectCoupon:(HXSCoupon *)coupon;

@end


@interface HXSDatedViewController : HXSBaseViewController


@property (nonatomic, weak) id<HXSDatedViewControllerDelegate> delegate;

@property (nonatomic, assign) HXSCouponScope couponScope;//使用范围


@property (nonatomic, assign) BOOL fromPersonalVC;

@property (nonatomic, assign) BOOL     isAll;


@end
