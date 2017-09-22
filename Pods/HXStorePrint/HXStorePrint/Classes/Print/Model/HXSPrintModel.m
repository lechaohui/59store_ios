//
//  HXSPrintModel.m
//  store
//
//  Created by 格格 on 16/3/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintModel.h"
#import "HXSPrintHeaderURLImport.h"

@implementation HXSPrintModel

// 云印店 订单列表
+ (void)getPrintOrderListWithPage:(int)page complete:(void (^)(HXSErrorCode code, NSString * message, NSArray * orders)) block{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:@(page) forKey:@"page"];
    [dic setObject:@(10) forKey:@"num_per_page"];
    [HXStoreWebService getRequest:HXS_PRINT_ORDER_LIST
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if(status == kHXSNoError) {
                           NSMutableArray * orders = [NSMutableArray array];
                           
                           if(DIC_HAS_ARRAY(data, @"orders")) {

                               for(NSDictionary * dic in [data objectForKey:@"orders"]) {
                                   if((NSNull *)dic == [NSNull null]) {
                                       continue;
                                   }
                                   HXSPrintOrderInfo *printOrderInfo = [HXSPrintOrderInfo objectFromJSONObject:dic];
                                   [orders addObject:printOrderInfo];
                               }
                           }
                           block(kHXSNoError, msg, orders);
                       } else {
                           block(status, msg, nil);
                       }
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

// 云印店 订单详情
+ (void)getPrintOrderDetialWithOrderSn:(NSString *)orderSn complete:(void (^)(HXSErrorCode code, NSString *message, HXSPrintOrderInfo *printOrder))block{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:orderSn forKey:@"order_sn"];
    
    [HXStoreWebService getRequest:HXS_PRINT_ORDER_INFO
                parameters:dic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        DLog(@"-------------- 云印店订单详情: %@",data);
        if(status == kHXSNoError) {
            
            HXSPrintOrderInfo *printOrderInfo = [HXSPrintOrderInfo objectFromJSONObject:data];
            block(kHXSNoError, msg, printOrderInfo);
        } else {
            block(status, msg, nil);
        }
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status, msg, nil);
    }];
}

// 云印店 取消订单
+ (void)cancelPrintOrderWithOrderSn:(NSString *)orderSn complete:(void(^)(HXSErrorCode code, NSString *message, NSDictionary *info))block{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:orderSn forKey:@"order_sn"];
    
    [HXStoreWebService postRequest:HXS_PRINT_ORDER_CANCEL
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        DLog(@"-------------- 云印店订单取消: %@",data);
                        block(status, msg, nil);
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
}

// 云印店 订单更改支付方式
+ (void)changePrintOrderPayType:(NSString *)orderSn
                      complete:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *info))block{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:orderSn forKey:@"order_sn"];
    
    [HXStoreWebService postRequest:@"drink/order/online2cash"
                 parameters:dic
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        DLog(@"-------------- 云印店修改订单支付类型: %@",data);
                        block(status, msg, nil);
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                        block(status, msg, nil);
                    }];
}

+ (void)createOrCalculatePrintOrderWithPrintCartEntity:(HXSPrintCartEntity *)printCartEntity
                                                shopId:(NSNumber *)shopid
                                                openAd:(NSNumber *)openAd
                                              complete:(void (^)(HXSErrorCode code, NSString *message, HXSPrintCartEntity *printCartEntity))block{
    
    NSMutableDictionary *prama = [NSMutableDictionary dictionaryWithDictionary:[printCartEntity printCartDictionary]];
    [prama setObject:shopid forKey:@"shop_id"];
    [prama setObject:openAd forKey:@"open_ad"];
    [HXStoreWebService postRequest:HXS_PRINT_CART_CREATE
                 parameters:prama
                   progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        DLog(@"------云印店计算订单价格 创建购物车 %@",data);
                        if(kHXSNoError == status){
                            HXSPrintCartEntity *cartEntity = [HXSPrintCartEntity objectFromJSONObject:data];
                            block(status,msg,cartEntity);
                        } else {
                            block(status,msg,nil);
                        }
                        
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        block(status,msg,nil);
                    }];
}

