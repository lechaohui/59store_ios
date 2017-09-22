//
//  HXSDigitalMobileParamEntity.m
//  store
//
//  Created by ArthurWang on 16/3/16.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileParamEntity.h"

@implementation HXSDigitalMobileParamSKUPropertyEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *skuPropertyMapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        @"property_id",        @"propertyIDIntNum",
                                        @"value_name",         @"valueNameStr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:skuPropertyMapping];
}

@end

@implementation HXSDigitalMobileParamSKUEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *skuMapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"sku_id",     @"skuIDIntNum",
                                @"name",       @"nameStr",
                                @"image",      @"skuImageURLStr",
                                @"price",      @"priceFloatNum",
                                @"integral",   @"integralFloatNum",
                                @"properties", @"propertiesArr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:skuMapping];
}

@end

@implementation HXSDigitalMobileParamPropertyValueEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *valueMapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"value_name",   @"valueNameStr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:valueMapping];
}

@end

@implementation HXSDigitalMobileParamPropertyEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *propertyMapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"property_id",       @"propertyIDIntNum",
                                     @"property_name",     @"propertyNameStr",
                                     @"values",            @"valuesArr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:propertyMapping];
}

@end


@implementation HXSDigitalMobileParamEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"available_properties",  @"availablePropertiesArr",
                             @"skus",                  @"skusArr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

+ (instancetype)createDigitailMobileParamEntityWithDic:(NSDictionary *)dic
{
    return [[HXSDigitalMobileParamEntity alloc] initWithDictionary:dic error:nil];
}

@end
