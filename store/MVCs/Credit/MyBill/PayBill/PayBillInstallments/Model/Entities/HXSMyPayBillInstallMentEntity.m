//
//  HXSMyPayBillInstallMentEntity.m
//  store
//
//  Created by J006 on 16/2/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyPayBillInstallMentEntity.h"

@implementation HXSMyPayBillInstallMentEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mappingList = @{
                                  @"monthlyPaymentsNum":            @"monthly_payments",
                                  @"installmentNum":                @"installment_number",
                                  @"billAmountNum":                 @"bill_amount",
                                  @"firstDateStr":                  @"first_date",
                                  @"endDateStr":                    @"end_date",
                                  };
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mappingList];
}

@end
