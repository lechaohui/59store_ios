//
//  HXSOrderListOperateCell.h
//  store
//
//  Created by 格格 on 16/10/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSOrderDetialOperateView.h"

@protocol HXSOrderListOperateCellDelegate <NSObject>

// 点击取消按钮
- (void)operateViewCancleButtonClicked:(HXSMyOrder *)order;
// 点击立即支付按钮
- (void)operateViewPayNowButtonClicked:(HXSMyOrder *)order;
// 查看参与详情
- (void)operateViewCheckDetailOfParticipateButtonClicked:(HXSMyOrder *)order;
// 查看约团详情
- (void)operateViewCheckDetailOfGroupButtonClicked:(HXSMyOrder *)order;
// 评价得10积分按钮点击
- (void)operateViewEvaluationButtonClicked:(HXSMyOrder *)order;
// 邀请好友约团
- (void)operateViewJoinGroupButtonClicked:(HXSMyOrder *)order;

@end

@interface HXSOrderListOperateCell : UITableViewCell

@property (nonatomic, strong) HXSMyOrder *myOrder;
@property (nonatomic, weak) id<HXSOrderListOperateCellDelegate> delegate;

@end
