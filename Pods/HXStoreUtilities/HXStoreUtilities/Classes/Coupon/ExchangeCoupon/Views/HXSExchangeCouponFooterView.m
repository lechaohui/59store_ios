//
//  HXSExchangeCouponFooterView.m
//  store
//
//  Created by 格格 on 16/10/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSExchangeCouponFooterView.h"

@implementation HXSExchangeCouponFooterView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.changeButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.4] forState:UIControlStateDisabled];
    
    self.changeButton.layer.cornerRadius = 4;
    self.changeButton.layer.masksToBounds = YES;

}

+ (instancetype)exchangeCouponFooterView
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"Coupon" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    return [bundle loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

@end
