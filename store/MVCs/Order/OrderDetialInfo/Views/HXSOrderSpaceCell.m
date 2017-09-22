//
//  HXSOrderSpaceCell.m
//  store
//
//  Created by 格格 on 16/9/6.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSOrderSpaceCell.h"

@implementation HXSOrderSpaceCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (instancetype)orderSpaceCell
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

@end
