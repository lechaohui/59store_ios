//
//  HXSOrderDetialOperateView.h
//  store
//
//  Created by 格格 on 16/9/6.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSMyOrder.h"

/** 订单详情操作类型 */
typedef NS_ENUM(NSInteger, HXSOrderDetialOperateType)
{
    HXSOrderDetialOperateTypeCancle         = 0, // 取消订单
    HXSOrderDetialOperateTypePay            = 1, // 立即支付
    HXSOrderDetialOperateTypeEvaluation     = 2, // 评价得10积分
    HXSOrderDetialOperateTypeParticipate    = 3, // 查看参与详情
    HXSOrderDetialOperateTypeGroup          = 4, // 查看约团详情
    HXSOrderDetialOperateTypeJoinGroup      = 5, // 邀请好友参团
};

@class HXSOrderDetialOperateView;

@protocol HXSOrderDetialOperateViewDelegate <NSObject>

// 点击取消按钮
- (void)operateViewCancleButtonClicked;
// 点击立即支付按钮
- (void)operateViewPayNowButtonClicked;
// 查看参与详情
- (void)operateViewCheckDetailOfParticipateButtonClicked;
// 查看约团详情
- (void)operateViewCheckDetailOfGroupButtonClicked;
// 评价得10积分按钮点击
- (void)operateViewEvaluationButtonClicked;
// 邀请好友参团
- (void)operateViewJoinGroupButtonClicked;


@end

@interface HXSOrderDetialOperateView : UIView

@property (nonatomic, strong) NSArray *viewButtonArr;
@property (nonatomic, weak) id<HXSOrderDetialOperateViewDelegate> delegate;

@end