// 云印店 下单
+ (void)createPrintOrderWithParamModel:(HXSPrintCheckOutOrderParam *)paramModel
                              complete:(void (^)(HXSErrorCode code, NSString *message, HXSPrintOrderInfo *orderInfo))block
{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:[paramModel.printCartEntity printCartDictionary]];
    [param setObject:paramModel.phoneStr forKey:@"phone"];
    [param setObject:paramModel.addressStr forKey:@"address"];
    [param setObject:paramModel.remarkStr forKey:@"remark"];
    [param setObject:paramModel.payTypeNum forKey:@"pay_type"];
    [param setObject:paramModel.dormentryIdNum forKey:@"dormentry_id"];
    [param setObject:paramModel.shopIdNum forKey:@"shop_id"];
    [param setObject:paramModel.openAdNum forKey:@"open_ad"];
    [param setObject:@(3) forKey:@"source"];
    [param setObject:paramModel.buyNameStr forKey:@"buyer_name"];
    [param setObject:paramModel.cartFreeNum forKey:@"cart_free"];
    
    [HXStoreWebService postRequest:paramModel.apiStr
                        parameters:param
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data)
    {
        if(status == kHXSNoError) {
            
            HXSPrintOrderInfo *printOrderInfo = [HXSPrintOrderInfo objectFromJSONObject:data];
            
            block(kHXSNoError, msg, printOrderInfo);
            
        } else {
            block(status, msg, nil);
        }
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

- (NSURLSessionDataTask *)uploadTheDocument:(HXSPrintDownloadsObjectEntity *)entity
                 complete:(void (^)(HXSErrorCode code, NSString *message, HXSMyPrintOrderItem *orderItem))block
{
    NSMutableArray *formDataArray = [[NSMutableArray alloc]init];
    [formDataArray addObject:entity.fileData];
    [formDataArray addObject:[entity.archiveDocNameStr stringByDeletingPathExtension]];
    [formDataArray addObject:entity.archiveDocNameStr];
    [formDataArray addObject:entity.mimeTypeStr];
    
    NSURLSessionDataTask *task = [HXStoreWebService uploadRequest:HXS_PRINT_UPLOAD
                 parameters:nil
              formDataArray:formDataArray
                    progress:nil
                    success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        if (kHXSNoError != status) {
                            block(status, msg, nil);
                            return ;
                        }
                        HXSMyPrintOrderItem *orderItemEntitiy = [self createPrintOrderEntityWithData:data];
                        block(status, msg, orderItemEntitiy);
                    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                        block(status,msg,nil);
                    }];
    return task;
}

+ (NSArray<HXSMainPrintTypeEntity *> *)createTheMainPrintTypeArray
{
    HXSMainPrintTypeEntity *documentPrintTypeEntity = [[HXSMainPrintTypeEntity alloc]init];
    [documentPrintTypeEntity setTypeName:@"打印文档"];
    [documentPrintTypeEntity setImageName:@"img_print_dayinwendang"];
    [documentPrintTypeEntity setPrintType:kHXSMainPrintTypeDocument];
    
    HXSMainPrintTypeEntity *photoPrintTypeEntity = [[HXSMainPrintTypeEntity alloc]init];
    [photoPrintTypeEntity setTypeName:@"打印照片"];
    [photoPrintTypeEntity setImageName:@"img_print_dayinzhaopian"];
    [photoPrintTypeEntity setPrintType:kHXSMainPrintTypePhoto];
    
    HXSMainPrintTypeEntity *scanPrintTypeEntity = [[HXSMainPrintTypeEntity alloc]init];
    [scanPrintTypeEntity setTypeName:@"扫描"];
    [scanPrintTypeEntity setImageName:@"img_print_saomiao"];
    [scanPrintTypeEntity setPrintType:kHXSMainPrintTypeScan];
    
    HXSMainPrintTypeEntity *copyPrintTypeEntity = [[HXSMainPrintTypeEntity alloc]init];
    [copyPrintTypeEntity setTypeName:@"复印"];
    [copyPrintTypeEntity setImageName:@"img_print_fuyin"];
    [copyPrintTypeEntity setPrintType:kHXSMainPrintTypeCopy];
    
    NSArray *array = [NSArray arrayWithObjects:documentPrintTypeEntity,
                                              photoPrintTypeEntity,
                                              scanPrintTypeEntity,
                                              copyPrintTypeEntity,nil];
    
    return array;
}

