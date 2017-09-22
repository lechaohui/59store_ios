//
//  HXSOrderDetialDataSource.m
//  store
//
//  Created by 格格 on 16/9/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSOrderDetialDataSource.h"

@implementation SectionModel

@end


@implementation RowModel

@end



@interface HXSOrderDetialDataSource ()<HXSOrderCountdownCellDelegate,
                                       HXSOrderCustomerServiceCellDelegate>

@end

@implementation HXSOrderDetialDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.dataMArr = [NSMutableArray arrayWithCapacity:10];
        
        return self;
    }
    
    return nil;
}

- (void)updateDataMarr
{
    if (nil == self.myOrder) {
        return;
    }
    
    [self.dataMArr removeAllObjects];
    
    [self orderStatusInfo];
    
    [self countdownInfo];
    
    [self timeLineInfo];
    
    [self buyyerInfo];
    
    [self goodsInfo];
    
    [self stageInfo];
    
    [self billInfo];
    
    [self customerServiceInfo];
    
    [self orderInfo];
}

- (void)orderStatusInfo
{
    // 订单状态
    if (nil != self.myOrder.orderStatus) {
        
        SectionModel *sectionModel = [[SectionModel alloc]init];
        sectionModel.sectionType = OrderDetialSectionTypeOrderStatus;
        sectionModel.rowInfoCellMarr = [NSMutableArray array];
        
        // 订单状态显示cell
        HXSOrderStatusCell *orderStatusCell = [HXSOrderStatusCell orderStatusCell];
        orderStatusCell.orderStatus = self.myOrder.orderStatus;
        
        RowModel *orderStatusModel =  [[RowModel alloc]init];
        orderStatusModel.cell = orderStatusCell;
        orderStatusModel.cellHeight = 44;
        
        [sectionModel.rowInfoCellMarr addObject:orderStatusModel];
        
        // 订单描述显示cell
        if (nil != self.myOrder.orderStatus.statusSpecStr) {
            
            HXSOrderStatusDescribeCell * orderStatusDescribeCell = [HXSOrderStatusDescribeCell orderStatusDescribeCell];
            orderStatusDescribeCell.orderStatus = self.myOrder.orderStatus;
            
            RowModel *orderStatusDescribeModel = [[RowModel alloc]init];
            orderStatusDescribeModel.cell = orderStatusDescribeCell;
            orderStatusDescribeModel.cellHeight = self.myOrder.orderStatus.cellHeight;
            
            [sectionModel.rowInfoCellMarr addObject:orderStatusDescribeModel];
        }
        
        [self.dataMArr addObject:sectionModel];
    }
}

- (void)countdownInfo
{
    // 倒计时
    if (0 < self.myOrder.orderStatus.invalidTimeStr.length) {
        
        SectionModel *sectionModel = [[SectionModel alloc]init];
        sectionModel.sectionType = OrderDetialSectionTypeOrderCountdown;
        sectionModel.rowInfoCellMarr = [NSMutableArray array];
        
        HXSOrderCountdownCell *orderCountdownCell = [HXSOrderCountdownCell orderCountdownCell];
        [orderCountdownCell initialInvalidTimeStr:self.myOrder.orderStatus.invalidTimeStr currentTimeStr:self.myOrder.orderStatus.currentTimeStr];
        orderCountdownCell.delegate = self;
        
        RowModel *orderCountdownModel = [[RowModel alloc]init];
        orderCountdownModel.cell = orderCountdownCell;
        orderCountdownModel.cellHeight = 72;
        
        [sectionModel.rowInfoCellMarr addObject:orderCountdownModel];
        
        [self.dataMArr addObject:sectionModel];
    }
}

