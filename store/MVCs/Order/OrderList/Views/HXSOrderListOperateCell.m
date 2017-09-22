//
//  HXSOrderListOperateCell.m
//  store
//
//  Created by 格格 on 16/10/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSOrderListOperateCell.h"

static CGFloat const payNowButtonWidth              = 71.0;
static CGFloat const cancleButtonWidth              = 71.0;
static CGFloat const participateDetialBuutonWidth   = 95.0;
static CGFloat const groupDetialButtonWidth         = 95.0;
static CGFloat const evaluationButtonWidth          = 95.0;
static CGFloat const joinGroupButtonWidth           = 95.0;

static CGFloat const spacing                        = 10;


@interface HXSOrderListOperateCell ()

@property (nonatomic, weak) IBOutlet UIButton *payNowButton;
@property (nonatomic, weak) IBOutlet UIButton *cancleButton;
@property (nonatomic, weak) IBOutlet UIButton *participateDetialBuuton;
@property (nonatomic, weak) IBOutlet UIButton *groupDetialButton;
@property (nonatomic, weak) IBOutlet UIButton *evaluationButton;
@property (weak, nonatomic) IBOutlet UIButton *joinGroupButton;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *payNowButtonLayoutRight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *cancleButtonLayoutRight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *participateDetialBuutonLayoutRight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *groupDetialButtonLayoutRight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *evaluationButtonLayoutRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *joinGroupLayoutRight;

@end

@implementation HXSOrderListOperateCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.payNowButton setBackgroundColor:[UIColor clearColor]];
    self.payNowButton.layer.cornerRadius = 4;
    self.payNowButton.layer.borderColor = [UIColor colorWithRGBHex:0xf54642].CGColor;
    self.payNowButton.layer.borderWidth = 1;
    self.payNowButton.layer.masksToBounds = YES;
    [self.payNowButton setTitleColor:[UIColor colorWithRGBHex:0xf54642] forState:UIControlStateNormal];
    
    [self.cancleButton setBackgroundColor:[UIColor clearColor]];
    self.cancleButton.layer.cornerRadius = 4;
    self.cancleButton.layer.borderColor = [UIColor colorWithRGBHex:0x333333].CGColor;
    self.cancleButton.layer.borderWidth = 1;
    self.cancleButton.layer.masksToBounds = YES;
    
    [self.participateDetialBuuton setBackgroundColor:[UIColor clearColor]];
    self.participateDetialBuuton.layer.cornerRadius = 4;
    self.participateDetialBuuton.layer.borderColor = [UIColor colorWithRGBHex:0x333333].CGColor;
    self.participateDetialBuuton.layer.borderWidth = 1;
    self.participateDetialBuuton.layer.masksToBounds = YES;
    
    [self.groupDetialButton setBackgroundColor:[UIColor clearColor]];
    self.groupDetialButton.layer.cornerRadius = 4;
    self.groupDetialButton.layer.borderColor = [UIColor colorWithRGBHex:0x333333].CGColor;
    self.groupDetialButton.layer.borderWidth = 1;
    self.groupDetialButton.layer.masksToBounds = YES;
    
    [self.evaluationButton setBackgroundColor:[UIColor clearColor]];
    self.evaluationButton.layer.cornerRadius = 4;
    self.evaluationButton.layer.borderColor = [UIColor colorWithRGBHex:0x333333].CGColor;
    self.evaluationButton.layer.borderWidth = 1;
    self.evaluationButton.layer.masksToBounds = YES;
    
    [self.joinGroupButton setBackgroundColor:[UIColor clearColor]];
    self.joinGroupButton.layer.cornerRadius = 4;
    self.joinGroupButton.layer.borderColor = [UIColor colorWithRGBHex:0xf54642].CGColor;
    self.joinGroupButton.layer.borderWidth = 1;
    self.joinGroupButton.layer.masksToBounds = YES;
    [self.joinGroupButton setTitleColor:[UIColor colorWithRGBHex:0xf54642] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)refresh
{
    // 界面只展示需要展示的
    self.payNowButton.hidden            = YES;
    self.cancleButton.hidden            = YES;
    self.participateDetialBuuton.hidden = YES;
    self.groupDetialButton.hidden       = YES;
    self.evaluationButton.hidden        = YES;
    self.joinGroupButton.hidden         = YES;
    
    CGFloat layoutRight = 15;
    
    for (NSInteger i = self.myOrder.viewButtonArr.count - 1 ; i >= 0 ; i--) {
        
        NSNumber * num = [self.myOrder.viewButtonArr objectAtIndex:i];
        switch (num.integerValue) {
            case HXSOrderDetialOperateTypeCancle:
            {
                self.cancleButtonLayoutRight.constant = layoutRight;
                layoutRight += cancleButtonWidth + spacing;

                self.cancleButton.hidden = NO;
            }
                break;
            case HXSOrderDetialOperateTypePay:
            {
                self.payNowButtonLayoutRight.constant = layoutRight;
                layoutRight += payNowButtonWidth + spacing;
                
                self.payNowButton.hidden = NO;
            }
                break;
            case HXSOrderDetialOperateTypeEvaluation:
            {
                self.evaluationButtonLayoutRight.constant = layoutRight;
                self.evaluationButton.hidden = NO;
                
                layoutRight += evaluationButtonWidth + spacing;
            }
                break;
            case HXSOrderDetialOperateTypeParticipate:
            {
                self.participateDetialBuutonLayoutRight.constant = layoutRight;
                self.participateDetialBuuton.hidden = NO;
                
                layoutRight += participateDetialBuutonWidth + spacing;
            }
                break;
            case HXSOrderDetialOperateTypeGroup:
            {
                self.groupDetialButtonLayoutRight.constant = layoutRight;
                self.groupDetialButton.hidden = NO;
                
                layoutRight += groupDetialButtonWidth + spacing;
            }
                break;
                
            case HXSOrderDetialOperateTypeJoinGroup:
            {
                self.joinGroupLayoutRight.constant = layoutRight;
                self.joinGroupButton.hidden = NO;
                
                layoutRight += joinGroupButtonWidth + spacing;
            }
                break;
            default:
                break;
        }
    }

}

