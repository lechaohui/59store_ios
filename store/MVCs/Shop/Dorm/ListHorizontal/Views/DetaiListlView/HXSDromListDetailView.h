//
//  HXSDromListDetailView.h
//  store
//
//  Created by  黎明 on 16/8/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//
/************************************************************
 *  夜猫店商品列表
 ***********************************************************/
#import <UIKit/UIKit.h>

@class HXSShopEntity,HXSDormItem, HXSClickEvent;

@protocol HXSDromListDetailViewDelagte <NSObject>

- (void)updateCountOfSnack:(NSNumber *)countNum inItem:(HXSDormItem *)item;

- (void)dormItemTableViewCellDidClickEvent:(HXSClickEvent *)event;

@end

@interface HXSDromListDetailView : UIView

@property (nonatomic, strong) UITableView                  *tableView;
@property (nonatomic, strong) NSMutableArray               *itemListArr;
@property (nonatomic, strong) HXSShopEntity                *shopEntity;
@property (nonatomic, weak  ) id<HXSDromListDetailViewDelagte> delegate;

@end
