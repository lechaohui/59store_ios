//
//  HXDRechargeTableViewController.h
//  store
//
//  Created by caixinye on 2017/9/11.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXDBaseViewController.h"
/**
 
 充值
 
 
 */
@interface HXDRechargeTableViewController : HXDBaseViewController

@property (nonatomic, strong) NSString *orderIDStr;         // 订单ID
@property (nonatomic, strong) NSNumber *shopType;           // 店铺类型0-夜猫店，1-饮品店
@property (nonatomic, assign) CGFloat  orderAmountFloat;     // 订单金额
@property (nonatomic, strong) NSString *payURLStr;          // 支付宝二维码URL
@property (nonatomic, strong) NSString *notifyURLStr;       // 商品描述 支付宝支付回调URL

// 支付宝支付需要
@property (nonatomic, strong) NSString *orderTypeNameStr;       // 商品标题  夜猫店， 饮品店， 收银台


@end
