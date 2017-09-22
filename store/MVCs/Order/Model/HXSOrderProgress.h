//
//  HXSOrderProgress.h
//  store
//
//  Created by 格格 on 16/8/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

/**
 HXSOrderProgressTypeToBeFahuo = 2,              //待发货
 HXSOrderProgressTypeToBeShouhuo = 3,            //待收货
 */
/**不同的订单描述*/
typedef NS_ENUM(NSInteger, HXSOrderProgressType)
{
    HXSOrderProgressTypeAll       = 0,              // 全部订单
    HXSOrderProgressTypeToBePaid  = 1,              // 待付款
    HXSOrderProgressTypeOngoing = 2,              //进行中
    HXSOrderProgressTypeToEvaluate = 3,             // 待评价
    HXSOrderProgressTypeRefundOrAfterSale = 4       // 退款/售后
};

#import <Foundation/Foundation.h>

@interface HXSOrderProgress : NSObject

/** 订单分类 默认为全部订单*/
@property (nonatomic, assign) HXSOrderProgressType progressType;
/** 该分类下的订单数量 默认为0 */
@property (nonatomic, assign) NSInteger orderNum;
/** 该分类显示名称*/
@property (nonatomic, strong) NSString *orderProgressName;
/** 显示名称（分类名称+订单数量） */
@property (nonatomic, strong) NSString *showName;
/** 请求订单列表时的分类名称 */
@property (nonatomic, strong) NSString *fatchName;

@end
