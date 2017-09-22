//
//  HXDMainViewController.h
//  store
//
//  Created by caixinye on 2017/9/7.
//  Copyright © 2017年 huanxiao. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "HXDBaseViewController.h"

@class HXDBusinessItemViewModel;


@interface HXDMainViewController : HXDBaseViewController

@property (nonatomic, strong) HXDBusinessItemViewModel *businessModel;

@end
