//
//  HXSCreditCardLoanInfoModel.m
//  store
//
//  Created by ArthurWang on 16/7/22.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCreditCardLoanInfoModel.h"

@implementation HXSCreditCardLoanInfoModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"installment_all",       @"intallmentAllDoubleNum",
                             @"installment_number",    @"intallmentNumberIntNum",
                             @"installment_amount",    @"intallmentAmountDoubleNum",
                             @"installment_fee",       @"intallmentFeeDoubleNum",
                             @"installment_original_fee",  @"intallmentOriginalFeeDoubleNum",
                             @"installment_service_fee",   @"intallmentServiceFeeDoubleNum", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

+ (NSArray *)createCreditCardLoanInfoEntityArrWithArr:(NSArray *)arr
{
    return [HXSCreditCardLoanInfoModel arrayOfModelsFromDictionaries:arr error:nil];
}

@end
