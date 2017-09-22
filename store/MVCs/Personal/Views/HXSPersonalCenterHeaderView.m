//
//  HXSPersonalCenterHeaderView.m
//  store
//
//  Created by hudezhi on 15/7/21.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSPersonalCenterHeaderView.h"

#import "HXSPersonalMenuButton.h"
#import "HXSCouponViewController.h"
#import "UIButton+AFNetworking.h"

@interface HXSPersonalCenterHeaderView () {
   
    UIView *_bottomSepratorLine;
}

@property (weak, nonatomic) IBOutlet UIView *btnContainerView;
@property (weak, nonatomic) IBOutlet UILabel * userNameLabel;

@end

@implementation HXSPersonalCenterHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    
    _personalPortraitImageView.layer.masksToBounds = YES;
    _personalPortraitImageView.layer.cornerRadius = 30;
    _personalPortraitImageView.layer.borderWidth = 0.5;
    _personalPortraitImageView.layer.borderColor = [UIColor colorWithRGBHex:0x6BCBFC].CGColor;
    _btnContainerView.backgroundColor = [UIColor whiteColor];
    _btnContainerView.layer.cornerRadius = 10.0;
    
    //为btnContainerView添加阴影
    self.btnContainerView.layer.shadowOpacity = 0.8;//阴影透明度
    self.btnContainerView.layer.shadowColor = [UIColor blackColor].CGColor;//[UIColor colorWithHexString:@"6d6c6c"].CGColor;
    self.btnContainerView.layer.shadowRadius = 4;//阴影扩散的范围控制
    self.btnContainerView.layer.shadowOffset = CGSizeMake(5,5);//阴影的范围
    
    

    if (_bottomSepratorLine == nil) {
        _bottomSepratorLine = [[UIView alloc] init];
        _bottomSepratorLine.backgroundColor = [UIColor colorWithRGBHex:0xE1E2E3];
       // [self addSubview:_bottomSepratorLine];
    }
    
    _signButton.layer.cornerRadius = 4;
    _signButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _signButton.layer.borderWidth = 1;
    [_signButton setTitleColor:[UIColor colorWithR:255 G:255 B:255 A:0.5] forState:UIControlStateDisabled];
    
    _creditBtn.valueLabel .adjustsFontSizeToFitWidth = YES;
    _commissionBtn.valueLabel.adjustsFontSizeToFitWidth = YES;
    _centsBtn.valueLabel.adjustsFontSizeToFitWidth = YES;
    _couponsBtn.valueLabel.adjustsFontSizeToFitWidth = YES;

    [self refreshInfo];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _bottomSepratorLine.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
}

+ (id)headerView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
}

