//
//  HXSWithdrawRecode.m
//  store
//
//  Created by 格格 on 16/10/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSWithdrawRecode.h"

@implementation HXSWithdrawRecode

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{
                              @"moneyStr"     : @"money",
                              @"statusStr"    : @"status",
                              @"updateTimeStr": @"update_time"
                              };
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

@end
