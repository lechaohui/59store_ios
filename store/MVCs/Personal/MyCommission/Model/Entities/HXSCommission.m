//
//  HXSCommission.m
//  store
//
//  Created by 格格 on 16/10/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommission.h"

@implementation HXSCommission

+ (JSONKeyMapper *)keyMapper {
    
    NSDictionary *mapping = @{
                              @"amountWalletStr":@"amount_wallet",
                              @"incomeStr":@"income",
                              @"outlayStr":@"outlay",
                              @"itemsArr":@"items"
                              };
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

@end
