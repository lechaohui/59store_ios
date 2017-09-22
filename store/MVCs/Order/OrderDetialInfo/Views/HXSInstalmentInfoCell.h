//
//  HXSInstalmentInfoCell.h
//  store
//
//  Created by 格格 on 16/9/1.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  分期信息

#import <UIKit/UIKit.h>
#import "HXSMyOrder.h"

@interface HXSInstalmentInfoCell : UITableViewCell

@property (nonatomic, strong) HXStagingInfo *stagingInfo;

+ (instancetype)instalmentInfoCell;

@end
