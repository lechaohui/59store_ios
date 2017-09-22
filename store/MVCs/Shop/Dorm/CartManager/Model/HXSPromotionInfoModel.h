//
//  HXSPromotionInfoModel.h
//  store
//
//  Created by ArthurWang on 16/9/8.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDecimalNumber+HXSStringValue.h"

@protocol HXSPromotionItemModel
@end

@interface HXSPromotionItemModel : HXBaseJSONModel

@property (nonatomic, strong) NSString *ridStr;
@property (nonatomic, strong) NSString *itemIdStr;
@property (nonatomic, strong) NSString *quantityStr;
@property (nonatomic, strong) NSDecimalNumber *priceDecNum;
@property (nonatomic, strong) NSString *originPriceStr;
@property (nonatomic, strong) NSString *amountStr;
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *imageMediumStr;

@end

@interface HXSPromotionInfoModel : HXBaseJSONModel

@property (nonatomic, strong) NSDecimalNumber *itemAmountDecNum;          // 3.00
@property (nonatomic, strong) NSDecimalNumber *originAmountDecNum;        // 5.00
@property (nonatomic, strong) NSString *promotionTipAmountStr;            // "大优惠"
@property (nonatomic, strong) NSString *couponCodeStr;                    // "272839303"
@property (nonatomic, strong) NSDecimalNumber *couponDiscountDecNum;      // 2

@property (nonatomic, strong) NSArray<HXSPromotionItemModel> *promotionItemsArr;  // 满就送商品列表

/** 购买商品个数 */
@property (nonatomic, strong) NSNumber *itemNumberIntNum;

@end
