//
//  HXSPrintCheckoutViewModel.h
//  Pods
//
//  Created by J006 on 16/9/20.
//
//

#import <Foundation/Foundation.h>
#import "HXSMyPrintOrderItem.h"
#import "HXSPrintShoppingAddress.h"

@interface HXSPrintCheckoutViewModel : NSObject

/**
 *  检测打印列表里是否有黑白打印
 */
- (BOOL)checkPrintListHasBlackWhitePrint:(NSArray<HXSMyPrintOrderItem *> *)array;

/**
 *  获取收货地址的收货人
 */
- (NSString *)getBuyNameFromShoppingAddress:(HXSPrintShoppingAddress *)shoppingAddress;
/**
 *  获取收货地址的收货地址
 */
- (NSString *)getShoppingAddressFromShoppingAddress:(HXSPrintShoppingAddress *)shoppingAddress;

/**
 *  根据本地的文档检测是否属于文库
 */
- (NSMutableArray<HXSMyPrintOrderItem *> *)checkLocalAndRefreshOrderItemFromLibStatus:(NSMutableArray<HXSMyPrintOrderItem *> *)array;

/**
 *  根据文档名称的后缀来获取文档类型
 */
- (NSMutableArray<HXSMyPrintOrderItem *> *)checkPrintDocFileNameAndSetDocType:(NSMutableArray<HXSMyPrintOrderItem *> *)array;

@end
