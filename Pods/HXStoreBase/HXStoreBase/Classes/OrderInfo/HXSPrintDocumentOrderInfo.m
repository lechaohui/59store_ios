//
//  HXSPrintDocumentOrderInfo.m
//  Pods
//
//  Created by J006 on 16/10/8.
//
//

#import "HXSPrintDocumentOrderInfo.h"

@implementation HXSPrintDocumentOrderInfo

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *itemMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"idStr",              @"id",
                                 @"uidStr",             @"uid",
                                 @"docIdStr",           @"docId",
                                 @"docTitleStr",        @"docTitle",
                                 @"amountDecNum",       @"amount",
                                 @"commissionDecNum",   @"commission",
                                 @"createTimeNum",      @"createTime",
                                 @"payTypeNum",         @"payType",
                                 @"tradeNoStr",         @"tradeNo",
                                 @"statusNum",          @"status",
                                 @"payTimeNum",         @"payTime",
                                 @"typeIdNum",          @"type",
                                 nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:itemMapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSPrintDocumentOrderInfo alloc] initWithDictionary:object error:nil];
}

- (void)setAmountDecNumWithNSNumber:(NSNumber *)number
{
    _amountDecNum = [NSDecimalNumber decimalNumberWithDecimal:number.decimalValue];
}

- (void)setAmountDecNumWithNSString:(NSString *)string
{
    _amountDecNum = [NSDecimalNumber decimalNumberWithString:string];
}

- (void)setCommissionDecNumWithNSNumber:(NSNumber *)number
{
    _commissionDecNum = [NSDecimalNumber decimalNumberWithDecimal:number.decimalValue];
}

- (void)setCommissionDecNumWithNSString:(NSString *)string
{
    _commissionDecNum = [NSDecimalNumber decimalNumberWithString:string];
}

@end
