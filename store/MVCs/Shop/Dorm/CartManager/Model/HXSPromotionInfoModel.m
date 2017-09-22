//
//  HXSPromotionInfoModel.m
//  store
//
//  Created by ArthurWang on 16/9/8.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPromotionInfoModel.h"

@implementation HXSPromotionItemModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"rid",           @"ridStr",
                             @"item_id",       @"itemIdStr",
                             @"quantity",      @"quantityStr",
                             @"price",         @"priceDecNum",
                             @"origin_price",  @"originPriceStr",
                             @"amount",        @"amountStr",
                             @"name",          @"nameStr",
                             @"image_medium",  @"imageMediumStr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

- (void)setPriceDecNumWithNSNumber:(NSNumber *)number
{
   _priceDecNum = [NSDecimalNumber decimalNumberWithDecimal:number.decimalValue];
}

- (void)setPriceDecNumWithNSString:(NSString *)string
{
    _priceDecNum = [NSDecimalNumber decimalNumberWithString:string];
}

@end

@implementation HXSPromotionInfoModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"item_amount",       @"itemAmountDecNum",
                             @"origin_amount",     @"originAmountDecNum",
                             @"promotion_tip",     @"promotionTipAmountStr",
                             @"coupon_code",       @"couponCodeStr",
                             @"coupon_discount",   @"couponDiscountDecNum",
                             @"promotion_items",   @"promotionItemsArr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

- (void)setItemAmountDecNumWithNSNumber:(NSNumber *)number
{
    _itemAmountDecNum = [NSDecimalNumber decimalNumberWithDecimal:number.decimalValue];
}

- (void)setItemAmountDecNumWithNSString:(NSString *)string
{
    _itemAmountDecNum = [NSDecimalNumber decimalNumberWithString:string];
}

- (void)setOriginAmountDecNumWithNSNumber:(NSNumber *)number
{
    _originAmountDecNum = [NSDecimalNumber decimalNumberWithDecimal:number.decimalValue];
}

- (void)setOriginAmountDecNumWithNSString:(NSString *)string
{
    _originAmountDecNum = [NSDecimalNumber decimalNumberWithString:string];
}

- (void)setCouponDiscountDecNumWithNSNumber:(NSNumber *)number
{
    _couponDiscountDecNum = [NSDecimalNumber decimalNumberWithDecimal:number.decimalValue];
}

- (void)setCouponDiscountDecNumWithNSString:(NSString *)string
{
    _couponDiscountDecNum = [NSDecimalNumber decimalNumberWithString:string];
}


@end
