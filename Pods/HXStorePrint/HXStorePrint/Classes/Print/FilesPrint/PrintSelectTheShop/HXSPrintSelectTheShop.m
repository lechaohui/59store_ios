//
//  HXSPrintSelectTheShop.m
//  store
//
//  Created by J006 on 16/5/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintSelectTheShop.h"
#import "HXSLocationManager.h"
#import "HXSShopManager.h"
#import "HXSPrintShopListViewController.h"
#import "HXSPrintHeaderImport.h"

@interface HXSPrintSelectTheShop()<HXSPrintShopListViewControllerDelegate>

@property (nonatomic, copy) void (^printReturnBlock)(HXSShopEntity *entity);

@end

@implementation HXSPrintSelectTheShop

-(void)dealloc
{
    _printReturnBlock = nil;
}

- (void)selectTheShopEntityAndWithVC:(UIViewController *)viewController
                       andPrintBlock:(void (^)(HXSShopEntity *entity))printReturnBlock;
{
    WS(weakself);
    [[HXSLocationManager manager] resetPosition:PositionBuilding
                              andViewController:viewController
                                     completion:^{
        HXSPrintShopListViewController *shopListVC = [HXSPrintShopListViewController createPrintShopListVC];
        shopListVC.delegate = weakself;
        weakself.printReturnBlock = printReturnBlock;
        HXSBaseNavigationController *nav = [[HXSBaseNavigationController alloc] initWithRootViewController:shopListVC];
        [viewController presentViewController:nav animated:YES completion:nil];
    }];
}

#pragma mark - HXSPrintShopListViewControllerDelegate

- (void)selectShopEntity:(HXSShopEntity *)entity
{
    if(entity)
    {
        _printReturnBlock(entity);
    }
}

@end
