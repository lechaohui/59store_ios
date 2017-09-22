//
//  HXDBaseViewController.h
//  store
//
//  Created by ranliang on 15/4/14.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *networkingErrorStr = @"系统异常，59攻城狮正在玩命抢修中~";

@class HXSWarningBarView;

@interface HXDBaseViewController : UIViewController

@property (nonatomic, strong) HXSWarningBarView *warnBarView;
@property (nonatomic, assign, getter=isFirstLoading) BOOL firstLoading;

- (void)showWarning:(NSString *)wStr;
- (void)addLeftBarButtonItemWithImageName:(NSString *)imageName;
- (void)initialNavigationLeftItem;

- (void)replaceCurrentViewControllerWith:(UIViewController *)viewController animated:(BOOL)animated;

- (void)showNoDataImageWithMessage:(NSString *)message;
- (void)hideNoDataImage;

- (void)showNetworkingErrorWithMessage:(NSString *)message;

- (void)back;

@end

