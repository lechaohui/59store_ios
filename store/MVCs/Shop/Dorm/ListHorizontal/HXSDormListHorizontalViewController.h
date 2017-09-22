//
//  HXSDormListHorizontalViewController.h
//  store
//
//  Created by ArthurWang on 15/11/3.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSBaseTableViewController.h"

#import "HXSDromListMenuView.h"
#import "HXSDromListDetailView.h"

@class HXSShopEntity;

@protocol HXSDormListHorizontalViewControllerDelegate <NSObject>

@required

- (void)showView;
- (void)hideView;

- (void)reloadItemList;

@end

@interface HXSDormListHorizontalViewController : HXSBaseViewController

@property (weak, nonatomic) IBOutlet HXSDromListMenuView *menuView;
@property (weak, nonatomic) IBOutlet HXSDromListDetailView *detailView;

@property (nonatomic, strong) HXSShopEntity *shopEntity;
@property (nonatomic, weak) id<HXSDormListHorizontalViewControllerDelegate> listDelegate;

@end
