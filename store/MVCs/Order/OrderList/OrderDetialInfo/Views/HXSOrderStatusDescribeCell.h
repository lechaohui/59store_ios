//
//  HXSOrderStatusDescribeCell.h
//  store
//
//  Created by 格格 on 16/9/2.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  订单状态描述

#import <UIKit/UIKit.h>
#import "HXSMyOrder.h"

@interface HXSOrderStatusDescribeCell : UITableViewCell

@property (nonatomic,strong) HXSOrderStatus *orderStatus;

+ (instancetype)orderStatusDescribeCell;

@end
