//
//  HXSTarget_credit.h
//  store
//
//  Created by ArthurWang on 16/6/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSTarget_credit : NSObject

/** 跳转信用钱包页面 */
- (UIViewController *)Action_creditWallet:(NSDictionary *)paramsDic;

/** 跳转59钱包首页 */
- (UIViewController *)Action_credit:(NSDictionary *)paramsDic;

/** 跳转开通59钱包页面 */
- (UIViewController *)Action_subscribe:(NSDictionary *)paramsDic;

@end
