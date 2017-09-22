//
//  HXSCouponListSectionHeaderView.h
//  store
//
//  Created by 格格 on 16/10/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXSCouponListSectionHeaderViewDelegate <NSObject>

- (void)illustrateButtonClicked;

@end

@interface HXSCouponListSectionHeaderView : UIView

@property (nonatomic, strong) NSNumber *dueCountNum;
@property (nonatomic, strong) NSNumber *couponCountNum;;

@property (nonatomic, weak) id<HXSCouponListSectionHeaderViewDelegate> delegate;

+ (instancetype)couponListSectionHeaderView;

@end
