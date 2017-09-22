//
//  HXSPrintModel.h
//  store
//
//  Created by 格格 on 16/3/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

// Model
#import "HXSMyPrintOrderItem.h"
#import "HXSPrintCartEntity.h"
#import "HXSPrintOrderInfo.h"
#import "HXSPrintDownloadsObjectEntity.h"
#import "HXSMainPrintTypeEntity.h"
#import "HXSStoreAppEntryEntity.h"
#import "HXSPrintDormShopEntity.h"
#import "HXSPrintShoppingAddress.h"
#import "HXSPrintCheckOutOrderParam.h"
#import "HXSPrintListParamModel.h"
#import "HXStoreDocumentLibraryDocumentModel.h"
#import "HXSPrintShopFreePicModel.h"

@interface HXSPrintModel : NSObject

/**
 * 云印店 订单列表
 */
+ (void)getPrintOrderListWithPage:(int)page
                         complete:(void (^)(HXSErrorCode code, NSString * message, NSArray * orders)) block;

/** 
 * 云印店 订单详情
 */
+ (void)getPrintOrderDetialWithOrderSn:(NSString *)orderSn
                              complete:(void (^)(HXSErrorCode code, NSString *message, HXSPrintOrderInfo *printOrder))block;

/**
 * 云印店 取消订单
 */
+ (void)cancelPrintOrderWithOrderSn:(NSString *)orderSn
                           complete:(void(^)(HXSErrorCode code, NSString *message, NSDictionary *info))block;

/** 
 * 云印店 订单更改支付方式
 */
+ (void)changePrintOrderPayType:(NSString *)orderSn
                       complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *info))block;


/**
 *  云印店 计算订单价格 创建购物车
 *
 *  @param printCartEntity  购物车实体
 *  @param shopid           店铺id
 *  @param openAd           是否使用福利纸
 *  @param block
 */
+ (void)createOrCalculatePrintOrderWithPrintCartEntity:(HXSPrintCartEntity *)printCartEntity
                                                shopId:(NSNumber *)shopid
                                                openAd:(NSNumber *)openAd
                                              complete:(void (^)(HXSErrorCode code, NSString *message, HXSPrintCartEntity *printCartEntity))block;

/**
 *  云印店 下单
 */
+ (void)createPrintOrderWithParamModel:(HXSPrintCheckOutOrderParam *)paramModel
                              complete:(void (^)(HXSErrorCode code, NSString *message, HXSPrintOrderInfo *orderInfo))block;

/**
 *  上传文档
 *
 *  @param entity
 *  @param block
 */
- (NSURLSessionDataTask *)uploadTheDocument:(HXSPrintDownloadsObjectEntity *)entity
                                   complete:(void (^)(HXSErrorCode code, NSString *message, HXSMyPrintOrderItem *orderItem))block;

/**
 *  设置打印主界面中所有支持的打印类型集合
 *
 *  @return
 */
+ (NSArray<HXSMainPrintTypeEntity *> *)createTheMainPrintTypeArray;

/**
 *  店铺详情
 *
 *  @param siteIdIntNum      学校id
 *  @param dormentryIdIntNum 楼栋id
 *  @param shopIDIntNum      店铺id
 *  @param block             返回的结果
 */
+ (void)fetchShopInfoWithSiteId:(NSNumber *)siteIdIntNum
                       shopType:(NSNumber *)shopTypeNum
                    dormentryId:(NSNumber *)dormentryIdIntNum
                         shopId:(NSNumber *)shopIDIntNum
                       complete:(void (^)(HXSErrorCode status, NSString *message, HXSShopEntity *shopEntity))block;

/**
 *  获取店铺首页的入口
 *
 *  @param siteIdIntNum      学校id
 *  @param typeIntNum        0- 店铺首页轮播 1-首页的店铺入口列表
 *  @param block      返回的结果
 */
+ (void)fetchStoreAppEntriesWithSiteId:(NSNumber *)siteIdIntNum
                                  type:(NSNumber *)typeIntNum
                              complete:(void (^)(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr))block;

/**
 *  店铺列表
 *
 *  @param siteIdIntNum      学校id
 *  @param dormentryIDIntNum 楼栋id
 *  @param type              0夜猫店 1饮品店 2打印店 3云超市 4水果店 99表示全部
 *  @param isCrossBuilding   0不跨楼栋，居住在本楼的所有店铺 1支持跨楼栋的店铺，配送到本楼的店铺
 *  @param block             返回的结果
 */

+ (void)fetchShopListWithSiteId:(NSNumber *)siteIdIntNum
                      dormentry:(NSNumber *)dormentryIDIntNum
                           type:(NSNumber *)typeIntNum
                  crossBuilding:(NSNumber *)isCrossBuilding
                       complete:(void (^)(HXSErrorCode status, NSString *message, NSArray *shopsArr))block;

/**
 *  获取打印店铺信息
 *
 *  @param shopIdIntNum 店铺id
 *  @param block
 */
+ (void)fetchPrintDormShopDetailWithShopId:(NSNumber *)shopIdIntNum
                                  complete:(void (^)(HXSErrorCode status, NSString *message, HXSPrintDormShopEntity *printDormShopEntity))block;

/**
 * 获取收货地址
 */
+ (void)fetchShoppingAddressComplete:(void (^)(HXSErrorCode code, NSString * message, NSArray *shoppingAddressArr))block;

/**
 *  获取店长私藏
 *
 *  @param shopIdIntNum 店铺id
 *  @param block
 */
+ (void)fetchPrintDormShopShareDocWithShopId:(NSNumber *)shopIdIntNum
                           andParamListModel:(HXSPrintListParamModel *)paramListModel
                                    complete:(void (^)(HXSErrorCode status, NSString *message, NSArray<HXStoreDocumentLibraryDocumentModel *> *array))block;

/**
 *  读取图片名称
 *
 *  @param nameStr
 *
 *  @return
 */
+ (UIImage *)imageFromNewName:(NSString *)nameStr;

/**
 *  免费照片打印信息接口
 *
 *  @param shopIdIntNum 店铺id
 *  @param block
 */
+ (void)fetchShopFreePicWithShopId:(NSNumber *)shopIdIntNum
                          Complete:(void (^)(HXSErrorCode status, NSString *message, HXSPrintShopFreePicModel *model))block;

@end
