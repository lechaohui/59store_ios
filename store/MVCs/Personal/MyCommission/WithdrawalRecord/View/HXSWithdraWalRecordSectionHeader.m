//
//  HXSWithdraWalRecordSectionHeader.m
//  store
//
//  Created by 格格 on 16/10/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSWithdraWalRecordSectionHeader.h"

@implementation HXSWithdraWalRecordSectionHeader

+ (instancetype)sectionHeader
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

@end
