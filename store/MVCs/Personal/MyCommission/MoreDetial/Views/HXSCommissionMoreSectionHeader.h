//
//  HXSCommissionMoreSectionHeader.h
//  store
//
//  Created by 格格 on 16/10/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXSCommission.h"

@protocol HXSCommissionMoreSectionHeaderDelegate <NSObject>

- (void)selectTimeChange;

@end

@interface HXSCommissionMoreSectionHeader : UIView

@property (nonatomic, strong) HXSCommission *commission;
@property (nonatomic, strong) NSNumber *startDateTimestamp;
@property (nonatomic, strong) NSNumber *endDateTimestamp;

@property (nonatomic, weak) id<HXSCommissionMoreSectionHeaderDelegate> delegate;

+ (instancetype)sectionHeader;

@end