- (void)timeLineInfo
{
    // 时间轴
    if (0 < [self.myOrder.timelineStatusArr count]) {
        
        SectionModel *sectionModel = [[SectionModel alloc] init];
        sectionModel.sectionType = OrderDetialSectionTypeOrderTimeLine;
        sectionModel.rowInfoCellMarr = [NSMutableArray array];
        
        HXSOrderTimeLineCell *orderTimeLineCell = [HXSOrderTimeLineCell orderTimeLineCell];
        orderTimeLineCell.timelineStatusArr = self.myOrder.timelineStatusArr;
        
        RowModel *orderTimeLineModel = [[RowModel alloc]init];
        orderTimeLineModel.cell = orderTimeLineCell;
        orderTimeLineModel.cellHeight = 72;
        
        [sectionModel.rowInfoCellMarr addObject:orderTimeLineModel];
        
        [self.dataMArr addObject:sectionModel];
    }
    
}

- (void)buyyerInfo
{
    // 收货人信息
    if (nil != self.myOrder.buyerAddress) {
        
        SectionModel *sectionModel = [[SectionModel alloc]init];
        sectionModel.sectionType = OrderDetialSectionTypeBuyerInfo;
        sectionModel.rowInfoCellMarr = [NSMutableArray array];
        
        HXSOrderConsigneeInfoCell *orderConsigneeInfoCell = [HXSOrderConsigneeInfoCell orderConsigneeInfoCell];
        orderConsigneeInfoCell.buyerAddress = self.myOrder.buyerAddress;
        
        RowModel *orderConsigneeInfoModel = [[RowModel alloc]init];
        orderConsigneeInfoModel.cell = orderConsigneeInfoCell;
        orderConsigneeInfoModel.cellHeight = self.myOrder.buyerAddress.cellHeight;
        
        [sectionModel.rowInfoCellMarr addObject:orderConsigneeInfoModel];
        
        [self.dataMArr addObject:sectionModel];
    }
}

- (void)goodsInfo
{
    // 店铺商品信息
    if(0 < [self.myOrder.orderItemsArr count] ) {
        SectionModel *sectionModel = [[SectionModel alloc]init];
        sectionModel.sectionType = OrderDetialSectionTypeGoodsList;
        sectionModel.rowInfoCellMarr = [NSMutableArray array];
        
        // 店铺信息
        HXShopNameAndOrderStatusCell *shopNameAndOrderStatusCell = [HXShopNameAndOrderStatusCell shopNameAndOrderStatusCell];
        shopNameAndOrderStatusCell.shopInfo = self.myOrder.shopInfo;
        shopNameAndOrderStatusCell.shopHeadImageView.hidden = YES;
        
        RowModel *shopNameAndOrderStatusModel = [[RowModel alloc]init];
        shopNameAndOrderStatusModel.cell = shopNameAndOrderStatusCell;
        shopNameAndOrderStatusModel.cellHeight = 50.0;
        
        [sectionModel.rowInfoCellMarr addObject:shopNameAndOrderStatusModel];
        
        // 商品信息
        
        for (HXSMyOrderItem *item in self.myOrder.orderItemsArr) {
            
            HXSGoodsInfoCell *goodsInfoCell = [HXSGoodsInfoCell goodsInfoCell];
            goodsInfoCell.myOrderItem = item;
            
            RowModel *goodsInfoModel = [[RowModel alloc]init];
            goodsInfoModel.cell = goodsInfoCell;
            goodsInfoModel.cellHeight = 80.0;
            
            [sectionModel.rowInfoCellMarr addObject:goodsInfoModel];
        }
        
        [self.dataMArr addObject:sectionModel];
    }
    
}

- (void)stageInfo
{
    // 分期信息
    if (nil != self.myOrder.stagingInfo) {
        
        SectionModel *sectionModel = [[SectionModel alloc]init];
        sectionModel.sectionType = OrderDetialSectionTypeBuyerInfo;
        sectionModel.rowInfoCellMarr = [NSMutableArray array];
        
        HXSInstalmentInfoCell *cell = [HXSInstalmentInfoCell instalmentInfoCell];
        cell.stagingInfo = self.myOrder.stagingInfo;
        
        RowModel *rowModel = [[RowModel alloc]init];
        rowModel.cell = cell;
        rowModel.cellHeight = 90.0;
        
        [sectionModel.rowInfoCellMarr addObject:rowModel];
        
        [self.dataMArr addObject:sectionModel];
    }
    
}

