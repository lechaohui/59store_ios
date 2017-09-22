//
//  HXDAddBankInforParamEntity.m
//  59dorm
//  录入银行卡信息
//  Created by J006 on 16/3/3.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXDAddBankInforParamEntity.h"

@implementation HXDAddBankInforParamEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mappingList = @{

                                  @"cardHolderNameStr":  @"cardholder_name",
                                  @"bankIdStr":          @"bank_id",
                                  @"bankNameStr":        @"bank_name",
                                  @"bankImageStr":       @"bank_image",
                                  @"cardNumberStr":      @"card_number",
                                  @"openLocationStr":    @"open_location",
                                  @"openAccountStr":     @"open_account",
                                  
                                  };
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mappingList];
}

@end
