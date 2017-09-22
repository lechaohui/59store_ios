//
//  HXSOrderViewModel.h
//  store
//
//  Created by 格格 on 16/8/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSMyOrder.h"
#import "HXSOrderCount.h"


static NSString * const kOrderapiQueryBuyerMyorders    = @"orderapi/query/buyer/myorders";    // 获取订单列表
static NSString * const kOrderapiQueryBuyerOrderdetail = @"orderapi/query/buyer/orderdetail"; // 获取订单详情
static NSString * const kOrderapiOperateBuyerCancel    = @"orderapi/operate/buyer/cancel";    // 取消订单
static NSString * const kOrderapiOperateBuyerComment   = @"orderapi/operate/buyer/comment";   // 评价订单
static NSString * const kPayMethods                    = @"pay/methods";                      // 获取支付方式
static NSString * const kOrderapiQueryBuyerOrdercount  = @"orderapi/query/buyer/ordercount";  // 获取订单数量
static NSString * const kCashOnDeliveryNotify          = @"cash_on_delivery/notify";          // 新增支付方式
static NSString * const kOrderapiQueryBuyerBeforepaycheck = @"orderapi/query/buyer/beforepaycheck"; // 检查订单状态

@interface HXSOrderViewModel : NSObject

/**
 *  获取订单列表
 *  @prama query_status : 订单状态
 *  @prama page         : 当前页
 *  @prama page_size    : 每页数量
 */
+ (void)fecthMyordersWithQueryStatus:(NSString *)query_status
                                page:(NSInteger)page
                            pageSize:(NSInteger)page_size
                            complete:(void(^)(HXSErrorCode status, NSString *message, NSArray *ordersArr))block;

/**
 * 获取订单详情
 * @prama order_id  : 订单编号
 */
+ (void)fecthOrderDetialWithOrderId:(NSString *)order_id
                           complete:(void (^)(HXSErrorCode status, NSString *message, HXSMyOrder *myOrder))block;

/**
 *   取消订单
 *   @prama order_id : 订单编号
 */
+ (void)cancleOrderWithOrderId:(NSString *)order_id
                      complete:(void (^)(HXSErrorCode status, NSString *message, NSDictionary *dic))block;

/**
 *  评价
 * @prama order_id : 订单编号
 * @prama item_id  : 商品id
 * @prama score    : 分数
 * @prama content  : 评价内容
 */
+ (void)evaluateOrderWithOrderId:(NSString *)order_id
                          itemId:(NSString *)item_id
                           score:(int)score
                         content:(NSString *)content
                        complete:(void (^)(HXSErrorCode status, NSString *message, NSDictionary *dic))block;



/**
 *  获取支付列表
 *  @prama orderTypeNum : 业务类型编号
 *  @prama payAmountFloatNum : 支付金额
 *  @prama isInstallmentIntNum : 是否分期
 */
+ (void)fetchPayMethodsWith:(NSString *)orderTypeStr
                  payAmount:(NSNumber *)payAmountFloatNum
                installment:(NSString *)isInstallmentIntStr
                   complete:(void (^)(HXSErrorCode code, NSString *message, NSArray *payArr))block;

/**
 * 获取订单数量信息
 */
+ (void)facthMyOrderCountComplete:(void (^)(HXSErrorCode status, NSString *message, HXSOrderCount *orderCount))block;


/**
 * 新增支付方式
 * @prama
 */
+ (void)cashOnDeliveryWithOrderId:(NSString *)order_id
                         complete:(void (^)(HXSErrorCode status, NSString *message, NSDictionary *dic))block;


/**
 * 支付前，检查订单状态
 * prama order_id: 订单号
 */

+ (void)payCheckWithOrderId:(NSString *)order_id
                   complete:(void (^)(HXSErrorCode status, NSString *message, NSDictionary *dic))block;


@end
