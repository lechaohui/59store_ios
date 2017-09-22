//
//  HXSFloatingCartEntity.m
//  store
//
//  Created by ArthurWang on 15/11/26.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSFloatingCartEntity.h"

#import "HXSDormItem.h"
#import "HXSStoreCartItemEntity.h"
#import "HXSBoxOrderModel.h"

@implementation HXSFloatingCartEntity

#pragma mark - Public Methods

- (instancetype)initWithCartItem:(HXSDormItem *)cartItem
{
    self = [super init];
    if (self) {
        self.amountNum        = cartItem.amount;
        self.imageBigStr      = cartItem.image_big;
        self.imageMediumStr   = cartItem.image_medium;
        self.imageSmallStr    = cartItem.image_small;
        self.itemIDNum        = cartItem.rid;
        self.productIDStr     = [NSString stringWithFormat:@"%@", cartItem.rid];
        self.nameStr          = cartItem.name;
        self.priceNum         = cartItem.price;
        self.quantityNum      = cartItem.quantity;
        self.ridNum           = cartItem.rid;
        self.stockNum         = cartItem.stock;
    }
    return self;
}

- (instancetype)initWithStoreCartItem:(HXSStoreCartItemEntity *)storeCartItem {
    if (self = [super init]) {
        self.amountNum        = storeCartItem.amountNum;
        self.imageMediumStr   = storeCartItem.imageUrlStr;
        self.itemIDNum        = storeCartItem.itemIdNum;
        self.nameStr          = storeCartItem.nameStr;
        self.priceNum         = storeCartItem.priceNum;
        self.quantityNum      = storeCartItem.quantityNum;
    }
    return self;
}

- (instancetype)initWithBoxItem:(HXSBoxOrderItemModel *)boxItemModel
{
    if (self = [super init])
    {
        self.amountNum        = boxItemModel.amountDoubleNum;
        self.imageMediumStr   = boxItemModel.imageMediumStr;
        self.itemIDNum        = boxItemModel.itemIdNum;
        self.nameStr          = boxItemModel.nameStr;
        self.priceNum         = boxItemModel.priceDoubleNum;
        self.quantityNum      = boxItemModel.quantityNum;
        self.productIDStr     = boxItemModel.productIdStr;
        self.stockNum         = boxItemModel.stockNum;
    }
    
    return self;
}


@end
