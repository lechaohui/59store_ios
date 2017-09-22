//
//  HXShopNameAndOrderStatusCell.h
//  store
//
//  Created by 格格 on 16/8/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXSMyOrder.h"

@interface HXShopNameAndOrderStatusCell : UITableViewCell

/** 订单列表使用 */
@property (nonatomic,strong) HXSMyOrder *myOrder;
/** 订单详情使用 */
@property (nonatomic,strong) HXShopInfo *shopInfo;

@property (nonatomic, weak) IBOutlet UIImageView *shopHeadImageView;  // 店铺头像

+ (instancetype)shopNameAndOrderStatusCell;

@end
