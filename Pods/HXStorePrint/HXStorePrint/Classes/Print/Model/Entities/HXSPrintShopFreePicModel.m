//
//  HXSPrintShopFreePicModel.m
//  Pods
//
//  Created by J006 on 16/10/19.
//
//

#import "HXSPrintShopFreePicModel.h"

@implementation HXSPrintShopFreePicModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"phoneStr",               @"phone",
                                 @"hasOpenedNum",           @"has_opend",
                                 @"urlStr",                 @"url",
                                 nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSPrintShopFreePicModel alloc] initWithDictionary:object error:nil];
}

@end
