//
//  HXSOrderDetialDataSource.h
//  store
//
//  Created by 格格 on 16/9/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSMyOrder.h"

// Views
#import "HXSOrderStatusCell.h"
#import "HXSOrderStatusDescribeCell.h"
#import "HXSOrderCountdownCell.h"
#import "HXSOrderTimeLineCell.h"
#import "HXSOrderConsigneeInfoCell.h"
#import "HXShopNameAndOrderStatusCell.h"
#import "HXSGoodsInfoCell.h"
#import "HXSOrderBillItemCell.h"
#import "HXSOrderCustomerServiceCell.h"
#import "HXSInstalmentInfoCell.h"
#import "HXSOrderDetialInfoCell.h"
#import "HXSOrderSpaceCell.h"


/** section类别 */
typedef NS_ENUM(NSInteger, OrderDetialSectionType)
{
    OrderDetialSectionTypeOrderStatus      = 0,  // 订单状态
    OrderDetialSectionTypeOrderCountdown   = 1,  // 倒计时
    OrderDetialSectionTypeOrderTimeLine    = 2,  // 时间轴
    OrderDetialSectionTypeBuyerInfo        = 3,  // 收货人信息
    OrderDetialSectionTypeGoodsList        = 4,  // 商品列表信息
    OrderDetialSectionTypeStageInfo        = 5,  // 分期信息
    OrderDetialSectionTypeBillInfo         = 6,  // 账单信息
    OrderDetialSectionTypeCustomerService  = 7,  // 客服信息
    OrderDetialSectionTypeOrderInfo        = 8   // 订单信息
};

/*****************用来保存每个section的类别信息和行数信息***************************/
@interface SectionModel : NSObject

@property (nonatomic, assign) OrderDetialSectionType sectionType;
@property (nonatomic, strong) NSMutableArray *rowInfoCellMarr;

@end


/*****************用来保存每个Row的类别信息和行数信息***************************/
@interface RowModel : NSObject

@property (nonatomic, strong) UITableViewCell *cell;
@property (nonatomic, assign) CGFloat cellHeight;

@end


/************************************************************/

@protocol HXSOrderDetialDataSourceDelegate <NSObject>

// 倒计时到0
- (void)countdownOver;
// 联系商家
- (void)contactMerchant;

@end


@interface HXSOrderDetialDataSource : NSObject

@property (nonatomic, strong) NSMutableArray *dataMArr;
@property (nonatomic, strong) HXSMyOrder     *myOrder;
@property (nonatomic, weak) id<HXSOrderDetialDataSourceDelegate> delegate;

- (void)updateDataMarr;

@end
