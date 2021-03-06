//
//  HXSMyOrderHeaderTableViewCell.h
//  store
//
//  Created by ArthurWang on 15/7/28.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSPrintOrderInfo;
@class HXSBoxOrderEntity;
@class HXSStoreOrderEntity;
@class HXSBoxOrderModel;

@interface HXSMyOrderHeaderTableViewCell : UITableViewCell

/**  夜猫店订单列表, 信用购订单列表 */
@property (nonatomic, weak) HXSOrderInfo *orderInfo;
/** 盒子订单列表 */
@property (nonatomic, weak) HXSBoxOrderEntity *boxOrderEntity;
/** 云印店 */
@property (nonatomic, weak) HXSPrintOrderInfo *printOrder;
/** 云超市(便利店/水果店) */
@property (nonatomic, strong) HXSStoreOrderEntity *storeOrder;

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;

/** 信用购列表显示 其他列表不显示 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelLeftConstraint;

/** 4.2 零食盒子添加 */
@property (nonatomic, strong) HXSBoxOrderModel *boxOrderModel;

@end