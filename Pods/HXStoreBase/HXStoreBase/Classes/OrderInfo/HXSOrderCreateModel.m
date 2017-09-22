//
//  HXSOrderCreateModel.m
//  Pods
//
//  Created by ArthurWang on 16/9/12.
//
//

#import "HXSOrderCreateModel.h"

@implementation HXSOrderCreateItemModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"amount",            @"amountStr",
                         @"createTime",        @"createTimeStr",
                         @"image",             @"imageStr",
                         @"itemId",            @"itemIDStr",
                         @"name",              @"nameStr",
                         @"orderId",           @"orderIDStr",
                         @"price",             @"priceStr",
                         @"quantity",          @"quantityStr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:dic];
}

@end

@implementation HXSOrderCreateModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"create_time",       @"createTimeStr",
                         @"discount",          @"discountStr",
                         @"order_id",          @"orderIDStr",
                         @"order_type",        @"orderTypeStr",
                         @"pay_amount",        @"payAmountStr",
                         @"items",             @"itemsArr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:dic];
}

@end