- (void)refreshInfo
{
    _creditBtn.subTitleLabel.text = @"钱包";
    _commissionBtn.subTitleLabel.text = @"积分";//收入
    _centsBtn.subTitleLabel.text = @"优惠券";//积分
    _couponsBtn.subTitleLabel.text = @"购物车";//优惠券
    
    // 用户已经登录
    if([HXSUserAccount currentAccount].isLogin) {
        
        HXSUserBasicInfo *basicInfo = [HXSUserAccount currentAccount].userInfo.basicInfo;
        HXSUserCreditcardInfoEntity *creditCardInfo = [HXSUserAccount currentAccount].userInfo.creditCardInfo;
        
        NSString * url = [basicInfo.portrait stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_personalPortraitImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"img_headsculpture"]];
        _centsBtn.iconImageView.image = nil;
        _commissionBtn.iconImageView.image = nil;
        _couponsBtn.iconImageView.image = nil;
        _creditBtn.iconImageView.image = nil;
        
        _userNameLabel.text = [NSString stringWithFormat:@"%@", basicInfo.nickName ? basicInfo.nickName : @""];
    
        NSDate *registDate  = [NSDate dateWithTimeIntervalSince1970:basicInfo.registerTimeLongNum.longValue];
        NSNumber *differDateCoun = [self differDateCountBetweenDate1:registDate date2:[NSDate date]];
        _dateCountLabel.text = [NSString stringWithFormat:@"59已陪伴你%ld天了",differDateCoun.longValue + 1];
        _dateCountLabel.hidden = YES;
        // 签到
        if(kHXPersonSignStatusNotSign == basicInfo.signInFlag){
            /*
             登录未签到状态，显示可可以获取的积分，签到按钮可用
             */
            _signButton.enabled = YES;
            NSString *sianButtonTitle = [NSString stringWithFormat:@"签到+%d分",basicInfo.signInCreditIntNum.intValue];
            [_signButton setTitle:sianButtonTitle forState:UIControlStateNormal];
            [_signButton.titleLabel adjustsFontSizeToFitWidth];
            _signButton.layer.borderColor = [UIColor colorWithR:255 G:255 B:255 A:1].CGColor;
            _signButton.hidden = YES;
        } else {
            /*
             登录已签到状态，不显示可获取的积分，签到按钮设置成不可用
             */
            _signButton.enabled = NO;
            [_signButton setTitle:@"已签到" forState:UIControlStateNormal];
            _signButton.layer.borderColor = [UIColor colorWithR:255 G:255 B:255 A:0.5].CGColor;
                    }
        _signButton.hidden = YES;
        
        // 积分[NSString stringWithFormat:@"%d 分", basicInfo.credit]
        _commissionBtn.valueLabel.attributedText = [self attributedString:[NSString stringWithFormat:@"%d 分", basicInfo.credit]
                                                           subString:@"分"
                                                               color:[UIColor colorWithRGBHex:0x666666]];
        
        // 优惠券[NSString stringWithFormat:@"%d 张", basicInfo.couponQuantity]
        _centsBtn.valueLabel.attributedText = [self attributedString:[NSString stringWithFormat:@"%d 张", basicInfo.couponQuantity]
                                                           subString:@"张"
                                                               color:[UIColor colorWithRGBHex:0x666666]];

        // 购物车
        _couponsBtn.valueLabel.attributedText = [self attributedString:[NSString stringWithFormat:@"%d 张", basicInfo.couponQuantity]
                                                             subString:@"张"
                                                                 color:[UIColor colorWithRGBHex:0x666666]];
        
        _dateCountLabel.hidden = YES;
        _dateCountLabelHeight.constant = 21;
        
        if ((kHXSCreditAccountStatusNotOpen == [creditCardInfo.accountStatusIntNum integerValue])
            || (kHXSCreditAccountStatusChecking == [creditCardInfo.accountStatusIntNum integerValue])
            || (kHXSCreditAccountStatusCheckFailed == [creditCardInfo.accountStatusIntNum integerValue])) {
            _creditBtn.valueLabel.attributedText = [self attributedString:@"点击开通"
                                                               subString:@"点击开通"
                                                                   color:[UIColor colorWithRGBHex:0x07A9FA]];
        } else {
            _creditBtn.valueLabel.attributedText = [self attributedString:[NSString stringWithFormat:@"%.2f 元",   creditCardInfo.availableCreditDoubleNum.floatValue]
                                                            subString:@"元"
                                                                color:[UIColor colorWithRGBHex:0x666666]];
        }
        
    }else {
        _userNameLabel.text = @"登录/注册";
        
        //优惠券
        _centsBtn.iconImageView.image = [UIImage imageNamed:@"ic_mycoupon"];
        //积分
        _commissionBtn.iconImageView.image = [UIImage imageNamed:@"ic_mine_commission"];
        //购物车
        _couponsBtn.iconImageView.image = [UIImage imageNamed:@"ic_mycoupon"];
        _creditBtn.iconImageView.image = [UIImage imageNamed:@"ic_mine_creditwallet"];
        [_personalPortraitImageView setImage:[UIImage imageNamed:@"img_headsculpture"]];
        
        _centsBtn.valueLabel.attributedText = nil;
        _centsBtn.valueLabel.text = nil;
        
        _commissionBtn.valueLabel.attributedText = nil;
        _commissionBtn.valueLabel.text = nil;
        
        _couponsBtn.valueLabel.attributedText = nil;
        _couponsBtn.valueLabel.text = nil;
        
        _creditBtn.valueLabel.attributedText = nil;
        _creditBtn.valueLabel.text = nil;
        
        // 签到
        _signButton.enabled = YES;
        [_signButton setTitle:@"签到" forState:UIControlStateNormal];
        _signButton.layer.borderColor = [UIColor colorWithR:255 G:255 B:255 A:1].CGColor;
        
        _dateCountLabel.hidden = YES;
        _dateCountLabelHeight.constant = 10;
        _signButton.hidden = YES;
    }
    
    [_centsBtn setNeedsLayout];
    [_commissionBtn setNeedsLayout];
    [_couponsBtn setNeedsLayout];
    [_creditBtn setNeedsLayout];
    
    
}

- (NSAttributedString *)attributedString:(NSString *)text subString:(NSString *)subText color:(UIColor *)textColor
{
    if (text.length <= 0 || subText.length <= 0) {
        return nil;
    }
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0],
                                                                                                                 NSForegroundColorAttributeName: [UIColor colorWithRGBHex:0xf54642]}];
    NSRange range = [text rangeOfString:subText];
    if ([subText isEqualToString:@"点击开通"]) {
        [attributeStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0],
                                      NSForegroundColorAttributeName: textColor} range:range];
    } else {        
        [attributeStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0],
                                      NSForegroundColorAttributeName: textColor} range:range];
    }
    
    return attributeStr;
}

- (NSNumber *)differDateCountBetweenDate1:(NSDate *)date1 date2:(NSDate *)date2{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2];
    [gregorian rangeOfUnit:NSDayCalendarUnit startDate:&date1 interval:NULL forDate:date1];
    [gregorian rangeOfUnit:NSDayCalendarUnit startDate:&date2 interval:NULL forDate:date2];
     NSDateComponents *dayComponents = [gregorian components:NSDayCalendarUnit fromDate:date1 toDate:date2 options:0];
    return @(dayComponents.day);
}

@end
