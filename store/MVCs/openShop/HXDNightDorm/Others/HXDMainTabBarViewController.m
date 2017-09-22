//
//  HXDMainNavigationViewController.m
//  59dorm
//
//  Created by J006 on 16/2/25.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXDMainTabBarViewController.h"

#import "HXDMainViewController.h"
#import "HXDBaseNavigationController.h"
//#import "HXDWebViewController.h"

@interface HXDMainTabBarViewController ()

//@property (nonatomic, strong) HXDWebViewController *groupVC;

@end

@implementation HXDMainTabBarViewController

#pragma mark - life cycle

- (instancetype)initWithSelectedIndex:(NSUInteger)selectedIndex {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBar.translucent = NO;

    [self setupTabItemColor];
    
    [self setupBackBarItem];
    
    
    
}

- (void)setupTabItemColor {
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:MainLightBlue,
                           NSForegroundColorAttributeName, nil];
    [[UITabBarItem appearance] setTitleTextAttributes: attrs forState:UIControlStateSelected]; // 设置bar选中时文字颜色
    
    NSDictionary *attrsNormal = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRGBHex:0x4F555C],
                                 NSForegroundColorAttributeName, nil];
    [[UITabBarItem appearance] setTitleTextAttributes: attrsNormal forState:UIControlStateNormal]; // 设置bar文字颜色
}

- (void)setupBackBarItem {
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"开店挣钱" forState:UIControlStateNormal];
    [backBtn setTitleColor:MainLightBlue forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backBtn.titleLabel.font = TEXT_FONT(15);
    [backBtn setImage:[UIImage imageNamed:@"btn_back_blue"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

- (void)tabBarAddChildViewController:(UIViewController *)childVC title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
   
    childVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                      image:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[[UIImage imageNamed:selectedImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    [self addChildViewController:childVC];
}


@end
