//
//  HXSDigitalMobileSpecificationEntity.m
//  store
//
//  Created by ArthurWang on 16/3/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileSpecificationEntity.h"

@implementation HXSDigitalMobileSpecificationEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"item_id",           @"itemIDIntNum",
                             @"param",             @"paramHTMLStr",
                             @"picture_detail",    @"pictureDetailHTMLStr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

+ (instancetype)createSpecificationEntityWithDic:(NSDictionary *)dic
{
    HXSDigitalMobileSpecificationEntity *entity = [[HXSDigitalMobileSpecificationEntity alloc] initWithDictionary:dic error:nil];
    
    return entity;
}

@end
