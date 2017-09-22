//
//  HXSExchangeCouponViewController.h
//  store
//
//  Created by 格格 on 16/10/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@protocol HXSExchangeCouponViewControllerDelegate <NSObject>

- (void)exchangeCouponSuccessed;

@end

@interface HXSExchangeCouponViewController : HXSBaseViewController

@property (nonatomic, weak) id<HXSExchangeCouponViewControllerDelegate> delegate;

+ (instancetype)exchangeCouponViewController;

@end
