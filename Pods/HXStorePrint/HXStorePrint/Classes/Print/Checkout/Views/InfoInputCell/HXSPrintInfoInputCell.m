//
//  HXSInfoInputCell.m
//  store
//
//  Created by 格格 on 16/8/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintInfoInputCell.h"

@implementation HXSPrintInfoInputCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (instancetype)infoInputCell
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"HXStorePrint" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    return [bundle loadNibNamed:NSStringFromClass([HXSPrintInfoInputCell class])
                                         owner:nil options:nil].firstObject;
}

@end
