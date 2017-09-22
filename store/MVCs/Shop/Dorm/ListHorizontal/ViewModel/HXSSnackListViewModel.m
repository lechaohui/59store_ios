//
//  HXSSnackViewModel.m
//  store
//
//  Created by  黎明 on 16/8/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSSnackListViewModel.h"

#import "HXSDormItem.h"

@implementation HXSSnackListViewModel

+ (void)fechCategoryListWith:(NSNumber *)shopId
                    shopType:(NSNumber *)shopType
                    complete:(void (^)(HXSErrorCode status, NSString *message,
                                       HXSSnacksCategoryModelSet *snacksCategoryModelSet))block
{
    if (shopId == nil || shopType == nil)
    {
        block(kHXSParamError, @"参数错误", nil);
        return;
    }
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:shopId forKey:@"shop_id"];
    [dict setValue:shopType forKey:@"shop_type"];
    
    [HXStoreWebService getRequest:HXS_SHOP_CATEGORY
                       parameters:dict
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if(kHXSNoError != status) {
                                  block(status, msg, nil);
                                  
                                  return ;
                              }
                              
                              HXSSnacksCategoryModelSet *snacksCategoryModelSet = [[HXSSnacksCategoryModelSet alloc] initWithDictionary:data error:nil];
                              
                              block(status, msg, snacksCategoryModelSet);
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status, msg, nil);
                          }];
}


+ (void)fetchGoodsCategoryListWith:(NSNumber *)categoryId
                            shopId:(NSNumber *)shopId
                      categoryType:(NSNumber *)type
                          starPage:(NSNumber *)page
                        numPerPage:(NSNumber *)num_per_page
                          complete:(void (^)(HXSErrorCode status, NSString *message, NSArray *slideArr))block
{
    if (nil == categoryId) {
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:categoryId   forKey:@"category_id"];
    [dict setValue:shopId       forKey:@"shop_id"];
    [dict setValue:page         forKey:@"page"];
    [dict setValue:num_per_page forKey:@"num_per_page"];
    [dict setValue:type         forKey:@"category_type"];
    
    [HXStoreWebService getRequest:HXS_SHOP_ITEMS
                       parameters:dict
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              
                              if(status == kHXSNoError) {
                                  
                                  NSMutableArray * cates = [NSMutableArray array];
                                  if(DIC_HAS_ARRAY(data, @"items")) {
                                      for(NSDictionary * dic in [data objectForKey:@"items"]) {
                                          if((NSNull *)dic == [NSNull null]) {
                                              continue;
                                          }
                                          HXSDormItem * item = [[HXSDormItem alloc] initWithDictionary:dic];
                                          if(item) {
                                              [cates addObject:item];
                                          }
                                      }
                                  }
                                  
                                  block(kHXSNoError, msg, cates);
                                  
                              }}
                          failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status, msg, nil);
                          }];
}

@end