- (void)billInfo
{
    // 账单信息
    SectionModel *billSectionModel = [[SectionModel alloc]init];
    billSectionModel.sectionType = OrderDetialSectionTypeBillInfo;
    billSectionModel.rowInfoCellMarr = [NSMutableArray array];
    
    // 顶部留有10个像素的空白
    HXSOrderSpaceCell * heaadSpaceCell = [HXSOrderSpaceCell orderSpaceCell];
    RowModel *heaadSpaceModel = [[RowModel alloc]init];
    heaadSpaceModel.cell = heaadSpaceCell;
    heaadSpaceModel.cellHeight = 10.0;
    [billSectionModel.rowInfoCellMarr addObject:heaadSpaceModel];
    
    // 其他优惠信息
    if (self.myOrder.couponItemsArr && self.myOrder.couponItemsArr.count > 0) {
        
        for (HXSCouponItem *item in self.myOrder.couponItemsArr) {
            
            HXSOrderBillItemCell *couponItemCell = [HXSOrderBillItemCell orderBillItemCell];
            couponItemCell.couponItem = item;
            
            if (0 >= item.couponAmountDecNum.floatValue) {
                continue;
            } else {
                RowModel *rowModel = [[RowModel alloc]init];
                rowModel.cell = couponItemCell;
                rowModel.cellHeight = 25.0;
                [billSectionModel.rowInfoCellMarr addObject:rowModel];
            }
        }
    }
    
    // 配送费
    if (nil != self.myOrder.orderDetailInfo.deliveryFeeDecNum && (0 < self.myOrder.orderDetailInfo.deliveryFeeDecNum.floatValue)) {
        
        HXSOrderBillItemCell *deliveryFeeCell = [HXSOrderBillItemCell orderBillItemCell];
        deliveryFeeCell.deliveryFeeStr = [self.myOrder.orderDetailInfo.deliveryFeeDecNum yuanString];
        
        RowModel *rowModel = [[RowModel alloc]init];
        rowModel.cell = deliveryFeeCell;
        rowModel.cellHeight = 25.0;
        
        [billSectionModel.rowInfoCellMarr addObject:rowModel];
    }
    
    // 实付信息
    if (nil != self.myOrder.orderDetailInfo.payAmountDecNum) {
        
        HXSOrderBillItemCell *totalAmountCell = [HXSOrderBillItemCell orderBillItemCell];
        totalAmountCell.totalAmountStr = [self.myOrder.orderDetailInfo.payAmountDecNum yuanString];
        
        RowModel *rowModel = [[RowModel alloc]init];
        rowModel.cell = totalAmountCell;
        rowModel.cellHeight = 25.0;
        [billSectionModel.rowInfoCellMarr addObject:rowModel];
    }
    
    // 底部留有10个像素的空白
    HXSOrderSpaceCell * footSpaceCell = [HXSOrderSpaceCell orderSpaceCell];
    RowModel *footSpaceModel = [[RowModel alloc]init];
    footSpaceModel.cell = footSpaceCell;
    footSpaceModel.cellHeight = 10.0;
    [billSectionModel.rowInfoCellMarr addObject:footSpaceModel];
    
    [self.dataMArr addObject:billSectionModel];
}

- (void)customerServiceInfo
{
    if (nil != self.myOrder.shopInfo.sellerPhoneStr) {
        
        SectionModel *sectionModel = [[SectionModel alloc]init];
        sectionModel.sectionType = OrderDetialSectionTypeCustomerService;
        sectionModel.rowInfoCellMarr = [NSMutableArray array];
        
        HXSOrderCustomerServiceCell *cell = [HXSOrderCustomerServiceCell orderCustomerServiceCell];
        cell.delegate  = self;
        
        RowModel *rowModel = [[RowModel alloc]init];
        rowModel.cell = cell;
        rowModel.cellHeight = 44.0;
        [sectionModel.rowInfoCellMarr addObject:rowModel];
        
        [self.dataMArr addObject:sectionModel];
    }
    
}

