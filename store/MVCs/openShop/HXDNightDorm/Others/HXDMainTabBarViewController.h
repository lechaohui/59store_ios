//
//  HXDMainTabBarViewController.h
//  59dorm
//  初始化主导航栏
//  Created by J006 on 16/2/25.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HXDBusinessItemViewModel;

@interface HXDMainTabBarViewController : UITabBarController

- (void)tabBarAddChildViewController:(UIViewController *)childVC title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName;

- (instancetype)initWithSelectedIndex:(NSUInteger)selectedIndex;

@property (nonatomic, assign) NSUInteger configSelectedIndex;

@end
