//
//  HXSStoreAppEntryEntity.m
//  store
//
//  Created by ArthurWang on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSStoreAppEntryEntity.h"

@implementation HXSStoreAppEntryEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"id",            @"entryIDIntNum",
                             @"title",         @"titleStr",
                             @"titleColor",    @"title_color",
                             @"image",         @"imageURLStr",
                             @"image_width",   @"imageWidthIntNum",
                             @"image_height",  @"imageHeightIntNum",
                             @"link",          @"linkURLStr",
                             @"subtitle",      @"subtitleStr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

+ (instancetype)createStoreAppEntryEntityWithDic:(NSDictionary *)dic
{
    HXSStoreAppEntryEntity *entity = [[HXSStoreAppEntryEntity alloc] initWithDictionary:dic error:nil];
    
    
    return entity;
}

@end
