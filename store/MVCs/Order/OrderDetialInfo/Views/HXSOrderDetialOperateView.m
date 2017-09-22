//
//  HXSOrderDetialOperateView.m
//  store
//
//  Created by 格格 on 16/9/6.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSOrderDetialOperateView.h"

/* 按钮高度比设计高了一个像素，高出的一个像素作为下面边框，需要将其隐藏 */
static CGFloat const buttonHeight           = 45.0;
static CGFloat const cancleOrPayButtonWidth = 120.0;
static CGFloat const otherButtonWidth       = 156.0;
static NSInteger const textSize             = 17;

@interface HXSOrderDetialOperateView()

@property (nonatomic, strong) UIButton *payNowButton;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) UIButton *participateDetialBuuton;
@property (nonatomic, strong) UIButton *groupDetialButton;
@property (nonatomic, strong) UIButton *evaluationButton;
@property (nonatomic, strong) UIButton *joinGroupButton;

@end


@implementation HXSOrderDetialOperateView

- (void)layoutSubviews
{
    if (nil == self.viewButtonArr) {
        return;
    }
    
    // 界面只展示需要展示的
    self.payNowButton.hidden                = YES;
    self.cancleButton.hidden                = YES;
    self.participateDetialBuuton.hidden     = YES;
    self.groupDetialButton.hidden           = YES;
    self.evaluationButton.hidden            = YES;
    self.joinGroupButton.hidden             = YES;
    
    // button 的x位置
    CGFloat x = SCREEN_WIDTH + 1;
    for (NSInteger i = self.viewButtonArr.count - 1 ; i >= 0 ; i--) {
        
        NSNumber * num = [self.viewButtonArr objectAtIndex:i];
        switch (num.integerValue) {
            case HXSOrderDetialOperateTypeCancle:
            {
                x -= cancleOrPayButtonWidth;
                self.cancleButton.frame = CGRectMake(x, 0, cancleOrPayButtonWidth, buttonHeight);
                self.cancleButton.hidden = NO;
            }
                break;
            case HXSOrderDetialOperateTypePay:
            {
                x -= cancleOrPayButtonWidth;
                self.payNowButton.frame = CGRectMake(x, 0, cancleOrPayButtonWidth, buttonHeight);
                self.payNowButton.hidden = NO;
            }
                break;
            case HXSOrderDetialOperateTypeEvaluation:
            {
                x -= otherButtonWidth;
                self.evaluationButton.frame = CGRectMake(x, 0, otherButtonWidth, buttonHeight);
                self.evaluationButton.hidden = NO;
            }
                break;
            case HXSOrderDetialOperateTypeParticipate:
            {
                x -= otherButtonWidth;
                self.participateDetialBuuton.frame = CGRectMake(x, 0, otherButtonWidth, buttonHeight);
                self.participateDetialBuuton.hidden = NO;
            }
                break;
            case HXSOrderDetialOperateTypeGroup:
            {
                x -= otherButtonWidth;
                self.groupDetialButton.frame = CGRectMake(x, 0, otherButtonWidth, buttonHeight);
                self.groupDetialButton.hidden = NO;
            }
                break;
                
            case HXSOrderDetialOperateTypeJoinGroup:
            {
                x -= otherButtonWidth;
                self.joinGroupButton.frame = CGRectMake(x, 0, otherButtonWidth, buttonHeight);
                self.joinGroupButton.hidden = NO;
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - Target/Action

- (void)payNowButtonClicked
{
    if ([self.delegate respondsToSelector:@selector(operateViewPayNowButtonClicked)]) {
        [self.delegate operateViewPayNowButtonClicked];
    }
}

- (void)cancleButtonClicked
{
    if ([self.delegate respondsToSelector:@selector(operateViewCancleButtonClicked)]) {
        [self.delegate operateViewCancleButtonClicked];
    }
}

- (void)participateDetialBuutonClicked
{
    if ([self.delegate respondsToSelector:@selector(operateViewCheckDetailOfParticipateButtonClicked)]) {
        [self.delegate operateViewCheckDetailOfParticipateButtonClicked];
    }
}

- (void)groupDetialButtonClicked
{
    if ([self.delegate respondsToSelector:@selector(operateViewCheckDetailOfGroupButtonClicked)]) {
        [self.delegate operateViewCheckDetailOfGroupButtonClicked];
    }
}

- (void)evaluationButtonClicked
{
    if ([self.delegate respondsToSelector:@selector(operateViewEvaluationButtonClicked)]) {
        [self.delegate operateViewEvaluationButtonClicked];
    }
}

- (void)joinGroupButtonClicked
{
    if ([self.delegate respondsToSelector:@selector(operateViewJoinGroupButtonClicked)]) {
        [self.delegate operateViewJoinGroupButtonClicked];
    }
}



#pragma mark - Setter

- (void)setViewButtonArr:(NSArray *)viewButtonArr
{
    _viewButtonArr = viewButtonArr;
    [self layoutSubviews];
}


#pragma mark - Getter

/*
 取消订单 + 立即支付： 订单待支付 && （业务类型 ！= 一元夺宝）
 取消订单：1.夜猫店&&（待接单||配送中） 2.云印店&&待打印 3.品牌馆&&待配送
 查看参与详情：一元夺宝&&（待开奖||已开奖）
 查看约团详情：约团&&（配送中||已完成||退款中||已退款）
 评价得10积分：1.夜猫店&&待评价 2.分期商城&&待评价
*/

- (UIButton *)payNowButton
{
    if (!_payNowButton) {
        
        _payNowButton = [[UIButton alloc]init];
        // 按钮背景为蓝色，字体颜色为白色
        _payNowButton.titleLabel.font = [UIFont systemFontOfSize:textSize];
        [_payNowButton setBackgroundColor:HXS_COLOR_MASTER];
        [_payNowButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [_payNowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_payNowButton addTarget:self
                          action:@selector(payNowButtonClicked)
                forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_payNowButton];
    }
    
    return _payNowButton;
}

- (UIButton *)cancleButton
{
    if (!_cancleButton) {
        _cancleButton = [[UIButton alloc]init];
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:textSize];
        [_cancleButton setBackgroundColor:[UIColor whiteColor]];
        [_cancleButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [_cancleButton setTitleColor:HXS_TITLE_NOMARL_COLOR forState:UIControlStateNormal];
        
        _cancleButton.layer.borderColor = HXS_COLOR_SEPARATION_STRONG.CGColor;
        _cancleButton.layer.borderWidth = 1;
        
        [_cancleButton addTarget:self
                          action:@selector(cancleButtonClicked)
                forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_cancleButton];
    }
 
    return _cancleButton;
}

- (UIButton *)participateDetialBuuton
{
    if (!_participateDetialBuuton) {
        _participateDetialBuuton = [[UIButton alloc]init];
        _participateDetialBuuton.titleLabel.font = [UIFont systemFontOfSize:textSize];
        [_participateDetialBuuton setBackgroundColor:HXS_COLOR_MASTER];
        [_participateDetialBuuton setTitle:@"查看参与详情" forState:UIControlStateNormal];
        [_participateDetialBuuton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_participateDetialBuuton addTarget:self
                          action:@selector(participateDetialBuutonClicked)
                forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_participateDetialBuuton];
    }
    
    return _participateDetialBuuton;
}

- (UIButton *)groupDetialButton
{
    if (!_groupDetialButton) {
        _groupDetialButton = [[UIButton alloc]init];
        _groupDetialButton.titleLabel.font = [UIFont systemFontOfSize:textSize];
        [_groupDetialButton setBackgroundColor:[UIColor whiteColor]];
        [_groupDetialButton setTitle:@"查看约团详情" forState:UIControlStateNormal];
        [_groupDetialButton setTitleColor:HXS_TITLE_NOMARL_COLOR forState:UIControlStateNormal];
        
        _groupDetialButton.layer.borderColor = HXS_COLOR_SEPARATION_STRONG.CGColor;
        _groupDetialButton.layer.borderWidth = 1;
        
        [_groupDetialButton addTarget:self
                                     action:@selector(groupDetialButtonClicked)
                           forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_groupDetialButton];
    }
    
    return _groupDetialButton;
}

- (UIButton *)evaluationButton
{
    if (!_evaluationButton) {
        _evaluationButton = [[UIButton alloc]init];
        _evaluationButton.titleLabel.font = [UIFont systemFontOfSize:textSize];
        [_evaluationButton setBackgroundColor:HXS_COLOR_MASTER];
        [_evaluationButton setTitle:@"评价得10积分" forState:UIControlStateNormal];
        [_evaluationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_evaluationButton addTarget:self
                               action:@selector(evaluationButtonClicked)
                     forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_evaluationButton];
    }
    
    return _evaluationButton;
}

- (UIButton *)joinGroupButton
{
    if (nil == _joinGroupButton) {
        
        _joinGroupButton = [[UIButton alloc]init];
        // 按钮背景为蓝色，字体颜色为白色
        _joinGroupButton.titleLabel.font = [UIFont systemFontOfSize:textSize];
        [_joinGroupButton setBackgroundColor:HXS_COLOR_MASTER];
        [_joinGroupButton setTitle:@"邀请好友约团" forState:UIControlStateNormal];
        [_joinGroupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_joinGroupButton addTarget:self
                          action:@selector(joinGroupButtonClicked)
                forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_joinGroupButton];
    }
    
    return _joinGroupButton;
}


@end
