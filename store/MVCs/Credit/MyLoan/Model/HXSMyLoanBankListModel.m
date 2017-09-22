//
//  HXSMyLoanBankListModel.m
//  59dorm
//
//  Created by J006 on 16/7/21.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXSMyLoanBankListModel.h"

@implementation HXSMyLoanBankModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mappingBankModel= @{@"bankCode":  @"code",
                                      @"bankName":  @"name",
                                      @"bankImage": @"image",};
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mappingBankModel];
}

@end

@implementation HXSMyLoanBankListModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping= @{@"bankListArray":  @"list"};
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

@end
