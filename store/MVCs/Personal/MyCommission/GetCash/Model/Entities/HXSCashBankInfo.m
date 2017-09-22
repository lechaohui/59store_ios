//
//  HXSKnightInfo.m
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCashBankInfo.h"

@implementation HXSCashBankInfo

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{
                              @"bankUserNameStr":             @"bank_user_name",
                              @"bankCardNoStr":               @"bank_card_no",
                              @"bankCodeStr":                 @"bank_code",
                              @"bankCityStr":                 @"bank_city",
                              @"bankCardIdStr":               @"bank_card_id",
                              @"bankSiteStr":                 @"bank_site",
                              @"bankNameStr":                 @"bank_name",
                              @"bankIconStr":                 @"bank_icon"
                              };
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

+ (id)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSCashBankInfo alloc] initWithDictionary:object error:nil];
}

@end
