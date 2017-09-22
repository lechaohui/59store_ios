//
//  HXSOrderCountdownCell.m
//  store
//
//  Created by 格格 on 16/9/2.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSOrderCountdownCell.h"

@implementation HXSOrderCountdownCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (instancetype)orderCountdownCell
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSOrderCountdownCell class])
                                         owner:nil options:nil].firstObject;
}

@end
