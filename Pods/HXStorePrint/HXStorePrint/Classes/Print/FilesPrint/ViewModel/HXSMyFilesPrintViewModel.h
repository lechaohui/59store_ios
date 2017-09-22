//
//  HXSMyFilesPrintViewModel.h
//  Pods
//
//  Created by J006 on 16/9/29.
//
//

#import <Foundation/Foundation.h>
#import "HXSMyPrintOrderItem.h"
#import "HXStoreDocumentLibraryDocumentModel.h"
#import "HXSPrintCartEntity.h"

@interface HXSMyFilesPrintViewModel : NSObject

/**
 *  检测选中的文件中是否有从文库中加入的并剔除
 */
- (NSMutableArray<HXSMyPrintOrderItem *> *)checkSelectedEntityHasFilesFromLibrary:(NSMutableArray<HXSMyPrintOrderItem *> *)cartArray
                                                                            andVC:(UIViewController *)vc;

/**
 *  检测iCloud是否可用
 */
- (void)checkTheICloudIsAvailableWithVC:(UIViewController *)vc
                               Complete:(void (^)())block;

/**
 *  检查并计算所有打印页面的总数和价格,返回一个购物车对象
 */
- (HXSPrintCartEntity *)checkTheCartAndReturnTheEntityWithCartArray:(NSMutableArray<HXSMyPrintOrderItem *> *)cartArray
                                                          andShopID:(NSNumber *)shopIDIntNum;
@end
