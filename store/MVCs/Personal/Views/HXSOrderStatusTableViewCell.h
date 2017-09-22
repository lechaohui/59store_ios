//
//  HXSOrderStatusTableViewCell.h
//  store
//
//  Created by caixinye on 2017/9/13.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
/**

 订单状态cell
 
 
 */
#import "HXSPersonalCellButton.h"

typedef NS_ENUM(NSUInteger, HXDOrderStatusButtonType) {
    HXDOrderStatusButtonTypeWaitingBuy = 0,//待付款
    HXDOrderStatusButtonTypeWaitingFahuo,      //待发货
    HXDOrderStatusButtonTypeWaitingshouhuo,   //待收货
    HXDOrderStatusButtonTypeWaitingComment, //待评价
    HXDOrderStatusButtonTypeTuikuan,       //退款，售后
    HXDOrderStatusButtonTypeAll,       //全部订单
    
};

@protocol HXSOrderStatusTableViewCellDelegate <NSObject>

/**
 *
 *
 *  @param type Btn 类型
 */
- (void)clickHXDOrderStatusButtonTypeButtonType:(HXDOrderStatusButtonType)type;


@end

@interface HXSOrderStatusTableViewCell : UITableViewCell

@property (nonatomic, weak) id<HXSOrderStatusTableViewCellDelegate> delegate;

@property(nonatomic,strong) HXSPersonalCellButton*waitBuy;//待付款
@property(nonatomic,strong) HXSPersonalCellButton*waitFahuo;//待发货
@property(nonatomic,strong) HXSPersonalCellButton*waitShouhuo;//待收货
@property(nonatomic,strong) HXSPersonalCellButton*waitCommment;//待评价
@property(nonatomic,strong) HXSPersonalCellButton*waitTuikuan;//退款
@property(nonatomic,strong) HXSPersonalCellButton *seeAllBuu;





@end
