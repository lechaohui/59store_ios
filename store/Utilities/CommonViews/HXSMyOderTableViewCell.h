//
//  HXSMyOderTableViewCell.h
//  store
//
//  Created by ArthurWang on 15/7/28.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSOrderItem;
@class HXSBoxOrderItemEntity;
@class HXSMyPrintOrderItem;
@class HXSMyPrintOrderItem;
@class HXSStoreCartItemEntity;
@class HXSBoxOrderItemModel;

@interface HXSMyOderTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imageImageVeiw;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLaebl;
@property (nonatomic, weak) IBOutlet UILabel *totalAmountLabel;
@property (nonatomic, weak) IBOutlet UILabel *quantityLabel;
/**  信用购 3c 数据详情 */
@property (weak, nonatomic) IBOutlet UILabel *titleDetialLabel;

@property (nonatomic, strong) NSString *itemId;

@property (nonatomic, weak) HXSOrderItem *orderItem;
@property (nonatomic, weak) HXSBoxOrderItemEntity *itemEntity;
@property (nonatomic, weak) HXSMyPrintOrderItem *printItem;
/** 云超市 */
@property (nonatomic, strong) HXSStoreCartItemEntity *storeItemEntity;
/** 零食盒子添加 */
@property (nonatomic, strong) HXSBoxOrderItemModel *boxOrderItemModel; 

@end
