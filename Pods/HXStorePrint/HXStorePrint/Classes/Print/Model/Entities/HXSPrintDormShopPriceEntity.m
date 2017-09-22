//
//  HXSPrintDormShopPriceEntity.m
//  Pods
//
//  Created by J006 on 16/8/31.
//
//

#import "HXSPrintDormShopPriceEntity.h"

@implementation HXSPrintDormShopPriceEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *cartMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"nameStr",            @"name",
                                 @"idStr",              @"id",
                                 @"unitPriceNum",       @"unit_price",
                                 nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:cartMapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSPrintDormShopPriceEntity alloc] initWithDictionary:object error:nil];
}

@end