- (IBAction)buttconClicked:(UIButton *)sender
{
    if (sender == self.payNowButton) {
        
        if ([self.delegate respondsToSelector:@selector(operateViewPayNowButtonClicked:)]) {
            [self.delegate operateViewPayNowButtonClicked:self.myOrder];
        }
    
    } else if (sender == self.cancleButton) {
        
        if ([self.delegate respondsToSelector:@selector(operateViewCancleButtonClicked:)]) {
            [self.delegate operateViewCancleButtonClicked:self.myOrder];
        }
        
    } else if (sender == self.participateDetialBuuton) {
        
        if ([self.delegate respondsToSelector:@selector(operateViewCheckDetailOfParticipateButtonClicked:)]) {
            [self.delegate operateViewCheckDetailOfParticipateButtonClicked:self.myOrder];
        }
        
    } else if (sender == self.groupDetialButton) {
        
        if ([self.delegate respondsToSelector:@selector(operateViewCheckDetailOfGroupButtonClicked:)]) {
            [self.delegate operateViewCheckDetailOfGroupButtonClicked:self.myOrder];
        }
        
    } else if (sender == self.evaluationButton) {
        
        if ([self.delegate respondsToSelector:@selector(operateViewEvaluationButtonClicked:)]) {
            [self.delegate operateViewEvaluationButtonClicked:self.myOrder];
        }
        
    } else if (sender == self.joinGroupButton) {
        if ([self.delegate respondsToSelector:@selector(operateViewJoinGroupButtonClicked:)]) {
            [self.delegate operateViewJoinGroupButtonClicked:self.myOrder];
        }
    } else {
    // do nothing
    }

}

- (void)setMyOrder:(HXSMyOrder *)myOrder
{
    _myOrder = myOrder;
    
    [self refresh];
}


@end
