//
//  HXSCouponListSectionFooterVIew.m
//  store
//
//  Created by 格格 on 16/10/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCouponListSectionFooterView.h"

@implementation HXSCouponListSectionFooterView

+ (instancetype)sectionFooterView
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"Coupon" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    return [bundle loadNibNamed:NSStringFromClass([self class ]) owner:nil options:nil].firstObject;
}

@end
