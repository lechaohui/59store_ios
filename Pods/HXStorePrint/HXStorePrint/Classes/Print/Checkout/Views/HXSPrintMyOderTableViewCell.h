//
//  HXSMyOderTableViewCell.h
//  store
//
//  Created by J.006 on 16/8/25.
//  Copyright (c) 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSMyPrintOrderItem;

@interface HXSPrintMyOderTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString              *itemId;

@property (nonatomic, weak) HXSMyPrintOrderItem     *printItem;

@end
