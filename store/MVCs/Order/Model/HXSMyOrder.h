//
//  HXSMyOrder.h
//  store
//
//  Created by 格格 on 16/8/31.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXBaseJSONModel.h"
#import "NSDecimalNumber+HXSStringValue.h"

static NSString * const kFenToYuanDivider           = @"100";  // 金额由分转到元的除数
static NSString * const kMillisecondToSecondDivider = @"1000"; // 时间戳毫秒到秒的除数

/******************* 订单状态信息 ************************************/

@protocol HXSOrderStatus <NSObject>
@end

@interface HXSOrderStatus: HXBaseJSONModel

/** 状态码 */
@property (nonatomic, strong) NSString *statusStr;
/** 状态汉字 */
@property (nonatomic, strong) NSString *statusTextStr;
/** 汉字颜色 */
@property (nonatomic, strong) NSString *statusColorStr;
/** 状态图片 */
@property (nonatomic, strong) NSString *statusIconStr;
/** 状态说明文字 */
@property (nonatomic, strong) NSString *statusSpecStr;
/** 退款状态*/
@property (nonatomic, strong) NSString *refundStatusStr;
/** 退款状态 */
@property (nonatomic, strong) NSString *refundStatusByteStr;
/** 支付状态 string类型 */
@property (nonatomic, strong) NSString *payStatusStr;
/** 支付状态 int类型 */
@property (nonatomic, strong) NSString *payStatusByteStr;
/** 失效时长 */
@property (nonatomic, strong) NSString *invalidTimeStr;
/** 是否可评价 */
@property (nonatomic, strong) NSString *canBeCommentStr;
/** 当前时间 */
@property (nonatomic, strong) NSString *currentTimeStr;

// 下面属性非后台索取
/** 说明文字高度 */
@property (nonatomic, assign) CGFloat statusTextHeight;
/** 显示说明的cell高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@end


/******************* 商品信息 ************************************/

@protocol HXSMyOrderItem <NSObject>
@end

@interface HXSMyOrderItem : HXBaseJSONModel

/** 图片url */
@property (nonatomic, strong) NSString *imgStr;
/** 商品名称 */
@property (nonatomic, strong) NSString *nameStr;
/** 数量 */
@property (nonatomic, strong) NSString *quantityStr;
/** 原价(分) */
@property (nonatomic, strong) NSDecimalNumber *oriPriceDecNum;
/** 价格（分） */
@property (nonatomic, strong) NSDecimalNumber *priceDecNum;
/** 商品规格描述 */
@property (nonatomic, strong) NSString *specStr;

@end


/******************* 收货人信息 ************************************/

@protocol HXSBuyerAddress <NSObject>
@end

@interface HXSBuyerAddress : HXBaseJSONModel

/** 买家名 */
@property (nonatomic, strong) NSString *buyerNameStr;
/** 买家电话 */
@property (nonatomic, strong) NSString *buyerPhoneStr;
/** 买家地址 */
@property (nonatomic, strong) NSString *buyerAddressStr;
/** 买家备注 */
@property (nonatomic, strong) NSString *addressRemarkStr;

// 下面属性为非后台获取

/** 地址文本高度 */
@property (nonatomic, assign) CGFloat buyerAddressTextHeight;
/** 备注文本高度 */
@property (nonatomic, assign) CGFloat addressRemarkTextHeight;
/** 显示cell高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@end


/******************* 时间轴节点 ************************************/

@protocol HXStimelineStatus <NSObject>
@end

@interface HXStimelineStatus : HXBaseJSONModel

/** 状态名 */
@property (nonatomic, strong) NSString *statusStr;
/** 是否当前选中 */
@property (nonatomic, strong) NSString *statusHitStr;

@end


/******************* 优惠信息 ************************************/

@protocol HXSCouponItem <NSObject>
@end
@interface HXSCouponItem : HXBaseJSONModel

/** 优惠信息 */
@property (nonatomic, strong) NSString *couponTypeStr;
/** 优惠金额（分） */
@property (nonatomic, strong) NSDecimalNumber *couponAmountDecNum;
/** 显示 */
@property (nonatomic, strong) NSString *couponShowType;

@end


/******************* 分期信息 ************************************/

@protocol HXStagingInfo <NSObject>
@end
@interface HXStagingInfo : HXBaseJSONModel

