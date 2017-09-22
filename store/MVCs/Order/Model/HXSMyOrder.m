//
//  HXSMyOrder.m
//  store
//
//  Created by 格格 on 16/8/31.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyOrder.h"

/******************* 订单状态信息 ************************************/

static CGFloat kStatusDescribeCellMargin      = 30.0;
static CGFloat kStatusDescribeCellBottonSpace = 10.0;


@implementation HXSOrderStatus

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"status"         , @"statusStr",
                             @"status_str"     , @"statusTextStr",
                             @"status_color"   , @"statusColorStr",
                             @"status_icon"    , @"statusIconStr",
                             @"status_spec"    , @"statusSpecStr",
                             @"refund_status"  , @"refundStatusStr",
                             @"refund_status_byte" , @"refundStatusByteStr",
                             @"pay_status"      , @"payStatusStr",
                             @"pay_status_byte" , @"payStatusByteStr",
                             @"invalid_time"    , @"invalidTimeStr",
                             @"can_be_comment"  , @"canBeCommentStr",
                             @"current_time"    , @"currentTimeStr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

- (CGFloat)statusTextHeight
{
    if( 0 >= self.statusSpecStr.length) {
        
        return 0.00;
    }
    
    UIFont *textFont = [UIFont systemFontOfSize:13];
    CGSize textSize = CGSizeMake(SCREEN_WIDTH - kStatusDescribeCellMargin * 2 , CGFLOAT_MAX);
    NSDictionary *textDic = [NSDictionary dictionaryWithObjectsAndKeys:textFont,NSFontAttributeName,nil];
    CGSize autoSize = [self.statusSpecStr boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                     attributes:textDic context:nil].size;
    return ceilf(autoSize.height);
}

- (CGFloat)cellHeight
{
    return self.statusTextHeight + kStatusDescribeCellBottonSpace;
}


@end


/******************* 商品信息 ************************************/

@implementation HXSMyOrderItem

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"img"       , @"imgStr",
                             @"name"      , @"nameStr",
                             @"quantity"  , @"quantityStr",
                             @"ori_price" , @"oriPriceDecNum",
                             @"price"     , @"priceDecNum",
                             @"spec"      , @"specStr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];

}

- (void)setOriPriceDecNumWithNSNumber:(NSNumber *)number
{
    _oriPriceDecNum = [NSDecimalNumber decimalNumberWithDecimal:number.decimalValue];
}

- (void)setOriPriceDecNumWithNSString:(NSString *)string
{
    _oriPriceDecNum = [NSDecimalNumber decimalNumberWithString:string];
}

- (void)setPriceDecNumWithNSNumber:(NSNumber *)number
{
    _priceDecNum = [NSDecimalNumber decimalNumberWithDecimal:number.decimalValue];
}

- (void)setPriceDecNumWithNSString:(NSString *)string
{
    _priceDecNum = [NSDecimalNumber decimalNumberWithString:string];
}

@end


/******************* 收货人信息 ************************************/

static CGFloat const cellBaseHeight = 43.0;
static CGFloat const marging        = 53.0;  // 左边的38 + 右边的15
static NSInteger const textSize     = 14;    // 字体大小
static CGFloat const space          = 10.0;  // 文本间的上下间距

#define TEXT_WIDTH (SCREEN_WIDTH - marging)

@implementation HXSBuyerAddress

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"buyer_name"     , @"buyerNameStr",
                             @"buyer_phone"    , @"buyerPhoneStr",
                             @"buyer_address"  , @"buyerAddressStr",
                             @"address_remark" , @"addressRemarkStr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

- (CGFloat)buyerAddressTextHeight
{
    NSString *str = [NSString stringWithFormat:@"收货地址：%@",self.buyerAddressStr];
    UIFont *textFont = [UIFont systemFontOfSize:textSize];
    CGSize textSize = CGSizeMake(TEXT_WIDTH, CGFLOAT_MAX);
    NSDictionary *textDic = [NSDictionary dictionaryWithObjectsAndKeys:textFont,NSFontAttributeName,nil];
    CGSize autoSize = [str boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                 attributes:textDic context:nil].size;
    return ceilf(autoSize.height);

}

