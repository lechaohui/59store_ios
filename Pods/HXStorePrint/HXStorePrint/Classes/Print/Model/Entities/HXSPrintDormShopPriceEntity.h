//
//  HXSPrintDormShopPriceEntity.h
//  Pods
//  店铺打印的名称和对应价格
//  Created by J006 on 16/8/31.
//
//

#import "HXBaseJSONModel.h"

@protocol HXSPrintDormShopPriceEntity
@end

@interface HXSPrintDormShopPriceEntity : HXBaseJSONModel

@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *nameStr;//"name": str,//名称，例如："单面/黑白",
@property (nonatomic, strong) NSNumber *unitPriceNum;//"unit_price":double, //价格

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end
