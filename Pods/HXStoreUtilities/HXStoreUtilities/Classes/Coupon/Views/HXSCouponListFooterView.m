//
//  HXSCouponListSectionFooterView.m
//  store
//
//  Created by 格格 on 16/10/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCouponListFooterView.h"

@interface HXSCouponListFooterView ()

@property (nonatomic, weak) IBOutlet UIButton *historyCouponButton;

@end

@implementation HXSCouponListFooterView

+ (instancetype)footerView
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"Coupon" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    return [bundle loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

- (IBAction)historyButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(historyCouponButtonClocked)]) {
        [self.delegate historyCouponButtonClocked];
    }
}

@end