/** 首付金额（分） */
@property (nonatomic, strong) NSDecimalNumber *firstPayAmountDecNum;
/** 分期金额（分） */
@property (nonatomic, strong) NSDecimalNumber *stagingAmountDecNum;
/** 分期数 */
@property (nonatomic, strong) NSString *stagingNumStr;
/** 每期金额（分） */
@property (nonatomic, strong) NSDecimalNumber *stagingPerMonthDecNum;
/** 分期手续费（分） */
@property (nonatomic, strong) NSDecimalNumber *stagingFeeDecNum;

@end


/******************* 店铺信息 ************************************/

@protocol HXShopInfo <NSObject>
@end
@interface HXShopInfo : HXBaseJSONModel

/** 店铺名称 */
@property (nonatomic, strong) NSString *shopNameStr;
/** 店铺图标地址 */
@property (nonatomic, strong) NSString *shopIconStr;
/** 店铺头像地址 */
@property (nonatomic, strong) NSString *shopAvatarStr;
/** 商家电话 */
@property (nonatomic, strong) NSString *sellerPhoneStr;

@end

/******************* 其他信息 ************************************/

@protocol HXSOrderDetailInfo <NSObject>
@end
@interface HXSOrderDetailInfo : HXBaseJSONModel

/** 订单业务类型 */
@property (nonatomic, strong) NSString *bizTypeStr;
/** 订单id */
@property (nonatomic, strong) NSString *orderIdStr;
/** 下单时间（毫秒） */
@property (nonatomic, strong) NSString *orderTimeStr;
/** 支付方式 */
@property (nonatomic, strong) NSString *payMethodStr;
/** 支付时间（毫秒） */
@property (nonatomic, strong) NSString *payTimeStr;
/** 收货时间（毫秒） */
@property (nonatomic, strong) NSString *deliveredTimeStr;
/** 退款时间（毫秒） */
@property (nonatomic, strong) NSString *refundTimeStr;
/** 快递单号 */
@property (nonatomic, strong) NSString *deliveredNumStr;
/** 快递公司 */
@property (nonatomic, strong) NSString *deliveredCompanyStr;
/** 商品总数 */
@property (nonatomic, strong) NSString *itemQuantityStr;
/** 折扣金额（分） */
@property (nonatomic, strong) NSDecimalNumber *discountDecNum;
/** 总计金额（分） */
@property (nonatomic, strong) NSDecimalNumber *totalAmountDecNum;
/** 实付金额 (分)*/
@property (nonatomic, strong) NSDecimalNumber *payAmountDecNum;
/** 运费（分） */
@property (nonatomic, strong) NSDecimalNumber *deliveryFeeDecNum;
/** 取消时间(毫秒) */
@property (nonatomic, strong) NSString *cancelTimeStr;
/** 取消理由 */
@property (nonatomic, strong) NSString *cancelReasonStr;


// 判断cell高度的时候使用
@property (nonatomic, assign) CGFloat cancelReasonCellHeight;

+ (NSDecimalNumber *)decimalNumberString:(NSString *)numStr dividerStr:(NSString *)dividerStr;

@end

/******************* 订单信息 ************************************/

@interface HXSMyOrder : HXBaseJSONModel

/** 订单状态 */
@property (nonatomic, strong) HXSOrderStatus *orderStatus;
/** 订单时间轴 */
@property (nonatomic, strong) NSArray <HXStimelineStatus> *timelineStatusArr;
/** 收件人信息 */
@property (nonatomic, strong) HXSBuyerAddress *buyerAddress;
/** 商品数组 */
@property (nonatomic, strong) NSArray <HXSMyOrderItem> *orderItemsArr;
/** 优惠信息 */
@property (nonatomic, strong) NSArray <HXSCouponItem> *couponItemsArr;
/** 分期信息 */
@property (nonatomic, strong) HXStagingInfo *stagingInfo;
/** 店铺信息 */
@property (nonatomic, strong) HXShopInfo *shopInfo;
/** 订单其他信息 */
@property (nonatomic, strong) HXSOrderDetailInfo *orderDetailInfo;
/** 操作按钮 */
@property (nonatomic, strong) NSArray *viewButtonArr;
/** 约团详情或者参与详情 */
@property (nonatomic, strong) NSDictionary *extInfoDic;

@end
