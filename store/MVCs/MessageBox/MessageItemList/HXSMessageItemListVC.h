//
//  HXSMessageItemListVC.h
//  store
//
//  Created by 格格 on 16/8/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSMessageCate.h"

@interface HXSMessageItemListVC : HXSBaseViewController

+ (instancetype)controllerWithMessageCate:(HXSMessageCate *)messageCate;

@end