+ (void)fetchShopInfoWithSiteId:(NSNumber *)siteIdIntNum
                       shopType:(NSNumber *)shopTypeNum
                    dormentryId:(NSNumber *)dormentryIdIntNum
                         shopId:(NSNumber *)shopIDIntNum
                       complete:(void (^)(HXSErrorCode status, NSString *message, HXSShopEntity *shopEntity))block;
{
    NSDictionary *paramsDic = @{
                                @"site_id":siteIdIntNum,
                                @"shop_type":shopTypeNum,
                                @"dormentry_id":dormentryIdIntNum,
                                @"shop_id":shopIDIntNum,
                                };
    
    [HXStoreWebService getRequest:HXS_SHOP_INFO
                       parameters:paramsDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(status, msg, nil);
                                  
                                  return ;
                              }
                              
                              HXSShopEntity *entity = [HXSShopEntity createShopEntiryWithData:data];
                              
                              block(status, msg, entity);
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status, msg, nil);
                          }];
}

+ (void)fetchStoreAppEntriesWithSiteId:(NSNumber *)siteIdIntNum
                                  type:(NSNumber *)typeIntNum
                              complete:(void (^)(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr))block
{
    NSDictionary *paramsDic = @{
                                @"site_id":     siteIdIntNum,
                                @"type":        typeIntNum,
                                };
    
    [HXStoreWebService getRequest:HXS_STORE_INLET
                       parameters:paramsDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(status, msg, nil);
                                  
                                  return ;
                              }
                              
                              NSMutableArray *resultMArr = [[NSMutableArray alloc] initWithCapacity:5];
                              
                              if (DIC_HAS_ARRAY(data, @"inlets")) {
                                  NSArray *entriesArr = [data objectForKey:@"inlets"];
                                  
                                  for (NSDictionary *dic in entriesArr) {
                                      HXSStoreAppEntryEntity *entity = [HXSStoreAppEntryEntity createStoreAppEntryEntityWithDic:dic];
                                      
                                      [resultMArr addObject:entity];
                                  }
                              }
                              
                              block(status, msg, resultMArr);
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status, msg, nil);
                          }];
}

+ (void)fetchShopListWithSiteId:(NSNumber *)siteIdIntNum
                      dormentry:(NSNumber *)dormentryIDIntNum
                           type:(NSNumber *)typeIntNum
                  crossBuilding:(NSNumber *)isCrossBuilding
                       complete:(void (^)(HXSErrorCode, NSString *, NSArray *))block
{
    NSDictionary *paramsDic = @{
                                @"site_id":         siteIdIntNum,
                                @"dormentry_id":    dormentryIDIntNum,
                                @"type":            typeIntNum,
                                @"cross_building":  isCrossBuilding
                                };
    
    
    [HXStoreWebService getRequest:HXS_SHOP_LIST
                       parameters:paramsDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(status, msg, nil);
                                  return ;
                              }
                              
                              if (DIC_HAS_ARRAY(data, @"shops")) {
                                  NSArray *shopsArr = [data objectForKey:@"shops"];
                                  
                                  NSMutableArray *shopsMArr = [[NSMutableArray alloc] initWithCapacity:5];
                                  
                                  for (NSDictionary *dic in shopsArr) {
                                      
                                      HXSShopEntity *entity = [HXSShopEntity createShopEntiryWithData:dic];
                                      
                                      [shopsMArr addObject:entity];
                                  }
                                  
                                  block(status, msg, shopsMArr);
                              } else {
                                  block(status, msg, nil);
                              }
                              
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                              block(status, msg, nil);
                          }];
    
}

