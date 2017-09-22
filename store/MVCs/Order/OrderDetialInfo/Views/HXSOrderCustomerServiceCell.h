//
//  HXSOrderCustomerServiceCell.h
//  store
//
//  Created by 格格 on 16/9/1.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXSOrderCustomerServiceCellDelegate<NSObject>

- (void)contactMerchant;

@end

@interface HXSOrderCustomerServiceCell : UITableViewCell

@property (nonatomic, weak) id<HXSOrderCustomerServiceCellDelegate> delegate;

+ (instancetype)orderCustomerServiceCell;

@end
