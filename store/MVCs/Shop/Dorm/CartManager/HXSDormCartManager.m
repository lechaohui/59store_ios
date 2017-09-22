//
//  HXSDormCartManager.m
//  store
//
//  Created by chsasaw on 14/11/27.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSDormCartManager.h"

#import "HXSShopManager.h"

static HXSDormCartManager *_cartManagerSharedInstance = nil;

static NSString * const kPromotionCountInfoURL = @"promotion_count/info";

@interface HXSDormCartManager ()

@end

@implementation HXSDormCartManager

#pragma mark - Public Methods

+ (HXSDormCartManager*)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cartManagerSharedInstance = [[self alloc] init];
    });
    
    return _cartManagerSharedInstance;
}

- (HXSDormItem *)findItemInCartWithDormItem:(HXSDormItem *)dormItem
{
    HXSDormItem *item = nil;
    
    for (HXSDormItem *itemInCart in self.cartItemsArr) {
        if ([itemInCart.rid integerValue] == [dormItem.rid integerValue]) {
            item = itemInCart;
            
            break;
        }
    }
    
    return item;
}

- (void)updateItem:(HXSDormItem *)dormItem quantity:(int)quantity
{
    BOOL existed = NO;
    
    for (HXSDormItem *itemInCart in self.cartItemsArr) {
        if ([itemInCart.rid integerValue] == [dormItem.rid integerValue]) {
            if (0 >= quantity) { // Remove this item when the quantity is 0
                NSMutableArray *tempArr = [[NSMutableArray alloc] initWithArray:self.cartItemsArr];
                
                [tempArr removeObject:itemInCart];
                
                self.cartItemsArr = tempArr;
            } else {
                itemInCart.quantity = @(quantity);
                itemInCart.amount = [NSNumber numberWithFloat:[itemInCart.price floatValue] * [itemInCart.quantity integerValue]];
            }
            
            existed = YES;
            
            break;
        }
    }
    
    if (!existed) {
        NSMutableArray *tempArr = [[NSMutableArray alloc] initWithArray:self.cartItemsArr];
        
        dormItem.quantity = @(quantity);
        dormItem.amount = [NSNumber numberWithFloat:[dormItem.price floatValue] * [dormItem.quantity integerValue]];
        
        [tempArr addObject:dormItem];
        
        self.cartItemsArr = tempArr;
    }
    
    [self updateItemNumber];
    
    // Because do not calc origin amount, so clear it
    self.promotionInfoModel.originAmountDecNum = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDormCartComplete object:nil];
}

- (void)clearCart
{
    self.cartItemsArr       = nil;
    self.promotionInfoModel = nil;
    
    [self updateItemNumber];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDormCartComplete object:nil];
}

- (void)fetchPromtionCountInfoWithCouponCode:(NSString *)couponCodeStr
                                       items:(NSArray *)itemsArr
                                    complete:(void (^)(HXSErrorCode code, NSString *message, HXSPromotionInfoModel *promotionInfoModel))block;
{
    NSMutableArray *itemsArray = [NSMutableArray array];
    
    for (HXSDormItem *itemModel in itemsArr) {
        NSMutableDictionary *itemDict = [NSMutableDictionary dictionary];
        [itemDict setValue:itemModel.quantity forKey:@"quantity"];
        [itemDict setValue:itemModel.productIDStr forKey:@"product_id"];
        [itemsArray addObject:itemDict];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:itemsArray
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];
    
    HXSShopManager *shopManager = [HXSShopManager shareManager];
    
    NSDictionary* paramDic = @{@"shop_id":  shopManager.currentEntry.shopEntity.shopIDIntNum,
                               @"code":     couponCodeStr,
                               @"items":    jsonStr,
                               };
    
    __weak typeof(self) weakSelf = self;
    [HXStoreWebService postRequest:kPromotionCountInfoURL
                        parameters:paramDic
                          progress:nil
                           success:^(HXSErrorCode status, NSString* msg, NSDictionary* data) {
                               if(status != kHXSNoError) {
                                   block(status, msg, nil);
                                   
                                   return ;
                               }
                               
                               HXSPromotionInfoModel *infoModel = [[HXSPromotionInfoModel alloc] initWithDictionary:data error:nil];
                               
                               weakSelf.promotionInfoModel = infoModel;
                               
                               block(kHXSNoError, msg, infoModel);
                               
                               [weakSelf updateItemNumber];
                           }
                           failure:^(HXSErrorCode status, NSString* msg, NSDictionary* data) {
                               block(status, msg, nil);
                           }];
}


#pragma mark - Deal With Cart Data

- (void)updateItemNumber
{
    CGFloat itemAmount = 0.0;
    NSInteger itemNumber = 0;
    
    for (HXSDormItem *item in self.cartItemsArr) {
        itemAmount += [item.amount floatValue];
        itemNumber += [item.quantity integerValue];
    }
    
    self.promotionInfoModel.itemAmountDecNum = [[NSDecimalNumber alloc]initWithFloat:itemAmount];
    self.promotionInfoModel.itemNumberIntNum = [NSNumber numberWithInteger:itemNumber];
}


#pragma mark - Setter Methods

- (HXSPromotionInfoModel *)promotionInfoModel
{
    if (nil == _promotionInfoModel) {
        _promotionInfoModel = [[HXSPromotionInfoModel alloc] init];
    }
    
    return _promotionInfoModel;
}


@end
