//
//  HXSShoppingAddress.m
//  store
//
//  Created by 格格 on 16/8/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintShoppingAddress.h"

@implementation HXSPrintShoppingAddress

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{
                              @"id"             : @"idStr",
                              @"contact_name"   : @"contactNameStr",
                              @"contact_phone"  : @"contactPhoneStr",
                              @"gender"         : @"genderStr",
                              @"province_id"    : @"provinceIdStr",
                              @"province_name"  : @"provinceNameStr",
                              @"city_id"        : @"cityIdStr",
                              @"city_name"      : @"cityNameStr",
                              @"zone_id"        : @"zoneIdStr",
                              @"zone_name"      : @"zoneNameStr",
                              @"site_id"        : @"siteIdStr",
                              @"site_name"      : @"siteNameStr",
                              @"dormentry_zone_name" : @"dormentryZoneNameStr",
                              @"dormentry_id"   : @"dormentryIdStr",
                              @"dormentry_name" : @"dormentryNameStr",
                              @"phone"          : @"phoneStr",
                              @"detail_address" : @"detailAddressStr",
                              };
    return [[JSONKeyMapper alloc]initWithDictionary:mapping];
}


@end
