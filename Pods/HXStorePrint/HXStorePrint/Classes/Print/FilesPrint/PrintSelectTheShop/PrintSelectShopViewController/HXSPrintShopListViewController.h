//
//  HXSPrintShopListViewController.h
//  store
//  云印店列表
//  Created by J.006 on 16/8/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSShopEntity.h"

@protocol HXSPrintShopListViewControllerDelegate <NSObject>

@optional

- (void)selectShopEntity:(HXSShopEntity *)entity;

@end

@interface HXSPrintShopListViewController : HXSBaseViewController

@property (nonatomic, weak)   id<HXSPrintShopListViewControllerDelegate> delegate;

+ (instancetype)createPrintShopListVC;

@end