+ (void)fetchPrintDormShopDetailWithShopId:(NSNumber *)shopIdIntNum
                                  complete:(void (^)(HXSErrorCode status, NSString *message, HXSPrintDormShopEntity *printDormShopEntity))block
{
    NSDictionary *paramsDic = @{
                                @"shopId":         shopIdIntNum
                                };
    
    [HXStoreWebService getRequest:HXS_PRINT_DORMSHOP_DETAIL
                       parameters:paramsDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(status, msg, nil);
                                  return ;
                              }
                              
                              HXSPrintDormShopEntity *entity = [HXSPrintDormShopEntity objectFromJSONObject:data];
                              
                              block(status, msg, entity);
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                              block(status, msg, nil);
                          }];
}

+ (void)fetchShoppingAddressComplete:(void (^)(HXSErrorCode code, NSString *message, NSArray *shoppingAddressArr))block
{
    [HXStoreWebService getRequest:HXS_PRINT_USERADDRESS_LIST
                       parameters:nil
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if(kHXSNoError == status) {
                                  NSArray *arr = [data objectForKey:@"list"];
                                  if(arr) {
                                      NSArray *resultArray = [HXSPrintShoppingAddress arrayOfModelsFromDictionaries:arr error:nil];
                                      block(status,msg,resultArray);
                                  } else {
                                      block(status,msg,nil);
                                  }
                              } else {
                                  block(status,msg,nil);
                              }
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status,msg,nil);
                          }];
}

+ (void)fetchPrintDormShopShareDocWithShopId:(NSNumber *)shopIdIntNum
                           andParamListModel:(HXSPrintListParamModel *)paramListModel
                                    complete:(void (^)(HXSErrorCode status, NSString *message, NSArray<HXStoreDocumentLibraryDocumentModel *> *array))block
{
    NSDictionary *paramsDic = @{
                                @"offset":          paramListModel.offset,
                                @"limit":           paramListModel.limit,
                                @"sort":            paramListModel.sort,
                                @"shop_id":         shopIdIntNum
                                };
    
    
    [HXStoreWebService getRequest:HXS_PRINT_DOCUMENT_SHARED
                       parameters:paramsDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(status, msg, nil);
                                  return ;
                              }
                              
                              if (DIC_HAS_ARRAY(data, @"doc")) {
                                  NSArray *docArr = [data objectForKey:@"doc"];
                                  
                                  NSMutableArray *array = [[NSMutableArray alloc] init];
                                  
                                  for (NSDictionary *dic in docArr) {
                                      
                                      HXStoreDocumentLibraryDocumentModel *model = [HXStoreDocumentLibraryDocumentModel objectFromJSONObject:dic];
                                      
                                      [array addObject:model];
                                  }
                                  
                                  block(status, msg, array);
                              } else {
                                  block(status, msg, nil);
                              }
                              
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                              block(status, msg, nil);
                          }];
}

+ (void)fetchShopFreePicWithShopId:(NSNumber *)shopIdIntNum
                          Complete:(void (^)(HXSErrorCode status, NSString *message, HXSPrintShopFreePicModel *model))block
{
    NSDictionary *paramsDic = @{
                                @"shopId":         shopIdIntNum
                                };
    
    
    [HXStoreWebService getRequest:HXS_PRINT_SHOP_FREE_PIC
                       parameters:paramsDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(status, msg, nil);
                                  return ;
                              }
                              HXSPrintShopFreePicModel *model = [HXSPrintShopFreePicModel objectFromJSONObject:data];
                              block(status, msg, model);
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                              block(status, msg, nil);
                          }];
}

+ (UIImage *)imageFromNewName:(NSString *)nameStr
{
    UIImage *image = [UIImage imageNamed:nameStr];
    
    if(!image)
    {
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
        {
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSString *bundlePath = [bundle pathForResource:@"HXStorePrint" ofType:@"bundle"];
            if (bundlePath) {
                bundle = [NSBundle bundleWithPath:bundlePath];
            }
            UIImage *imageNew = [UIImage imageNamed:nameStr
                                           inBundle:bundle
                      compatibleWithTraitCollection:nil];
            
            return imageNew;
        }
    }
    
    return image;
}

#pragma mark - private method

- (HXSMyPrintOrderItem *)createPrintOrderEntityWithData:(NSDictionary *)dic
{
    return [HXSMyPrintOrderItem objectFromJSONObject:dic];
}


@end
