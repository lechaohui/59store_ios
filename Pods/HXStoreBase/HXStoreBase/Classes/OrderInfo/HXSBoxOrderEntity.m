//
//  HXSBoxOrderEntity.m
//  store
//
//  Created by ArthurWang on 15/8/12.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBoxOrderEntity.h"

#import "HXMacrosEnum.h"
#import "NSString+HXSOrderPayType.h"

@implementation HXSBoxOrderItemEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *activityMappingDic = @{@"action":              @"action",
                                         @"title":               @"title",
                                         @"text":                @"text",
                                         @"url":                 @"url",
                                         @"imageUrl":            @"image_url",
                                         @"shareBtnImgUrl":      @"share_btn",};
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:activityMappingDic];
}

@end

@implementation HXSBoxOrderDiscountEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *discountMappingDic = @{@"discountTitleStr": @"discount_title",
                                         @"discountFloatNum": @"discount",};
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:discountMappingDic];
}

@end


@implementation HXSBoxOrderEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mappingDic = @{@"boxID":                           @"box_id",
                                 @"boxCodeStr":                      @"box_code",
                                 @"payType":                         @"pay_type",
                                 @"refundStatusCodeIntNum":          @"refund_status_code",
                                 @"refundStatusMsgStr":              @"refund_status_msg",
                                 @"dormID":                          @"dorm_id",
                                 @"totalDiscount":                   @"total_discount",
                                 @"foodAmount":                      @"food_amount",
                                 @"foodNum":                         @"food_num",
                                 @"orderAmount":                     @"order_amount",
                                 @"orderID":                         @"order_id",
                                 @"createTime":                      @"create_time",
                                 @"cancelTime":                      @"cancel_time",
                                 @"remarkStr":                       @"reamrk",
                                 @"orderSNStr":                      @"order_sn",
                                 @"UID":                             @"uid",
                                 @"ipStr":                           @"ip",
                                 @"tips":                            @"tips",
                                 @"attachStr":                       @"attach",
                                 @"itemsArr":                        @"items",
                                 @"discountArr":                     @"discount_info",
                                 @"activityInfos":                   @"activities",};
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mappingDic];
}

+ (instancetype)createBoxOrderEntityWithDic:(NSDictionary *)boxOrderDic
{
    HXSBoxOrderEntity *entity = [[HXSBoxOrderEntity alloc] initWithDictionary:boxOrderDic error:nil];
    
    return entity;
}

+ (NSArray *)createBoxOrderArrWithArr:(NSArray *)boxOrderArr 
{
    NSArray *entitiesArr = [HXSBoxOrderEntity arrayOfModelsFromDictionaries:boxOrderArr error:nil];
    
    return entitiesArr;
}

- (NSString *)getStatus
{
    
    switch ([self.status intValue]) {
        case kHSXBoxOrderStatusUnpay: // 订单等待支付
        {
            return @"未支付";
        }
            break;
            
        case kHXSBoxOrderStatusPayed: // 订单已完成
        {
            return @"已完成";
        }
            break;
            
        case kHXSBoxOrderStatusCanceled: // 订单取消
        {
            return @"已取消";
        }
            break;
            
        default:
            break;
    }
    
    return @"未知状态";
}

- (NSString *)getPayType
{
    if (0.0 >= [self.orderAmount floatValue]) {
        return @"无";
    }
    
    return [NSString payTypeStringWithPayType:[self.payType intValue]];
}

@end
