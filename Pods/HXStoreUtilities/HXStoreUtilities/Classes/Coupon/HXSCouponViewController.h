//
//  HXSCouponViewController.h
//  store
//
//  Created by chsasaw on 14/12/4.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

#import "HXSCoupon.h"
#import "HXMacrosEnum.h"

@protocol HXSCouponViewControllerDelegate <NSObject>

- (void)didSelectCoupon:(HXSCoupon *)coupon;

@end

@interface HXSCouponViewController : HXSBaseViewController

@property (nonatomic, weak) id<HXSCouponViewControllerDelegate> delegate;

@property (nonatomic, assign) HXSCouponScope couponScope;

@property (nonatomic, assign) BOOL fromPersonalVC;

@property (nonatomic, strong) NSNumber *docTypeNum;//云印店 打印文件设置:
@property (nonatomic, strong) NSNumber *docCouponAmountNum;// 文档打印减去免费打印价格 */
@property (nonatomic, assign) BOOL     isAll;

@end
