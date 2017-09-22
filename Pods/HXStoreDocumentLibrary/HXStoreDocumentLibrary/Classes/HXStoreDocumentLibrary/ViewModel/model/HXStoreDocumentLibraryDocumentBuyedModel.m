//
//  HXStoreDocumentLibraryDocumentBuyedModel.m
//  Pods
//
//  Created by J006 on 16/9/29.
//
//

#import "HXStoreDocumentLibraryDocumentBuyedModel.h"

@implementation HXStoreDocumentLibraryDocumentBuyedModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *itemMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"docIdStr",                   @"doc_id",
                                 @"docTitleStr",                @"doc_title",
                                 @"priceDecNum",                @"price",
                                 @"docSuffixStr",               @"suffix",
                                 nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:itemMapping];    
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return  [[HXStoreDocumentLibraryDocumentBuyedModel alloc] initWithDictionary:object error:nil];
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
