//
//  HXSPrintDormShopEntity.m
//  Pods
//
//  Created by J006 on 16/8/31.
//
//

#import "HXSPrintDormShopEntity.h"

@implementation HXSPrintDormShopEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *cartMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"shopIdNum",                          @"shop_id",
                                 @"shopNameStr",                        @"shop_name",
                                 @"shopLogoStr",                        @"shop_logo",
                                 @"shopNoticeStr",                      @"shop_notice",
                                 @"businessStatusNum",                  @"business_status",
                                 @"crossBuildingDistSwitchNum",         @"cross_building_dist_switch",
                                 @"freeshipAmountNum",                  @"freeship_amount",
                                 @"dormShopPricesArry",                 @"dorm_shop_prices",
                                 nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:cartMapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSPrintDormShopEntity alloc] initWithDictionary:object error:nil];
}

@end
