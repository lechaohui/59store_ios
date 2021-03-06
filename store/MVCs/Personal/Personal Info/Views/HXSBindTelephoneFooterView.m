//
//  HXSBindTelephoneFooterView.m
//  store
//
//  Created by hudezhi on 15/9/29.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSBindTelephoneFooterView.h"

@interface HXSBindTelephoneFooterView ()

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;

@end

@implementation HXSBindTelephoneFooterView

+ (instancetype)bindTelephoneFooterView
{
    HXSBindTelephoneFooterView *footerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    
    NSString *phoneNumberStr = HXSConst.phoneNumberStr;
    [footerView.serviceCallBtn setTitle:phoneNumberStr forState:UIControlStateNormal];
    [footerView.serviceCallBtn setTitle:phoneNumberStr forState:UIControlStateSelected];
    
     return footerView;
}

- (void)setIsUpdate:(BOOL)isUpdate
{
    _tipLabel.hidden = !isUpdate;
    _serviceLabel.hidden = !isUpdate;
    _serviceCallBtn.hidden = !isUpdate;
}

@end
