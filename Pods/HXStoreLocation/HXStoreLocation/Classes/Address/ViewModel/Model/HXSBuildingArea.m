//
//  HXSBuildingArea.m
//  Pods
//
//  Created by 格格 on 16/7/15.
//
//

#import "HXSBuildingArea.h"

#import "HXSBuildingEntity.h"
#import "HXStoreLocation.h"

@implementation HXSBuildingArea

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *areaDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"buildingsArr",       @"dormentries", nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:areaDic];
}


+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSBuildingArea alloc] initWithDictionary:object error:nil];
}


@end
