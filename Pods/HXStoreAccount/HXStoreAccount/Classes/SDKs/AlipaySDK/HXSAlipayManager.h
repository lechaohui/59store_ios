//
//  HXSAlipayManager.h
//  store
//
//  Created by chsasaw on 15/4/23.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HXSOrderInfo;


//@interface HXDAlipayOrderInfoEntity : NSObject
//
//@property (nonatomic, strong) NSString *orderIDStr;             // 订单ID（由商家自行制定）
//@property (nonatomic, strong) NSString *orderTypeNameStr;       // 商品标题  夜猫店， 饮品店， 收银台
//@property (nonatomic, strong) NSNumber *orderAmountFloatNum;    // 商品价格
//@property (nonatomic, strong) NSString *productDescriptionStr;  // 商品描述
//
//
//
//@end


@protocol HXSAlipayDelegate <NSObject>

- (void)payCallBack:(NSString *)status message:(NSString *)message result:(NSDictionary *)result;

@end

@interface HXSAlipayManager : NSObject

@property (nonatomic, weak) id<HXSAlipayDelegate> delegate;

+ (HXSAlipayManager *) sharedManager;

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)pay:(HXSOrderInfo *)orderInfo delegate:(id<HXSAlipayDelegate>)delegate;

@end
