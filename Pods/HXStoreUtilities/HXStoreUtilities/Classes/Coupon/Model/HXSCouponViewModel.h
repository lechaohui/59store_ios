//
//  HXSCouponListRequest.h
//  store
//
//  Created by chsasaw on 14/12/4.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXStoreWebService.h"
#import "HXMacrosEnum.h"

static NSString * const kUserCouponBind = @"user/coupon/bind";

/** 优惠券类型 */
typedef NS_ENUM(NSInteger, HXSCouponAvailableType)
{
    HXSCouponAvailableTypeHistory         = -1,
    HXSCouponAvailableTypeAll             = 0,
    HXSCouponAvailableTypeAvailable       = 1
};

@interface HXSCouponViewModel : NSObject

+ (void)fatchCouponsWithAvailable:(NSNumber *)available
                      scope:(HXSCouponScope)couponScope
                   complete:(void (^)(HXSErrorCode code, NSString * message, NSArray * coupons,NSNumber *dueCountNum))block;

/**
 *  打印获取优惠券接口
 *
 *  @param type   优惠券类型0:通用 ，1:相片  2:文稿，（如果不传则默认为2）
 *  @param amount 如果isAll传no,需要传这个字段，获取满足使用金额门槛的优惠券
 *  @param isAll  是否全部优惠券  //yes:是  no:否
 *  @param block
 */
+ (void)getPrintCouponpicListWithType:(NSNumber *)type
                               amount:(NSNumber *)amount
                                isAll:(BOOL)isAll
                             complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *printCoupons))block;

/*
 * 绑定一张优惠券
 * @prama code：优惠券号
 */
+ (void)bindCouponWithCode:(NSString *)codeString
                  complete:(void (^)(HXSErrorCode code, NSString * message, NSDictionary * dic))block;

@end
