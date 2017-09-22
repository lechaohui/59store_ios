//
//  HXSMyPayBillDetailEntities.m
//  store
//
//  Created by J006 on 16/2/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyPayBillDetailEntity.h"

@implementation HXSMyPayBillDetailEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mappingPayBillDetail = @{@"textStr":               @"text",
                                           @"timeStrNum":            @"time",
                                           @"amountNum":             @"amount",
                                           @"typeNum":               @"type",
                                           @"urlStr":                @"image",};
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mappingPayBillDetail];
}

@end

@implementation HXSMyPayBillEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mappingPayBill = @{@"billIDNum":                  @"bill_id",
                                     @"billTimeNum":                @"bill_time",
                                     @"billAmountNum":              @"bill_amount",
                                     @"billStatusNum":              @"status",
                                     @"billServiceFeeDescStr":      @"service_fee_desc",
                                     @"installmentStatusNums":      @"installment_status",
                                     @"installmentAmountNum":       @"installment_amount",
                                     @"detailArr":                  @"bill_details",};
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mappingPayBill];
}

@end;

