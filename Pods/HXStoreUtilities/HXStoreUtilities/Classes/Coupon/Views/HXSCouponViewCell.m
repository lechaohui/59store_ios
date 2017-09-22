//
//  HXSCouponViewCell.m
//  store
//
//  Created by 格格 on 16/5/27.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCouponViewCell.h"

#import "UIColor+Extensions.h"
#import "Color+Image.h"
#import "NSDate+Extension.h"

@interface HXSCouponViewCell ()

@property (nonatomic, weak) IBOutlet UIView  *containterView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *describeLabel;
@property (nonatomic, weak) IBOutlet UILabel *couponCodeLabel;
@property (nonatomic, weak) IBOutlet UILabel *effectiveTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *momeyLogoLabel;
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;

@property (nonatomic, weak) IBOutlet UIImageView *edgeImageView;
@property (nonatomic, weak) IBOutlet UIImageView *usedImageView;
@property (nonatomic, weak) IBOutlet UIImageView *decorateImageView;


@end

@implementation HXSCouponViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.amountLabel.adjustsFontSizeToFitWidth = YES;
    
    // 添加阴影
    self.containterView.layer.shadowOpacity = 0.5;
    self.containterView.layer.shadowColor = [UIColor colorWithR:0 G:0 B:0 A:0.4].CGColor;
    self.containterView.layer.shadowRadius = 2;
    self.containterView.layer.shadowOffset = CGSizeMake(0, 1);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)refresh
{
    [self titleLabelTextColorFitCouponStatus];
    
    [self describeLabelTextColorFitCouponStatus];
    
    [self momeyLogoLabelTextColorFitCouponStatus];
    
    [self amountLabelTextColorFitCouponStatus];
    
    [self edgeImageViewFitCouponStatus];
    
    [self usedImageViewFitCouponStatus];
    
    self.titleLabel.text = self.coupon.text;
    self.describeLabel.text = [NSString stringWithFormat:@"• %@",self.coupon.tip];
    self.couponCodeLabel.text = [NSString stringWithFormat:@"• 券号：%@",self.coupon.couponCode];
    
    NSString * amountStr =  [NSString stringWithFormat:@"￥%@",[self convertStringFromFloatNum:self.coupon.discount] ];
    NSMutableAttributedString *astr = [[NSMutableAttributedString alloc]initWithString:amountStr];
    [astr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];
    
    self.amountLabel.attributedText = astr;
    
    
    NSString *effectiveTimeStr = [NSString stringWithFormat:@"• %@至%@",[NSDate stringFromSecondsSince1970:self.coupon.activeTime.longLongValue format:@"YYYY-MM-dd"],[NSDate stringFromSecondsSince1970:self.coupon.expireTime.longLongValue format:@"YYYY-MM-dd"]];
    
    if (self.coupon.status.integerValue < HXSCouponStatusTypeWillOverdue) {
    
        self.effectiveTimeLabel.text = effectiveTimeStr;
        
    } else {
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:effectiveTimeStr];
        
        NSRange range = [effectiveTimeStr rangeOfString:[NSString stringWithFormat:@"至%@",[NSDate stringFromSecondsSince1970:self.coupon.expireTime.longLongValue format:@"YYYY-MM-dd"]]] ;
        
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithRGBHex:0xfa4d4d]
                                 range:NSMakeRange(range.location + 1, range.length - 1)];
        
        self.effectiveTimeLabel.attributedText = attributedString;
    
    }
}

- (void)titleLabelTextColorFitCouponStatus
{
    switch (self.coupon.status.intValue) {
        case HXSCouponStatusTypeNotStarted:
        case HXSCouponStatusTypeNormal:
        case HXSCouponStatusTypeWillOverdue:
        {
            self.titleLabel.textColor = [UIColor colorWithRGBHex:0x333333];
        }
            break;
        case HXSCouponStatusTypeUsed:
        case HXSCouponStatusTypeOverdue:
        {
            self.titleLabel.textColor = [UIColor colorWithRGBHex:0xcccccc];
        }
        default:
        {
            self.titleLabel.textColor = [UIColor colorWithRGBHex:0xcccccc];
        }
            break;
    }
}

- (void)describeLabelTextColorFitCouponStatus
{
    switch (self.coupon.status.intValue) {
        case HXSCouponStatusTypeNotStarted:
        case HXSCouponStatusTypeNormal:
        case HXSCouponStatusTypeWillOverdue:
        {
            self.describeLabel.textColor = [UIColor colorWithRGBHex:0x999999];
        }
            break;
        case HXSCouponStatusTypeUsed:
        case HXSCouponStatusTypeOverdue:
        {
            self.describeLabel.textColor = [UIColor colorWithRGBHex:0xcccccc];
        }
        default:
        {
            self.describeLabel.textColor = [UIColor colorWithRGBHex:0xcccccc];
        }
            break;
    }

}