- (CGFloat)addressRemarkTextHeight
{
    if(nil == self.addressRemarkStr)
        self.addressRemarkStr = @"";
    
    NSString *str = [NSString stringWithFormat:@"备注：%@",self.addressRemarkStr];
    UIFont *textFont = [UIFont systemFontOfSize:textSize];
    CGSize textSize = CGSizeMake(TEXT_WIDTH, CGFLOAT_MAX);
    NSDictionary *textDic = [NSDictionary dictionaryWithObjectsAndKeys:textFont,NSFontAttributeName,nil];
    CGSize autoSize = [str boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                     attributes:textDic context:nil].size;
    return ceilf(autoSize.height);
}

- (CGFloat)cellHeight
{
    // 基础高度 + 地址高度 + 间距10 + 备注高度 + 间距10
    return cellBaseHeight + self.buyerAddressTextHeight + space + self.addressRemarkTextHeight + space;
}

@end


/******************* 时间轴节点 ************************************/

@implementation HXStimelineStatus

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"status_str" , @"statusStr",
                             @"status_hit" , @"statusHitStr", nil];

    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

@end


/******************* 优惠信息 ************************************/

@implementation HXSCouponItem

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"coupon_type_str" , @"couponTypeStr",
                             @"coupon_amount"   , @"couponAmountDecNum",
                             @"coupon_type"     , @"couponShowType", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

- (void)setCouponAmountDecNumWithNSNumber:(NSNumber *)number
{
    _couponAmountDecNum = [NSDecimalNumber decimalNumberWithDecimal:number.decimalValue];
}

- (void)setCouponAmountDecNumWithNSString:(NSString *)string
{
    _couponAmountDecNum = [NSDecimalNumber decimalNumberWithString:string];
}

@end


/******************* 分期信息 ************************************/

@implementation HXStagingInfo

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"first_pay_amount" , @"firstPayAmountDecNum",
                             @"staging_amount"   , @"stagingAmountDecNum",
                             @"staging_num"      , @"stagingNumStr",
                             @"staging_per_month", @"stagingPerMonthDecNum",
                             @"staging_fee"      , @"stagingFeeDecNum", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

- (void)setFirstPayAmountDecNumWithNSNumber:(NSNumber *)number
{
    _firstPayAmountDecNum = [NSDecimalNumber decimalNumberWithDecimal:number.decimalValue];
}

- (void)setFirstPayAmountDecNumWithNSString:(NSString *)string
{
    _firstPayAmountDecNum = [NSDecimalNumber decimalNumberWithString:string];
}


- (void)setStagingAmountDecNumWithNSNumber:(NSNumber *)number
{
    _stagingAmountDecNum = [NSDecimalNumber decimalNumberWithDecimal:number.decimalValue];
}

- (void)setStagingAmountDecNumWithNSString:(NSString *)string
{
    _stagingAmountDecNum = [NSDecimalNumber decimalNumberWithString:string];
}

- (void)setStagingPerMonthDecNumWithNSNumber:(NSNumber *)number
{
    _stagingPerMonthDecNum = [NSDecimalNumber decimalNumberWithDecimal:number.decimalValue];
}

- (void)setStagingPerMonthDecNumWithNSString:(NSString *)string
{
    _stagingPerMonthDecNum = [NSDecimalNumber decimalNumberWithString:string];
}

- (void)setStagingFeeDecNumWithNSNumber:(NSNumber *)number
{
    _stagingFeeDecNum = [NSDecimalNumber decimalNumberWithDecimal:number.decimalValue];
}

- (void)setStagingFeeDecNumWithNSString:(NSString *)string
{
    _stagingFeeDecNum = [NSDecimalNumber decimalNumberWithString:string];
}

@end

/******************* 店铺信息 ************************************/

@implementation HXShopInfo

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"shop_name"   , @"shopNameStr",
                             @"shop_icon"   , @"shopIconStr",
                             @"shop_avatar" , @"shopAvatarStr",
                             @"seller_phone", @"sellerPhoneStr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

@end

/******************* 其他信息 ************************************/

static CGFloat const kTextFontSize = 13.0;
static CGFloat const kCellMarging = 15.0;

@implementation HXSOrderDetailInfo

