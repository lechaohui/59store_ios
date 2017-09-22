//
//  HXSMyFilesPrintViewModel.m
//  Pods
//
//  Created by J006 on 16/9/29.
//
//

#import "HXSMyFilesPrintViewModel.h"

//model
#import "HXSPrintDownloadsObjectEntity.h"
#import "HXSMyPrintOrderItem.h"

//others
#import "HXSPrintHeaderImport.h"

@implementation HXSMyFilesPrintViewModel

- (NSMutableArray<HXSMyPrintOrderItem *> *)checkSelectedEntityHasFilesFromLibrary:(NSMutableArray<HXSMyPrintOrderItem *> *)cartArray
                                                                            andVC:(UIViewController *)vc;
{
    if(!cartArray
       || cartArray.count == 0) {
        [MBProgressHUD showInViewWithoutIndicator:vc.view
                                           status:@"文库已有文档，不能重复上传"
                                       afterDelay:1.5];
        return nil;
    }
    
    NSMutableArray<HXSMyPrintOrderItem *> *currentArray = [cartArray mutableCopy];
    NSMutableArray<HXSMyPrintOrderItem *> *needToRemovedArray = [NSMutableArray array];
    
    for (HXSMyPrintOrderItem *item in currentArray) {
        if([item.isFromLibraryDocumentNum boolValue]) {
            item.isAddToCart = NO;
            [needToRemovedArray addObject:item];
        }
    }
    if(needToRemovedArray.count > 0) {
        [currentArray removeObjectsInArray:needToRemovedArray];
    }

    if(currentArray.count == 0) {
        [MBProgressHUD showInViewWithoutIndicator:vc.view
                                           status:@"文库已有文档，不能重复上传"
                                       afterDelay:1.5];
    }
    
    return currentArray;
}

- (void)checkTheICloudIsAvailableWithVC:(UIViewController *)vc
                               Complete:(void (^)())block;
{
    [MBProgressHUD showInView:vc.view];
    /**
     *  "Important: Do not call this method from your app’s main thread.
     *  Because this method might take a nontrivial amount of time to set up iCloud and return the requested URL, you should always call it from a secondary thread.
     *To determine if iCloud is available, especially at launch time, call the ubiquityIdentityToken method instead.
     *iCloud的检测很推荐放到一个线程中单独执行
     */
    //__weak typeof(vc) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *iCloudURL = [fileManager URLForUbiquityContainerIdentifier:nil];
        if(iCloudURL && [[UIDevice currentDevice].systemVersion floatValue] > 8.0f)
        {
            NSUbiquitousKeyValueStore *iCloudStore = [NSUbiquitousKeyValueStore defaultStore];
            [iCloudStore setString:@"Success" forKey:@"iCloudStatus"];
            [iCloudStore synchronize];
            DLog(@"iCloud status : %@", [iCloudStore stringForKey:@"iCloudStatus"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:vc.view animated:NO];
                block();
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:vc.view animated:NO];
                HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc]initWithTitle:@"提示"
                                                                                 message:@"请开启iCloudDrive并且保证iOS版本大于8.0~"
                                                                         leftButtonTitle:@"确定"
                                                                       rightButtonTitles:nil];
                [alertView show];
            });
        }
    });
}

- (HXSPrintCartEntity *)checkTheCartAndReturnTheEntityWithCartArray:(NSMutableArray<HXSMyPrintOrderItem *> *)cartArray
                                                          andShopID:(NSNumber *)shopIDIntNum;
{
    if(!cartArray) {
        return nil;
    }
    HXSPrintCartEntity *printCartEntity = [[HXSPrintCartEntity alloc]init];
    NSInteger totalPage = 0;
    double totalPrice = 0.00;
    for (HXSMyPrintOrderItem *orderItem in cartArray) {
        NSInteger pageIntNum  = [orderItem.pageIntNum integerValue];
        NSInteger quantityNum = [orderItem.quantityIntNum integerValue];
        NSInteger temptotalPageNums = pageIntNum * quantityNum;
        double tempPrice = [orderItem.amountDoubleNum doubleValue];
        totalPage  += temptotalPageNums;
        totalPrice += tempPrice;
    }
    printCartEntity.itemsArray = cartArray;
    NSNumber *totalPriceNumber = [[NSNumber alloc]initWithDouble:totalPrice];
    printCartEntity.totalAmountDoubleNum    = totalPriceNumber;//购物车中的打印总价
    printCartEntity.deliveryAmountDoubleNum = totalPriceNumber;
    printCartEntity.documentAmountDoubleNum = totalPriceNumber;
    printCartEntity.shopIdIntNum = shopIDIntNum;
    
    return printCartEntity;
}

@end
