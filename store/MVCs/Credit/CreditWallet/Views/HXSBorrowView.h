//
//  HXSBorrowView.h
//  store
//
//  Created by hudezhi on 15/11/5.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXSBalanceView.h"


@protocol HXSBorrowViewDelegate <NSObject>

@optional

/**
 *  clickedConsumeBtn
 */
- (void)gotoWalletView;

/**
 *  clickedEncashmentBtn
 */
- (void)gotoEncashmentView;

/**
 *  clickedInstallmentBtn
 */
- (void)gotoInsatallmentView;

/**
 *  clickedUpgradeBtn,  clickedReuploadtn
 */
- (void)gotoUpgradeView; 

@end

@interface HXSBorrowView : UIView

@property (weak, nonatomic) IBOutlet HXSBalanceView *balanceView;

+ (instancetype)createBorrwViewWithDelegate:(id<HXSBorrowViewDelegate>)delegate;

- (void)updateBorrowView;

@end
