//
//  HXSCashAmountSectionFooter.m
//  store
//
//  Created by 格格 on 16/10/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCashAmountSectionFooter.h"

@implementation HXSCashAmountSectionFooter

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.cashButton.layer.cornerRadius = 4;
    self.cashButton.layer.masksToBounds = YES;
    [self.cashButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cashButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.4] forState:UIControlStateDisabled];
}

+ (instancetype)sectionFooter
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

@end
