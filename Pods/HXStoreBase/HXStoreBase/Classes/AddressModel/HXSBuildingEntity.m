//
//  HXSBuildingEntity.m
//  store
//
//  Created by ArthurWang on 15/9/1.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBuildingEntity.h"

@implementation HXSBuildingShopEntity

+ (JSONKeyMapper*)keyMapper
{
    NSDictionary *shopsMapping = @{@"shopTypeIntNum":    @"shop_type",
                                   @"shopStatusIntNum":  @"status",};
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:shopsMapping];
}

@end


@implementation HXSBuildingNameEntity

+ (JSONKeyMapper*)keyMapper
{
    NSDictionary *buildingNameMapping = @{@"buildingNameStr":    @"name",
                                          @"dormentryIDIntNum":  @"dormentry_id",
                                          @"shopsArr":           @"shops",};
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:buildingNameMapping];
}

@end


@implementation HXSBuildingEntity

+ (NSArray *)createBuildingEntityWithGroupsArr:(NSArray *)groupsArr
{
    return [HXSBuildingEntity arrayOfModelsFromDictionaries:groupsArr error:nil];
}

+ (JSONKeyMapper*)keyMapper
{
    NSDictionary *nameMapping = @{@"nameStr":        @"name",
                                  @"buildingsArr":   @"dormentries",};
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:nameMapping];
}

@end