- (void)momeyLogoLabelTextColorFitCouponStatus
{
    switch (self.coupon.status.intValue) {
        case HXSCouponStatusTypeNotStarted:
        case HXSCouponStatusTypeNormal:
        case HXSCouponStatusTypeWillOverdue:
        {
            self.momeyLogoLabel.textColor = [UIColor colorWithRGBHex:0xFF9500];
        }
            break;
        case HXSCouponStatusTypeUsed:
        case HXSCouponStatusTypeOverdue:
        {
            self.momeyLogoLabel.textColor = [UIColor colorWithRGBHex:0xcccccc];
        }
        default:
        {
            self.momeyLogoLabel.textColor = [UIColor colorWithRGBHex:0xcccccc];
        }
            break;
    }
}

- (void)amountLabelTextColorFitCouponStatus
{
    switch (self.coupon.status.intValue) {
        case HXSCouponStatusTypeNotStarted:
        case HXSCouponStatusTypeNormal:
        case HXSCouponStatusTypeWillOverdue:
        {
            self.amountLabel.textColor = [UIColor colorWithRGBHex:0xFF9500];
        }
            break;
        case HXSCouponStatusTypeUsed:
        case HXSCouponStatusTypeOverdue:
        {
            self.amountLabel.textColor = [UIColor colorWithRGBHex:0xcccccc];
        }
        default:
        {
            self.amountLabel.textColor = [UIColor colorWithRGBHex:0xcccccc];
        }
            break;
    }
}

- (void)edgeImageViewFitCouponStatus
{
    switch (self.coupon.status.intValue) {
        case HXSCouponStatusTypeNotStarted:
        case HXSCouponStatusTypeNormal:
        case HXSCouponStatusTypeWillOverdue:
        {
            [self.edgeImageView setImage:[UIImage imageNamed:@"youhuiquanab"]];
        }
            break;
        case HXSCouponStatusTypeUsed:
        case HXSCouponStatusTypeOverdue:
        {
            [self.edgeImageView setImage:[UIImage imageNamed:@"youhuiquanhui"]];
        }
        default:
        {
            [self.edgeImageView setImage:[UIImage imageNamed:@"youhuiquanhui"]];
        }
            break;
    }
}

- (void)usedImageViewFitCouponStatus
{
    switch (self.coupon.status.intValue) {
        case HXSCouponStatusTypeNotStarted:
        case HXSCouponStatusTypeNormal:
        case HXSCouponStatusTypeOverdue:
        case HXSCouponStatusTypeWillOverdue:
        {
            self.usedImageView.hidden = YES;
        }
            break;
        case HXSCouponStatusTypeUsed:
        {
            self.usedImageView.hidden = NO;
            
            break;
        }
        default:
        {
            self.usedImageView.hidden = YES;
        }
            break;
    }
}

- (void)decorateImageViewFitIndexPath
{
    switch (self.coupon.type) {
        case HXSCouponTypeCash:
        {
            [self.decorateImageView setImage:[UIImage imageNamed:@"Rectangle 2739"]];
        }
            break;
            
        case HXSCouponTypeMaterial:
        {
            [self.decorateImageView setImage:[UIImage imageNamed:@"youhuiquanad"]];
        }
            break;
            
        case HXSCouponTypeOther:
        {
            [self.decorateImageView setImage:[UIImage imageNamed:@"youhuiquanad"]];
        }
            break;
            
        default:
        {
            [self.decorateImageView setImage:[UIImage imageNamed:@"youhuiquanad"]];
        }
            break;
    }
}


- (void)setCoupon:(HXSCoupon *)coupon
{
    _coupon = coupon;
    
    [self refresh];

}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    [self decorateImageViewFitIndexPath];

}


- (NSString *)convertStringFromFloatNum:(NSNumber *)floatNum
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"0.00"];
    NSString *tempFloatStr = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:([floatNum floatValue] * 100)]];  // yuan to fen
    
    NSInteger tempInt = [tempFloatStr integerValue];
    
    NSInteger result = tempInt % 100;
    if (0 == result) {
        NSString *str = [NSString stringWithFormat:@"%zd", tempInt/100];
        
        return str;
    }
    
    result = tempInt % 10;
    if (0 == result) {
        NSString *str = [NSString stringWithFormat:@"%zd.%zd", tempInt/100, (tempInt % 100)/10];
        
        return str;
    }
    
    NSString *str = [NSString stringWithFormat:@"%zd.%zd%zd", tempInt/100, (tempInt % 100)/10, (tempInt % 100)%10];
    
    return str;
}



@end
