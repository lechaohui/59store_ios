//
//  HXSOrderListViewController.h
//  store
//
//  Created by 格格 on 16/8/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@class HXSOrderProgress;

@interface HXSOrderListViewController : HXSBaseViewController

/** 记录该列表展示的订单分类 一定要赋值 */
@property (nonatomic, strong) HXSOrderProgress *orderProgress;
/** 订单状态改变 */
@property (nonatomic, strong) void (^ orderDetialStatusChange) ();

+ (HXSOrderListViewController *)controllerWithOrderProgress:(HXSOrderProgress *)orderProgress;

- (void)refresh;

@end
