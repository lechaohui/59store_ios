//
//  HXStoreDocumentLibraryPaymentResultViewController.h
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/27.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSMyPrintOrderItem.h"
#import "HXSOrderInfo.h"

@interface HXStoreDocumentLibraryPaymentResultViewController : HXSBaseViewController

+ (instancetype)createDocumentLibraryPaymentResultVCWithArray:(NSMutableArray<HXSMyPrintOrderItem *> *)array
                                                 andOrderInfo:(HXSOrderInfo *)orderInfo;

@end
