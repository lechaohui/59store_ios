//
//  HXSDormItem.h
//  store
//
//  Created by chsasaw on 15/2/6.
//  strongright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HXSBoxOrderItemModel;

@interface HXSDormItem : NSObject

@property (nonatomic, strong) NSNumber *rid;
@property (nonatomic, assign) BOOL     has_stock;//1表示有库存，0表示没库存
@property (nonatomic, strong) NSNumber *sales;
@property (nonatomic, strong) NSNumber *salesHotLevel;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *origin_price;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *descriptionStr;
@property (nonatomic, strong) NSString *tip;
@property (nonatomic, strong) NSString *image_small;
@property (nonatomic, strong) NSString *image_medium;
@property (nonatomic, strong) NSString *image_big;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSString *promotionLabel;

@property (nonatomic, strong) NSMutableArray *promotions;

@property (nonatomic, strong) NSString *productIDStr;
/** 商品数量 */
@property (nonatomic, strong) NSNumber *quantity;
/** 库存 */
@property (nonatomic, strong) NSNumber *stock;
/** 本条商品记录商品结算金额，单位为元 */
@property (nonatomic, strong) NSNumber *amount;
/** 分类ID */
@property (nonatomic, strong) NSNumber *cate_id;
/** 缩略图 (代替上面的image_small) */
@property (nonatomic, strong) NSString *image_thumb;
/** 图标题(代替上面的tip) */
@property (nonatomic, strong) NSString *description_title;
/** 描述内容(代替上面的descriptionStr) */
@property (nonatomic, strong) NSString *description_content;
/** 促销ID */
@property (nonatomic, strong) NSNumber *promotion_id;
@property (nonatomic, assign) BOOL     isBox;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (instancetype)initWithItem:(HXSBoxOrderItemModel *)itemObject;

- (NSString *)getPromotionsString;

@end
