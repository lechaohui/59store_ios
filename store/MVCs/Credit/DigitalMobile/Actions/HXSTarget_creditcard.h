//
//  HXSTarget_creditcard.h
//  store
//
//  Created by ArthurWang on 16/5/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSTarget_creditcard : NSObject

/** 跳转分期商城页面 */
// hxstore://creditcard/tip
- (UIViewController *)Action_tip:(NSDictionary *)paramsDic;

/** 跳转信用钱包账单页面 */
// hxstore://creditcard/bill?bill_type=0
- (UIViewController *)Action_bill:(NSDictionary *)paramsDic;

/** 跳转信用钱包分期纪录页面 */
// hxstore://creditcard/installment/record
- (UIViewController *)Action_installmentrecord:(NSDictionary *)paramsDic;

/** 跳转信用钱包页面页面 */
// hxstore://creditcard/wallet
- (UIViewController *)Action_wallet:(NSDictionary *)paramsDic;

/** 跳转分期购商品详情页面 */
// hxstore://creditcard/tip/group/item?group_id=123
- (UIViewController *)Action_tipgroupitem:(NSDictionary *)paramsDic;

@end
