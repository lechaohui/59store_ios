//
//  DormTabBarViewController.m
//  59dorm
//
//  Created by BeyondChao on 16/8/25.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXDDormTabBarViewController.h"
#import "HXDMainViewController.h"
#import "HXDSelectSuppliersViewController.h"
#import "HXDCommodityManageViewController.h"
#import "HXDOrderHistoryViewController.h"
#import "HXDPurchasingRecordsViewController.h"
#import "HXDMyDormShopViewController.h"
#import "HXDBusinessItemViewModel.h"

@interface HXDDormTabBarViewController () <UITabBarControllerDelegate>

@end

@implementation HXDDormTabBarViewController

- (instancetype)initWithSelectedIndex:(NSUInteger)selectedIndex {
    if (self = [super init]) {
        self.configSelectedIndex = selectedIndex;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.navigationItem.title = @"订单处理";
    [self initHistoryNavigationBarItem]; // 初始化右边barItem
    self.tabBar.translucent = NO;
 
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self initialChildViewControllers];
    
    
}
#pragma mark private methods

- (void)initialChildViewControllers {

    // 1. 订单处理
    HXDMainViewController *orderMainVC = [[HXDMainViewController alloc] init];
    //orderMainVC.businessModel = self.businessModel;
    [self tabBarAddChildViewController:orderMainVC
                                 title:@"订单处理"
                             imageName:@"ic_dingdanchuli_normal"
                     selectedImageName:@"ic_dingdanchuli_selected"];
    
    // 2. 我要采购
    HXDSelectSuppliersViewController *supplierVC = [[HXDSelectSuppliersViewController alloc] initWithShopType:kHXDShopTypeDrom];
    [self tabBarAddChildViewController:supplierVC
                                 title:@"我要采购"
                             imageName:@"ic_woyaocaigou_normal"
                     selectedImageName:@"ic_woyaocaigou_selected"];
    // 3. 商品管理
    [self tabBarAddChildViewController:[[HXDCommodityManageViewController alloc] init]
                                 title:@"商品管理"
                             imageName:@"ic_shangpinguanli_normal"
                     selectedImageName:@"ic_shangpinguanli_selected"];
    // 4. 我的店铺
    //UIStoryboard *sb = [UIStoryboard storyboardWithName:@"HXDMyDormShopViewController" bundle:nil];
    //HXDMyDormShopViewController *dormShopVC = [sb instantiateViewControllerWithIdentifier:@"HXDMyDormShopViewController"];
    //[dormShopVC setupBusinessId:self.businessModel.businessId];
    HXDMyDormShopViewController *dormShopVC = [[HXDMyDormShopViewController alloc] init];
    [self tabBarAddChildViewController:dormShopVC
                                 title:@"我的店铺"
                             imageName:@"ic_wodedianpu_noraml"
                     selectedImageName:@"ic_wodedianpu_selected"];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    self.navigationItem.title = item.title;
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    if ([viewController isKindOfClass:[HXDMainViewController class]]) {
        [self initHistoryNavigationBarItem];
    } else if ([viewController isKindOfClass:[HXDSelectSuppliersViewController class]]) {
        [self initPurchaseRecordBarItem];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    }
}

- (void)initHistoryNavigationBarItem {
    
    UIBarButtonItem* jumpToHistoryBtn = [[UIBarButtonItem alloc] initWithTitle:@"历史订单"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(jumpToOrderHistoryVC)];
    
    [jumpToHistoryBtn setTitlePositionAdjustment:UIOffsetMake(-5.0, 0) forBarMetrics:UIBarMetricsDefault];
    [jumpToHistoryBtn setTitleTextAttributes:@{ NSForegroundColorAttributeName:MainLightBlue,
                                                NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                    forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = jumpToHistoryBtn;
    
}

- (void)initPurchaseRecordBarItem {
    
    UIBarButtonItem* jumpToHistoryBtn = [[UIBarButtonItem alloc] initWithTitle:@"采购记录"
                                                                         style: UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(jumpToPurchaseRecordVC)];
    
    [jumpToHistoryBtn setTitlePositionAdjustment:UIOffsetMake(-5.0, 0) forBarMetrics:UIBarMetricsDefault];
    [jumpToHistoryBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:MainLightBlue,
                                               NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                    forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = jumpToHistoryBtn;
}

- (void)jumpToOrderHistoryVC {
    
    HXDOrderHistoryViewController *vc = [HXDOrderHistoryViewController controllerFromXib];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToPurchaseRecordVC {
    
    HXDPurchasingRecordsViewController *purchaseRecordsVC = [[HXDPurchasingRecordsViewController alloc] init];
    [self.navigationController pushViewController:purchaseRecordsVC animated:YES];
    
}

#pragma mark - setter

- (void)setBusinessModel:(HXDBusinessItemViewModel *)businessModel {
    
    _businessModel = businessModel;
    
    [self initialChildViewControllers]; // 获取到数据，才创建childVC，传递数据
    
    [self setSelectedIndex:self.configSelectedIndex];

    if (self.configSelectedIndex == 1) {
        self.navigationItem.title = @"我要采购";
    }
}

@end
