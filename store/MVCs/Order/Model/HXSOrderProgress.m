//
//  HXSOrderProgress.m
//  store
//
//  Created by 格格 on 16/8/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  记录订单进度信息

#import "HXSOrderProgress.h"

@implementation HXSOrderProgress


#pragma mark - override

- (instancetype)init
{
    self = [super init];
    if(self) {
        self.progressType = HXSOrderProgressTypeAll;
        self.orderNum = 0;
        return self;
    }
    return nil;
}


#pragma mark - Setter

- (void)setProgressType:(HXSOrderProgressType)progressType
{
    _progressType = progressType;
}

- (void)setOrderNum:(NSInteger)orderNum
{
    _orderNum = orderNum;
}


#pragma mark - Getter

- (NSString *)orderProgressName
{
    /**
     
     case HXSOrderProgressTypeToBeFahuo:
     return @"待发货";
     break;
     case HXSOrderProgressTypeToBeShouhuo:
     return @"待收货";
     break;
     */
    //HXSOrderProgressTypeOngoing 进行中
    switch (self.progressType) {
        case HXSOrderProgressTypeAll:
            return @"全部订单";
            break;
        case HXSOrderProgressTypeToBePaid:
            return @"待付款";
            break;
        case HXSOrderProgressTypeOngoing:
            return @"进行中";
            break;
        case HXSOrderProgressTypeToEvaluate:
            return @"待评价";
            break;
        case HXSOrderProgressTypeRefundOrAfterSale:
            return @"退款/售后";
            break;
        default:
            return @"";
            break;
    }
}

- (NSString *)showName
{
    if(self.orderNum > 0) {
        return [NSString stringWithFormat:@"%@(%ld)",self.orderProgressName, (long)self.orderNum];
    } else {
        return self.orderProgressName;
    }
}

- (NSString *)fatchName
{
    switch (self.progressType) {
        case HXSOrderProgressTypeAll:
            return @"all";
            break;
        case HXSOrderProgressTypeToBePaid:
            return @"unpaid";
            break;
        case HXSOrderProgressTypeOngoing:
            return @"processing";
            break;
        case HXSOrderProgressTypeToEvaluate:
            return @"tobecomment";
            break;
        case HXSOrderProgressTypeRefundOrAfterSale:
            return @"refund";
            break;
        default:
            return @"all";
            break;
    }
}

@end
