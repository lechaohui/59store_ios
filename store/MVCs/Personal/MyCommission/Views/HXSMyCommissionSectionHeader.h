//
//  HXSMyCommissionSectionHeader.h
//  store
//
//  Created by 格格 on 16/4/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXSMyCommissionSectionHeaderDelegate <NSObject>

- (void)moreDetailsButtonClicked;

@end

@interface HXSMyCommissionSectionHeader : UIView

@property (nonatomic, weak) id<HXSMyCommissionSectionHeaderDelegate> delegate;

+ (id)sectionHeader;

@end
