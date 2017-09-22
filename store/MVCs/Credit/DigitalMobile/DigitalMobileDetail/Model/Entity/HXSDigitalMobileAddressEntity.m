//
//  HXSDigitalMobileAddressEntity.m
//  store
//
//  Created by ArthurWang on 16/3/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileAddressEntity.h"


@implementation HXSDigitalMobileTownAddressEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"town_id",        @"townIDIntNum",
                             @"name",           @"townNameStr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

+ (NSArray *)createAddressTownWithTownArr:(NSArray *)townArr
{
    return [HXSDigitalMobileTownAddressEntity arrayOfModelsFromDictionaries:townArr error:nil];
}

@end

@implementation HXSDigitalMobileCountryAddressEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"country_id",        @"countryIDIntNum",
                             @"name",              @"countryNameStr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

+ (instancetype)createAddressCountryWithDic:(NSDictionary *)dic
{
    return [[HXSDigitalMobileCountryAddressEntity alloc] initWithDictionary:dic error:nil];
}

@end

@implementation HXSDigitalMobileCityAddressEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"city_id",       @"cityIDIntNum",
                             @"name",          @"cityNameStr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

+ (instancetype)createAddressCityWithDic:(NSDictionary *)dic
{
    return [[HXSDigitalMobileCityAddressEntity alloc] initWithDictionary:dic error:nil];
}

@end



@implementation HXSDigitalMobileAddressEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"province_id",       @"provinceIDIntNum",
                             @"name",              @"provinceNameStr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

+ (instancetype)createAddressProvinceWithDic:(NSDictionary *)dic
{
    return [[HXSDigitalMobileAddressEntity alloc] initWithDictionary:dic error:nil];
}

@end
