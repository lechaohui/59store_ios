//
//  HXSDormCartManager.h
//  store
//
//  Created by chsasaw on 14/11/27.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSDormItem.h"
#import "HXSPromotionInfoModel.h"

@interface HXSDormCartManager : NSObject

@property (nonatomic, strong) NSArray *cartItemsArr;

@property (nonatomic, strong) HXSPromotionInfoModel *promotionInfoModel;

+ (HXSDormCartManager *)sharedManager;

- (HXSDormItem *)findItemInCartWithDormItem:(HXSDormItem *)dormItem;

- (void)updateItem:(HXSDormItem *)dormItem quantity:(int)quantity;

- (void)clearCart;

/**
 *  获取总优惠
 *
 *  @param couponCodeStr 优惠券码
 *  @param items         购买的商品列表 （说明： 格式： json数组， [{"product_id": "商品id", "quantity": 购买商品数量}]）
 *  @param block         返回Block
 */
- (void)fetchPromtionCountInfoWithCouponCode:(NSString *)couponCodeStr
                                       items:(NSArray *)itemsArr
                                    complete:(void (^)(HXSErrorCode code, NSString *message, HXSPromotionInfoModel *promotionInfoModel))block;

@end