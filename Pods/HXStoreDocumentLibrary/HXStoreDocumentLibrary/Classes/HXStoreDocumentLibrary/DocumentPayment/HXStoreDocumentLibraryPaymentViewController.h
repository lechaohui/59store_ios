//
//  HXStoreDocumentLibraryPaymentViewController.h
//  HXStoreDocumentLibrary_Example
//  文库支付界面
//  Created by J006 on 16/9/26.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

//model
#import "HXStoreDocumentLibraryDocumentModel.h"
#import "HXSOrderInfo.h"
#import "HXSMyPrintOrderItem.h"

typedef NS_ENUM(NSInteger,HXSPrintPaymentType){
    HXSPrintPaymentTypeDocPrint             = 0,//文档打印支付
    HXSPrintPaymentTypePicPrint             = 1,//照片打印支付
    HXSPrintPaymentTypeDocBuy               = 2,//文档购买
};

@protocol HXStoreDocumentLibraryPaymentViewControllerDelegate <NSObject>

@optional

/**
 *  购买成功与否代理
 *
 *  @param type
 *  @param isSuccess
 */
- (void)payFinishWithType:(HXSPrintPaymentType)type
               andSuccess:(BOOL)isSuccess;


@end

@interface HXStoreDocumentLibraryPaymentViewController : HXSBaseViewController

@property (nonatomic, weak) id<HXStoreDocumentLibraryPaymentViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray<HXSMyPrintOrderItem *> *cartArray;

/**
 *  设置支付信息
 *
 *  @param orderinfo 订单信息
 *  @param install 是否分期
 *  @param type 支付类型
 */
+ (instancetype)createPrintDocumentPaymentVCWithOrderInfo:(HXSOrderInfo *)orderInfo
                                              installment:(BOOL)installment
                                                  andType:(HXSPrintPaymentType)type;

@end
