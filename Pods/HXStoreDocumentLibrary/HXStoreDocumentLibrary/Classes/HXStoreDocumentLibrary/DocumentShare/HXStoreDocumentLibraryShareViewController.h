//
//  HXStoreDocumentLibraryShareViewController.h
//  HXStoreDocumentLibrary_Example
//  文档分享
//  Created by J006 on 16/9/27.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSMyPrintOrderItem.h"

@interface HXStoreDocumentLibraryShareViewController : HXSBaseViewController

+ (instancetype)createDocumentLibraryShareVCWithArray:(NSMutableArray<HXSMyPrintOrderItem *> *)array;

@end
