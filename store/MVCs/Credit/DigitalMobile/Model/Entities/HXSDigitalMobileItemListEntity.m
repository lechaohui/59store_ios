//
//  HXSDigitalMobileItemListEntity.m
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileItemListEntity.h"

@implementation HXSDigitalMobileItemListEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"item_id",       @"itemIDIntNum",
                             @"image",         @"iamgeURLStr",
                             @"name",          @"nameStr",
                             @"low_price",     @"lowPriceFloatNum",
                             @"low_loan_price",@"lowLoanPriceFloatNum",
                             @"low_installment_num",@"lowInstallmentNumIntNum", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

+ (instancetype)createDigitalMobileItemListWithDic:(NSDictionary *)dic
{
    return [[HXSDigitalMobileItemListEntity alloc] initWithDictionary:dic error:nil];
}

@end
