//
//  HXSCouponListSectionFooterView.h
//  store
//
//  Created by 格格 on 16/10/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXSCouponListFooterViewDelegate <NSObject>

- (void)historyCouponButtonClocked;

@end

@interface HXSCouponListFooterView : UIView

@property (nonatomic, weak) id<HXSCouponListFooterViewDelegate> delegate;

+ (instancetype)footerView;

@end
