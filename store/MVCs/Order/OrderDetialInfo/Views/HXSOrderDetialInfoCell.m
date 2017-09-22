//
//  HXSOrderDetialInfoCell.m
//  store
//
//  Created by 格格 on 16/9/6.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSOrderDetialInfoCell.h"

@interface HXSOrderDetialInfoCell ()

@property (nonatomic, weak) IBOutlet UILabel *showLabel;

@end

@implementation HXSOrderDetialInfoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.showLabel.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (instancetype)orderDetialInfoCell
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

- (void)setShowStr:(NSString *)showStr
{
    _showStr = showStr;
    self.showLabel.text = showStr;
}

@end
