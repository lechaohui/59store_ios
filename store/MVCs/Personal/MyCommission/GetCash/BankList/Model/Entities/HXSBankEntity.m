//
//  HXSBankEntity.m
//  store
//
//  Created by 格格 on 16/5/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBankEntity.h"

@implementation HXSBankEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{
                              @"codeStr":@"bank_code",
                              @"nameStr":@"bank_name",
                              @"imageStr":@"bank_icon",};
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSBankEntity alloc] initWithDictionary:object error:nil];
}

@end
