//
//  RootViewController.m
//  store
//
//  Created by chsasaw on 14-10-14.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "RootViewController.h"

#import "HXSLoginViewController.h"
#import "HXSSite.h"
#import "HXSegmentControl.h"
#import "HXSMediator+HXLoginModule.h"
#import "HXSDormMainViewController.h"

#import "HXSRootTabModel.h"
#import "HXSRootViewModel.h"
#import "HXSTabBarView.h"


// 埋点信息
#define HXS_USAGE_EVENT_MAIN_TAB           @"navigation"


@interface RootViewController ()<HXSTabBarViewDelegate>

@property (nonatomic, strong) HXSTabBarView *tabBarView;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addTabBarView];
    
    [self setupSubViewControllersStyle];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.selectedViewController beginAppearanceTransition:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.selectedViewController endAppearanceTransition];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.selectedViewController beginAppearanceTransition:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.selectedViewController endAppearanceTransition];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

- (void)dealloc
{
    // Do nothing
}


#pragma mark - Override Methods

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationNone;
}


#pragma mark - Initial Methods

- (void)setupSubViewControllersStyle
{
    WS(weakSelf);
    [HXSRootViewModel getTabItemsPropertiesWithComplite:^(HXSRootTabModel *rootTabModel) {
        
        [weakSelf clearUptabBarView];
        
        int i = 0;
        for (UIViewController* vc in weakSelf.viewControllers) {
            
            UITabBarItem *item = vc.tabBarItem;
            NSShadow * shadow = [[NSShadow alloc] init];
            shadow.shadowColor = [UIColor clearColor];
            
            UIImage *normalImage = nil;
            UIImage *selectedImage = nil;
            NSData *gifData = nil;
        
            if (rootTabModel) {
             
                HXSRootTabItemModel *rootTabItemModel = rootTabModel.items[i];
                vc.title = rootTabItemModel.title;
                normalImage = rootTabItemModel.normalIcon;
                selectedImage = rootTabItemModel.selectIcon;
                gifData = rootTabItemModel.animationData;
                
                [item setTitleTextAttributes:@{NSForegroundColorAttributeName: rootTabModel.selectColor,
                                               NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10],
                                               NSShadowAttributeName:shadow}
                                    forState:UIControlStateSelected];
                [item setTitleTextAttributes:@{NSForegroundColorAttributeName: rootTabModel.normalColor,
                                               NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10],
                                               NSShadowAttributeName:shadow}
                                    forState:UIControlStateNormal];
                
            }
            else {
                
                
                normalImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar%d_normal", (i + 1)]]; // the first number is 1
                selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar%d_selected", (i + 1)]];
                
                NSString *gifPathStr = [NSString stringWithFormat:@"gif%d", i + 1];
                NSString *gifPath    = [[NSBundle mainBundle] pathForResource:gifPathStr
                                                                       ofType:@"gif"];
                
                gifData         = [NSData dataWithContentsOfFile:gifPath];
                
                [item setTitleTextAttributes:@{NSForegroundColorAttributeName: HXS_MAIN_COLOR,
                                               NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10],
                                               NSShadowAttributeName:shadow}
                                    forState:UIControlStateSelected];
                [item setTitleTextAttributes:@{NSForegroundColorAttributeName: HXS_TABBAR_ITEM_TEXT_COLOR_NORMAL,
                                               NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10],
                                               NSShadowAttributeName:shadow}
                                    forState:UIControlStateNormal];
            }
            
            [weakSelf.tabBarView addButtonWithImage:normalImage
                                   selectdImage:selectedImage
                                            gif:gifData];
            
            ++i;
        }
        
         [weakSelf.tabBar bringSubviewToFront:weakSelf.tabBarView];
        
    }];
    
}
- (void)addTabBarView
{
    [self.tabBar addSubview:self.tabBarView];
}

- (void)clearUptabBarView
{
    [self.tabBarView clearUpImageAndGif];

}


#pragma mark - HXSTabBarViewDelegate
- (BOOL)tabBar:(HXSTabBarView *)tabBar selectedFrom:(NSInteger)from to:(NSInteger)to
{
    BOOL shouldSelect = [self tabBar:self selectedFrom:from shouldSelectIndex:to];
    
    if (!shouldSelect) {
        // Don't change to New Item
        return NO;
    }
    
    self.selectedIndex = to;
    
    
    return shouldSelect;
    
}
-(void)tabBarViewCenterItemClick:(UIButton *)button;{




}
#pragma mark - Tab Bar Deal With Methods

- (BOOL)tabBar:(UITabBarController *)tabBarController selectedFrom:(NSInteger)fromIdx shouldSelectIndex:(NSInteger)controllerIdx
{
    UITabBarItem *tabBarItem = [tabBarController.tabBar.items objectAtIndex:controllerIdx];
    [HXSUsageManager trackEvent:HXS_USAGE_EVENT_MAIN_TAB parameter:@{@"navigation": tabBarItem.title}];
    
   
    if (controllerIdx == kHXSTabBarOrder) {
        WS(weakSelf);
        if (![HXSUserAccount currentAccount].isLogin) {
            [HXSLoginViewController showLoginController:self loginCompletion:^{
               
                [weakSelf setSelectedIndex:controllerIdx];
                
                [weakSelf.tabBarView selectedFrom:fromIdx to:controllerIdx];
                
            }];
            
            [weakSelf setSelectedIndex:controllerIdx];
            [weakSelf.tabBarView selectedFrom:fromIdx to:controllerIdx];
            
            return NO;
        }
    }
    
    return YES;
}


#pragma mark - public method

- (BOOL)checkIsLoggedin
{
    if ([HXSUserAccount currentAccount].isLogin) {
        return YES;
    } else {
        
        BEGIN_MAIN_THREAD
        UINavigationController *nav = [[HXSMediator sharedInstance] HXSMediator_loginNavigationController];
        [self presentViewController:nav animated:YES completion:nil];
        END_MAIN_THREAD
        
        return NO;
    }
}

- (UINavigationController *)currentNavigationController
{
    HXSBaseNavigationController *nav = self.viewControllers[self.selectedIndex];
    
    return nav;
}



#pragma mark - Getter Methods

- (HXSTabBarView *)tabBarView
{
    
    if (nil == _tabBarView) {
        CGRect rect = self.tabBar.bounds;
        
        HXSTabBarView *tabBarView = [[HXSTabBarView alloc] initWithFrame:rect];
        tabBarView.delegate = self;
        //tabBarView.frame = rect;
        //tabBarView.centerImage
    
        _tabBarView = tabBarView;

    }
    
    return _tabBarView;
}

@end


