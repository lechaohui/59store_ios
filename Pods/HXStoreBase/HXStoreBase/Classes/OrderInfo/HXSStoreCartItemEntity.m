//
//  HXSStoreCartItemEntity.m
//  store
//
//  Created by BeyondChao on 16/4/21.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSStoreCartItemEntity.h"

@implementation HXSStoreCartItemEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *itemMapping = @{@"amountNum":          @"amount",
                                  @"imageUrlStr":        @"image",
                                  @"itemIdNum":          @"id",
                                  @"nameStr":            @"name",
                                  @"priceNum":           @"price",
                                  @"quantityNum":        @"quantity",
                                  @"originPriceNum":     @"origin_price",};
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:itemMapping];
}

@end