+(JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"biz_type"      , @"bizTypeStr",
                             @"order_id"      , @"orderIdStr",
                             @"order_time"    , @"orderTimeStr",
                             @"pay_method"    , @"payMethodStr",
                             @"pay_time"      , @"payTimeStr",
                             @"delivered_time", @"deliveredTimeStr",
                             @"refund_time"   , @"refundTimeStr",
                             @"delivery_num"  , @"deliveredNumStr",
                             @"delivery_company" , @"deliveredCompanyStr",
                             @"item_quantity"   , @"itemQuantityStr",
                             @"discount"        , @"discountDecNum",
                             @"total_amount"    , @"totalAmountDecNum",
                             @"delivery_fee"    , @"deliveryFeeDecNum",
                             @"cancel_time"     , @"cancelTimeStr",
                             @"pay_amount"      , @"payAmountDecNum",
                             @"cancel_reason"   , @"cancelReasonStr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

+ (NSDecimalNumber *)decimalNumberString:(NSString *)numStr dividerStr:(NSString *)dividerStr
{
    if (numStr.length > 0 && dividerStr.length > 0) {
        
        NSDecimalNumber *dividendNum = [NSDecimalNumber decimalNumberWithString:numStr];
        NSDecimalNumber *divisorNum = [NSDecimalNumber decimalNumberWithString:dividerStr];
        return [dividendNum decimalNumberByDividingBy:divisorNum];
    }
    return [NSDecimalNumber decimalNumberWithString:@"0"];
}

- (CGFloat)cancelReasonCellHeight
{
    if(nil == self.cancelReasonStr)
        self.cancelReasonStr = @"";
    
    NSString *str = [NSString stringWithFormat:@"取消理由：%@",self.cancelReasonStr];
    UIFont *textFont = [UIFont systemFontOfSize:kTextFontSize];
    CGSize textSize = CGSizeMake(SCREEN_WIDTH - kCellMarging * 2, CGFLOAT_MAX);
    NSDictionary *textDic = [NSDictionary dictionaryWithObjectsAndKeys:textFont,NSFontAttributeName,nil];
    CGSize autoSize = [str boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                     attributes:textDic context:nil].size;
    return (ceilf(autoSize.height) + 3) > 24.5 ? (ceilf(autoSize.height) + 3) : 24.5;
}


- (void)setDiscountDecNumWithNSNumber:(NSNumber *)number
{
    _discountDecNum = [NSDecimalNumber decimalNumberWithDecimal:number.decimalValue];
}

- (void)setDiscountDecNumWithNSString:(NSString *)string
{
    _discountDecNum = [NSDecimalNumber decimalNumberWithString:string];
}

- (void)setTotalAmountDecNumWithNSNumber:(NSNumber *)number
{
    _totalAmountDecNum = [NSDecimalNumber decimalNumberWithDecimal:number.decimalValue];
}

- (void)setTotalAmountDecNumWithNSString:(NSString *)string
{
    _totalAmountDecNum = [NSDecimalNumber decimalNumberWithString:string];
}

- (void)setPayAmountDecNumWithNSNumber:(NSNumber *)number
{
    _payAmountDecNum = [NSDecimalNumber decimalNumberWithDecimal:number.decimalValue];
}

- (void)setPayAmountDecNumWithNSString:(NSString *)string
{
    _payAmountDecNum = [NSDecimalNumber decimalNumberWithString:string];
}

- (void)setDeliveryFeeDecNumWithNSNumber:(NSNumber *)number
{
    _deliveryFeeDecNum = [NSDecimalNumber decimalNumberWithDecimal:number.decimalValue];
}

- (void)setDeliveryFeeDecNumWithNSString:(NSString *)string
{
    _deliveryFeeDecNum = [NSDecimalNumber decimalNumberWithString:string];
}

@end

/******************* 订单信息 ************************************/

@implementation HXSMyOrder

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"order_status"    , @"orderStatus",
                             @"timeline_status_list" , @"timelineStatusArr",
                             @"buyer_address"   , @"buyerAddress",
                             @"order_items"     , @"orderItemsArr",
                             @"coupon_items"    , @"couponItemsArr",
                             @"staging_info"    , @"stagingInfo",
                             @"shop_info"       , @"shopInfo",
                             @"order_detail_info" , @"orderDetailInfo",
                             @"view_button"     , @"viewButtonArr",
                             @"ext_info"        , @"extInfoDic", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

@end
