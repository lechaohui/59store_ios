//
//  HXSOrderCreateModel.h
//  Pods
//
//  Created by ArthurWang on 16/9/12.
//
//

#import <Foundation/Foundation.h>

#import "HXBaseJSONModel.h"


@protocol HXSOrderCreateItemModel

@end

@interface HXSOrderCreateItemModel : HXBaseJSONModel

@property (nonatomic, strong) NSString *amountStr;
@property (nonatomic, strong) NSString *createTimeStr;
@property (nonatomic, strong) NSString *imageStr;
@property (nonatomic, strong) NSString *itemIDStr;
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *orderIDStr;
@property (nonatomic, strong) NSString *priceStr;
@property (nonatomic, strong) NSString *quantityStr;

@end


@interface HXSOrderCreateModel : HXBaseJSONModel

@property (nonatomic, strong) NSString *createTimeStr;
@property (nonatomic, strong) NSString *discountStr;
@property (nonatomic, strong) NSString *orderIDStr;
@property (nonatomic, strong) NSString *orderTypeStr;
@property (nonatomic, strong) NSString *payAmountStr;   // 690 单位 分

@property (nonatomic, strong) NSArray<HXSOrderCreateItemModel> *itemsArr;

@end
