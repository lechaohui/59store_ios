//
//  HXSOrderAppraiseViewController.h
//  store
//
//  Created by 格格 on 16/8/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSMyOrder.h"

@protocol HXSOrderAppraiseViewControllerDelegate <NSObject>

// 评价成功
- (void)appraiseSuccess;

@end

@interface HXSOrderAppraiseViewController : HXSBaseViewController

@property (nonatomic, weak) id<HXSOrderAppraiseViewControllerDelegate> delegate;

+ (instancetype)controllerWithShopInfo:(HXShopInfo *)shopInfo
                               orderId:(NSString *)order_id;

@end
