//
//  HXSPrintSettingEntity.m
//  store
//
//  Created by J006 on 16/3/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintSettingEntity.h"

@implementation HXSPrintSettingEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mappingPrint  = @{@"printNameStr":            @"name",
                                    @"printTypeNum":            @"type",
                                    @"unitPriceNum":            @"unit_price",
                                    @"pageSideTypeNum":         @"page_side",};
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mappingPrint];
}

@end

@implementation HXSPrintSettingReducedEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mappingReduce = @{@"reduceedNameStr":         @"name",
                                    @"reduceedTypeNum":         @"type",
                                    @"reduceedNum":             @"reduced",};
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mappingReduce];
}

@end
