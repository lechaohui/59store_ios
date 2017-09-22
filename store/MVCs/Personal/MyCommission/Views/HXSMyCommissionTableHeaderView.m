//
//  HXSMyCommissionTableHeaderView.m
//  store
//
//  Created by 格格 on 16/4/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyCommissionTableHeaderView.h"

@implementation HXSMyCommissionTableHeaderView

+ (id)headerView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.getCashButton.layer.cornerRadius = 4;
    self.getCashButton.layer.borderWidth = 1;
    self.getCashButton.layer.masksToBounds = YES;

}

- (void)updategetCashButtonStatus:(BOOL)enable
{
    if(enable) {
        [self.getCashButton setUserInteractionEnabled:YES];
        [self.getCashButton setTitleColor:[UIColor colorWithRGBHex:0x292929] forState:UIControlStateNormal];
        self.getCashButton.layer.borderColor = [UIColor colorWithRGBHex:0x292929].CGColor;
        
    } else {
        [self.getCashButton setUserInteractionEnabled:NO];
        [self.getCashButton setTitleColor:[UIColor colorWithRed:41.0/255 green:41.0/255 blue:41.0/255 alpha:0.4] forState:UIControlStateNormal];
        self.getCashButton.layer.borderColor = [UIColor colorWithRed:41.0/255 green:41.0/255 blue:41.0/255 alpha:0.4].CGColor;
    }
}

@end
