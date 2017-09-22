//
//  HXStoreDocumentLibraryUploadDocShareParamModel.m
//  Pods
//
//  Created by J006 on 16/10/6.
//
//

#import "HXStoreDocumentLibraryUploadDocShareParamModel.h"

@implementation HXStoreDocumentLibraryUploadDocShareParamModel


- (NSMutableDictionary *)itemDictionary
{
    NSMutableDictionary *itemDictionary = [NSMutableDictionary dictionary];
    [itemDictionary setValue:self.docTypeNum forKey:@"docType"];
    [itemDictionary setValue:self.docTitleStr forKey:@"docTitle"];
    [itemDictionary setValue:self.docUrlStr forKey:@"docUrl"];
    [itemDictionary setValue:self.docMd5Str forKey:@"docMd5"];
    [itemDictionary setValue:self.tagsStr forKey:@"docTag"];
    [itemDictionary setValue:self.priceDecNum forKey:@"price"];

    return itemDictionary;
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
