//
//  HXSShopLocationCell.m
//  store
//
//  Created by 格格 on 16/9/29.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSShopLocationCell.h"

@implementation HXSShopLocationCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.locationShowLabel.layer.cornerRadius  = 15;
    self.locationShowLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
