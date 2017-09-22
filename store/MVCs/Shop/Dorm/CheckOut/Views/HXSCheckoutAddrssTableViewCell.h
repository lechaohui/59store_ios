//
//  HXSCheckoutAddrssTableViewCell.h
//  store
//
//  Created by  黎明 on 16/8/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//
/************************************************************
 *  确认订单的收货人信息显示【收货人姓名。电话。地址】
 ***********************************************************/

#import <UIKit/UIKit.h>

@interface HXSCheckoutAddrssTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingAddressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressHeightConstraint;

@end
