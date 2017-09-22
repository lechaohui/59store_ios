//
//  HXSDigitalMobileDetailEntity.m
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileDetailEntity.h"

@implementation HXSDigitalMobileDetailCommentEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *commentMapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"id",             @"commentIDIntNum",
                                    @"user_name",      @"userNameStr",
                                    @"user_portrait",  @"userPortraitUrlStr",
                                    @"content",        @"contentStr",
                                    @"comment_time",   @"commentTimeIntNum",
                                    @"site_name",      @"siteNameStr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:commentMapping];
}

+ (instancetype)createCommentEntityWithDic:(NSDictionary *)dic
{
    return [[HXSDigitalMobileDetailCommentEntity alloc] initWithDictionary:dic error:nil];
}

@end

@implementation HXSDigitalMobileDetailPromotionEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *promotionMapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"image",    @"promotionImageURLStr",
                                      @"name",     @"promotionNameStr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:promotionMapping];
}

@end

@implementation HXSDigitalMobileDetailImageEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *imageMapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"url",  @"imageURLStr",
                                  @"id",   @"imageIDIntNum", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:imageMapping];
}

@end


@implementation HXSDigitalMobileDetailEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"name",                  @"nameStr",
                             @"item_id",               @"itemIDIntNum",
                             @"supplier",              @"supplierStr",
                             @"price",                 @"priceStr",
                             @"average_score",         @"averageScoreFloatNum",
                             @"introduction",          @"introductionHtmlStr",
                             @"images",                @"imagesArr",
                             @"promotions",            @"promotionsArr",
                             @"comments",              @"commentsArr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

+ (instancetype)createMobileDetailEntityWithDic:(NSDictionary *)dic
{
    return [[HXSDigitalMobileDetailEntity alloc] initWithDictionary:dic error:nil];
}


@end
