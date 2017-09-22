//
//  HXSTarget_RootViewController.m
//  store
//
//  Created by J006 on 16/8/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTarget_rootViewController.h"

@implementation HXSTarget_rootViewController

- (UINavigationController *)Action_rootVC
{
    RootViewController *rootVC = [AppDelegate sharedDelegate].rootViewController;
    UINavigationController *nav = rootVC.currentNavigationController;
    
    return nav;
}

@end