- (void)orderInfo
{
    // 订单的其他信息
    if (nil != self.myOrder.orderDetailInfo) {
        
        SectionModel *sectionModel = [[SectionModel alloc]init];
        sectionModel.sectionType = OrderDetialSectionTypeOrderInfo;
        sectionModel.rowInfoCellMarr = [NSMutableArray array];
        
        // 顶部留有10个像素的空白
        HXSOrderSpaceCell * heaadSpaceCell = [HXSOrderSpaceCell orderSpaceCell];
        RowModel *heaadSpaceModel = [[RowModel alloc]init];
        heaadSpaceModel.cell = heaadSpaceCell;
        heaadSpaceModel.cellHeight = 10.0;
        [sectionModel.rowInfoCellMarr addObject:heaadSpaceModel];
        
        HXSOrderDetailInfo *detialInfo = self.myOrder.orderDetailInfo;
        CGFloat rowHeiht = 25.0;
        // 订单号
        if (detialInfo.orderIdStr.length > 0) {
            
            HXSOrderDetialInfoCell *cell = [HXSOrderDetialInfoCell orderDetialInfoCell];
            cell.showStr = [NSString stringWithFormat:@"订单号：%@",detialInfo.orderIdStr];
            
            RowModel *rowModel = [[RowModel alloc]init];
            rowModel.cell = cell;
            rowModel.cellHeight = rowHeiht;
            
            [sectionModel.rowInfoCellMarr addObject:rowModel];
        }
        
        // 支付方式
        if (detialInfo.payMethodStr.length > 0) {
            
            HXSOrderDetialInfoCell *cell = [HXSOrderDetialInfoCell orderDetialInfoCell];
            cell.showStr = [NSString stringWithFormat:@"支付方式：%@",detialInfo.payMethodStr];
            
            RowModel *rowModel = [[RowModel alloc]init];
            rowModel.cell = cell;
            rowModel.cellHeight = rowHeiht;
            
            [sectionModel.rowInfoCellMarr addObject:rowModel];
        }
        
        // 下单时间
        if (detialInfo.orderTimeStr.length > 0) {
            
            HXSOrderDetialInfoCell *cell = [HXSOrderDetialInfoCell orderDetialInfoCell];
            cell.showStr = [NSString stringWithFormat:@"下单时间：%@",[NSDate stringFromSecondsSince1970:(detialInfo.orderTimeStr.longLongValue / 1000) format:@"YYYY-MM-dd HH:mm:ss"]];
            
            RowModel *rowModel = [[RowModel alloc]init];
            rowModel.cell = cell;
            rowModel.cellHeight = rowHeiht;
            
            [sectionModel.rowInfoCellMarr addObject:rowModel];
            
        }
        
        // 支付时间
        if(detialInfo.payTimeStr.length > 0) {
            
            HXSOrderDetialInfoCell *cell = [HXSOrderDetialInfoCell orderDetialInfoCell];
            cell.showStr = [NSString stringWithFormat:@"支付时间：%@",[NSDate stringFromSecondsSince1970:detialInfo.payTimeStr.longLongValue/1000 format:@"YYYY-MM-dd HH:mm:ss"]];
            
            RowModel *rowModel = [[RowModel alloc]init];
            rowModel.cell = cell;
            rowModel.cellHeight = rowHeiht;
            
            [sectionModel.rowInfoCellMarr addObject:rowModel];
            
        }
        
        // 完成时间
        if(detialInfo.deliveredTimeStr.length > 0) {
            
            HXSOrderDetialInfoCell *cell = [HXSOrderDetialInfoCell orderDetialInfoCell];
            cell.showStr = [NSString stringWithFormat:@"完成时间：%@",[NSDate stringFromSecondsSince1970:detialInfo.deliveredTimeStr.longLongValue/1000 format:@"YYYY-MM-dd HH:mm:ss"]];
            
            RowModel *rowModel = [[RowModel alloc]init];
            rowModel.cell = cell;
            rowModel.cellHeight = rowHeiht;
            
            [sectionModel.rowInfoCellMarr addObject:rowModel];
            
        }
        
        // 取消时间
        if(detialInfo.deliveredTimeStr.length > 0) {
            
            HXSOrderDetialInfoCell *cell = [HXSOrderDetialInfoCell orderDetialInfoCell];
            cell.showStr = [NSString stringWithFormat:@"取消时间：%@",[NSDate stringFromSecondsSince1970:detialInfo.cancelTimeStr.longLongValue/1000 format:@"YYYY-MM-dd HH:mm:ss"]];
            
            RowModel *rowModel = [[RowModel alloc]init];
            rowModel.cell = cell;
            rowModel.cellHeight = rowHeiht;
            
            [sectionModel.rowInfoCellMarr addObject:rowModel];
        
                }
        
        // 退款时间
        if(detialInfo.refundTimeStr.length > 0) {
            
            HXSOrderDetialInfoCell *cell = [HXSOrderDetialInfoCell orderDetialInfoCell];
            cell.showStr = [NSString stringWithFormat:@"退款时间：%@",[NSDate stringFromSecondsSince1970:detialInfo.refundTimeStr.longLongValue/1000 format:@"YYYY-MM-dd HH:mm:ss"]];
            
            RowModel *rowModel = [[RowModel alloc]init];
            rowModel.cell = cell;
            rowModel.cellHeight = rowHeiht;
            
            [sectionModel.rowInfoCellMarr addObject:rowModel];
            
        }
        
        // 物流单号
        if(detialInfo.deliveredNumStr.length > 0) {
            
            HXSOrderDetialInfoCell *cell = [HXSOrderDetialInfoCell orderDetialInfoCell];
            cell.showStr = [NSString stringWithFormat:@"物流单号：%@",detialInfo.deliveredNumStr];
            
            RowModel *rowModel = [[RowModel alloc]init];
            rowModel.cell = cell;
            rowModel.cellHeight = rowHeiht;
            
            [sectionModel.rowInfoCellMarr addObject:rowModel];
            
        }
        
        // 物流公司
        if(detialInfo.deliveredCompanyStr.length > 0) {
            
            HXSOrderDetialInfoCell *cell = [HXSOrderDetialInfoCell orderDetialInfoCell];
            cell.showStr = [NSString stringWithFormat:@"物流公司：%@",detialInfo.deliveredCompanyStr];
            
            RowModel *rowModel = [[RowModel alloc]init];
            rowModel.cell = cell;
            rowModel.cellHeight = rowHeiht;
            
            [sectionModel.rowInfoCellMarr addObject:rowModel];
            
        }
        
        // 取消理由
        if (detialInfo.cancelReasonStr.length > 0) {
            
            HXSOrderDetialInfoCell *cell = [HXSOrderDetialInfoCell orderDetialInfoCell];
            cell.showStr = [NSString stringWithFormat:@"取消理由：%@",detialInfo.cancelReasonStr];
            
            RowModel *rowModel = [[RowModel alloc]init];
            rowModel.cell = cell;
            rowModel.cellHeight = detialInfo.cancelReasonCellHeight;
            
            [sectionModel.rowInfoCellMarr addObject:rowModel];
        }
        
        // 底部留有10个像素的空白
        HXSOrderSpaceCell * footSpaceCell = [HXSOrderSpaceCell orderSpaceCell];
        RowModel *footSpaceModel = [[RowModel alloc]init];
        footSpaceModel.cell = footSpaceCell;
        footSpaceModel.cellHeight = 10.0;
        [sectionModel.rowInfoCellMarr addObject:footSpaceModel];
        
        [self.dataMArr addObject:sectionModel];
    }
}


#pragma mark - HXSOrderCountdownCellDelegate

- (void)orderCountdownCellCountdownOver
{
    if ([self.delegate respondsToSelector:@selector(countdownOver)]) {
        [self.delegate countdownOver];
    }
}


#pragma mark - HXSOrderCustomerServiceCellDelegate

- (void)contactMerchant
{
    if ([self.delegate respondsToSelector:@selector(contactMerchant)]) {
        [self.delegate contactMerchant];
    }
}


#pragma mark - Setter

- (void)setMyOrder:(HXSMyOrder *)myOrder
{
    _myOrder = myOrder;
    [self updateDataMarr];
}



@end
