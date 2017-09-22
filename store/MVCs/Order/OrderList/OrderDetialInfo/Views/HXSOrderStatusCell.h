//
//  HXSOrderStatusCell.h
//  store
//
//  Created by 格格 on 16/8/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSMyOrder.h"

@interface HXSOrderStatusCell : UITableViewCell

@property (nonatomic,strong) HXSOrderStatus *orderStatus;

+ (instancetype)orderStatusCell;

@end
