//
//  HXSPrintDormShopEntity.h
//  Pods
//  获取店铺信息
//  Created by J006 on 16/8/31.
//
//

#import "HXBaseJSONModel.h"
#import "HXSPrintDormShopPriceEntity.h"

@interface HXSPrintDormShopEntity : HXBaseJSONModel

@property (nonatomic, strong) NSNumber *shopIdNum;//"shop_id": int, //店铺id
@property (nonatomic, strong) NSString *shopNameStr;//"shop_name": str,  //店铺名称
@property (nonatomic, strong) NSString *shopLogoStr;//"shop_logo": str,  //店铺logo,
@property (nonatomic, strong) NSString *shopNoticeStr;//"shop_notice": str,  //店铺通知,
@property (nonatomic, strong) NSNumber *businessStatusNum;//"business_status": int, //店铺状态,0休息中，1营业中
@property (nonatomic, strong) NSNumber *crossBuildingDistSwitchNum;//"cross_building_dist_switch":int,  //跨楼配送开关
@property (nonatomic, strong) NSNumber *freeshipAmountNum;//"freeship_amount":double,  //起送价或免配送门槛

@property (nonatomic, strong) NSArray<HXSPrintDormShopPriceEntity> *dormShopPricesArry;//"dorm_shop_prices": [  //店铺打印的名称和对应价格

+ (instancetype)objectFromJSONObject:(NSDictionary *)object;

@end
