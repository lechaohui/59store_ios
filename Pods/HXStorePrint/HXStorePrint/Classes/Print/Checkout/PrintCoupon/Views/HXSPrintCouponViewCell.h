//
//  HXSPrintCouponViewCell.h
//  store
//
//  Created by J.006 on 16/8/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSPrintCouponViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *yuanLabel;
@property (nonatomic, weak) IBOutlet UILabel *discountLabel;
@property (nonatomic, weak) IBOutlet UILabel *materialLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *codeNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *codeLabel;
@property (nonatomic, weak) IBOutlet UILabel *expireTimeNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *expireTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *couponTipLabel;

@property (nonatomic, weak) IBOutlet UIImageView *imageImageView;
@property (nonatomic, weak) IBOutlet UIImageView *chooseImageView;


@end
