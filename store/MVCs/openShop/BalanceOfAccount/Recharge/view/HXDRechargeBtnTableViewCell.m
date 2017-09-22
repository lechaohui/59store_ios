//
//  HXDRechargeBtnTableViewCell.m
//  59dorm
//
//  Created by wupei on 16/7/6.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXDRechargeBtnTableViewCell.h"

@implementation HXDRechargeBtnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.rechargeBtn.layer setCornerRadius:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
