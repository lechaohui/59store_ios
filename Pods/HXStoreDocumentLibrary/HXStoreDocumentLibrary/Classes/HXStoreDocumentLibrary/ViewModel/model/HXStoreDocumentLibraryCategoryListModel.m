//
//  HXStoreDocumentLibraryCategoryListModel.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/7.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibraryCategoryListModel.h"

@implementation HXStoreDocumentLibraryCategoryModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *itemMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"categoryIdNum",           @"category_id",
                                 @"parentIdNum",             @"parent_id",
                                 @"categoryNameStr",         @"category_name",
                                 @"categoryImageStr",        @"category_image",
                                 @"categoryBannerImageStr",  @"category_banner_image",
                                 @"isShowNum",               @"is_show",
                                 @"isRecommendedNum",        @"is_recommended",
                                 @"createTimeStr",           @"create_time",
                                 @"sortNum",                 @"sort",
                                 @"subscribeCountNum",       @"subscribe_count",
                                 @"docCountNum",             @"doc_count",
                                 @"starCountNum",            @"star_count",
                                 @"scoreAverageNum",         @"score_average",
                                 @"readCountNum",            @"read_count",
                                 nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:itemMapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return  [[HXStoreDocumentLibraryCategoryModel alloc] initWithDictionary:object error:nil];
}

@end

@implementation HXStoreDocumentLibraryCategoryListModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *itemMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"categoryIdNum",           @"category_id",
                                 @"parentIdNum",             @"parent_id",
                                 @"categoryNameStr",         @"category_name",
                                 @"categoryImageStr",        @"category_image",
                                 @"categoryBannerImageStr",  @"category_banner_image",
                                 @"isShowNum",               @"is_show",
                                 @"isRecommendedNum",        @"is_recommended",
                                 @"createTimeStr",           @"create_time",
                                 @"sortNum",                 @"sort",
                                 @"subscribeCountNum",       @"subscribe_count",
                                 @"docCountNum",             @"doc_count",
                                 @"starCountNum",            @"star_count",
                                 @"scoreAverageNum",         @"score_average",
                                 @"readCountNum",            @"read_count",
                                 @"categoryArray",           @"category",
                                 nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:itemMapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return  [[HXStoreDocumentLibraryCategoryListModel alloc] initWithDictionary:object error:nil];
}

@end
