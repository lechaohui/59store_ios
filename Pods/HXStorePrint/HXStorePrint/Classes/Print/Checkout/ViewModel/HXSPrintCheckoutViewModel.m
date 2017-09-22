//
//  HXSPrintCheckoutViewModel.m
//  Pods
//
//  Created by J006 on 16/9/20.
//
//

#import "HXSPrintCheckoutViewModel.h"
#import "HXSDocumentPersistencyManger.h"
#import "HXSPrintDownloadsObjectEntity.h"

@interface HXSPrintCheckoutViewModel()

@end

@implementation HXSPrintCheckoutViewModel

- (BOOL)checkPrintListHasBlackWhitePrint:(NSArray<HXSMyPrintOrderItem *> *)array
{
    BOOL isWhiteBlackPrintForDoc = NO;
    if(!array
       || array.count == 0) {
        return isWhiteBlackPrintForDoc;
    }
    
    for (HXSMyPrintOrderItem *orderItem in array) {
        if(orderItem.printTypeIntNum == kHXSDocumentSetPrintTypeWhiteBlackSingle
           || orderItem.printTypeIntNum == kHXSDocumentSetPrintTypeWhiteBlackTwo) {
            isWhiteBlackPrintForDoc = YES;
            
            break;
        }
    }
    
    return isWhiteBlackPrintForDoc;
}

- (NSString *)getBuyNameFromShoppingAddress:(HXSPrintShoppingAddress *)shoppingAddress
{
    if(!shoppingAddress) {
        return nil;
    }
    
    return shoppingAddress.contactNameStr;
}

- (NSString *)getShoppingAddressFromShoppingAddress:(HXSPrintShoppingAddress *)shoppingAddress
{
    if(!shoppingAddress) {
        return nil;
    }
    
    NSString *detailAddressStr = [NSString stringWithFormat:@"%@%@%@%@",
                                  shoppingAddress.siteNameStr,
                                  shoppingAddress.dormentryZoneNameStr,
                                  shoppingAddress.dormentryNameStr,
                                  shoppingAddress.detailAddressStr];
    
    return detailAddressStr;
}

- (NSMutableArray<HXSMyPrintOrderItem *> *)checkLocalAndRefreshOrderItemFromLibStatus:(NSMutableArray<HXSMyPrintOrderItem *> *)array
{
    HXSDocumentPersistencyManger *persisManager = [[HXSDocumentPersistencyManger alloc]init];
    if(!array
       || array.count == 0) {
        return array;
    }
    
    [self checkPrintDocFileNameAndSetDocType:array];
    
    NSMutableArray *localArray = [persisManager loadTheSavedDocument];
    
    for (HXSMyPrintOrderItem *orderItem in array) {
        for (HXSPrintDownloadsObjectEntity *downLoadEntity in localArray) {
            if([orderItem.pdfMd5Str isEqualToString:downLoadEntity.uploadAndCartDocEntity.pdfMd5Str]) {
                orderItem.isFromLibraryDocumentNum = downLoadEntity.isFromLibraryDocumentNum ? [NSNumber numberWithBool:[downLoadEntity.isFromLibraryDocumentNum boolValue]] : nil;
                break;
            }
        }
    }
    
    return array;
}

- (NSMutableArray<HXSMyPrintOrderItem *> *)checkPrintDocFileNameAndSetDocType:(NSMutableArray<HXSMyPrintOrderItem *> *)array
{
    if(!array
       || array.count == 0) {
        return array;
    }
    
    for (HXSMyPrintOrderItem *orderItem in array) {
        NSString *fileNameStr = orderItem.fileNameStr;
        if([fileNameStr hasSuffix:@"doc"]
           || [fileNameStr hasSuffix:@"docx"]) {
            [orderItem setArchiveDocTypeNum:HXSDocumentTypeDoc];
        } else if([fileNameStr hasSuffix:@"pdf"]) {
            [orderItem setArchiveDocTypeNum:HXSDocumentTypePdf];
        } else if([fileNameStr hasSuffix:@"ppt"]
                  || [fileNameStr hasSuffix:@"pptx"]) {
            [orderItem setArchiveDocTypeNum:HXSDocumentTypePPT];
        } else {
            [orderItem setArchiveDocTypeNum:HXSDocumentTypePdf];
        }
    }
    
    return array;
}

@end
