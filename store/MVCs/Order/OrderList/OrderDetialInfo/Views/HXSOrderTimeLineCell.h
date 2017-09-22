//
//  HXSOrderTimeLineCell.h
//  store
//
//  Created by 格格 on 16/8/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXSMyOrder.h"

@interface HXSOrderTimeLineCell : UITableViewCell

@property (nonatomic,strong) NSArray <HXStimelineStatus *> *timelineStatusArr;

+ (instancetype)orderTimeLineCell;

@end
