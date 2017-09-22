//
//  HXSDigitalMobileCategoryListEntity.m
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileCategoryListEntity.h"

@implementation HXSDigitalMobileCategoryListEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"category_id",       @"categoryIDIntNum",
                             @"category_name",     @"categoryNameStr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

+ (instancetype)createDigitalMobileCategoryListWithDic:(NSDictionary *)categoriesDic
{
    return [[HXSDigitalMobileCategoryListEntity alloc] initWithDictionary:categoriesDic error:nil];
}

@end
