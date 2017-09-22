//
//  HXSCouponListSectionHeaderView.m
//  store
//
//  Created by 格格 on 16/10/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCouponListSectionHeaderView.h"

#import "UIColor+Extensions.h"

@interface HXSCouponListSectionHeaderView ()

@property (nonatomic, weak) IBOutlet UILabel  *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *illustrateButton;

@end

@implementation HXSCouponListSectionHeaderView

+ (instancetype)couponListSectionHeaderView
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"Coupon" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    HXSCouponListSectionHeaderView *view = [bundle loadNibNamed:NSStringFromClass([HXSCouponListSectionHeaderView class]) owner:nil options:nil].firstObject;
    
    return view;

}

- (IBAction)illustrateButtonClicked:(id)sender
{
    if([self.delegate respondsToSelector:@selector(illustrateButtonClicked)]) {
        
        [self.delegate illustrateButtonClicked];
    }

}


#pragma mark - Setter

- (void) setDueCountNum:(NSNumber *)dueCountNum
{
    _dueCountNum = dueCountNum;
    
    NSString *str = [NSString stringWithFormat:@"你有%zd张优惠券即将过期",dueCountNum.integerValue];
    
    if (0 < dueCountNum.integerValue) {
        
        NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:str];
        [atr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithRGBHex:0xfa4d4d]
                    range:[str rangeOfString:[NSString stringWithFormat:@"%zd",dueCountNum.integerValue]]];
        
        self.titleLabel.attributedText = atr;
    
    } else {
        
        self.titleLabel.text = str;
    }

}

- (void)setCouponCountNum:(NSNumber *)couponCountNum
{
    _couponCountNum = couponCountNum;
    
    if (0 >= [couponCountNum integerValue]) {
        NSString *str = [NSString stringWithFormat:@"你暂时没有可用优惠券"];
        
        self.titleLabel.text = str;
    }
}


@end
