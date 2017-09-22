//
//  HXSCouponMainViewController.m
//  Pods
//
//  Created by caixinye on 2017/9/18.
//
//

#import "HXSCouponMainViewController.h"
#import "JohnTopTitleView.h"
#import "UIViewController+Extensions.h"

#import "HXSCouponViewController.h"
#import "HXSCouponUsedViewController.h"
#import "HXSDatedViewController.h"




@interface HXSCouponMainViewController ()

@property (nonatomic,strong) JohnTopTitleView *titleView;


@end

@implementation HXSCouponMainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title= @"优惠券";
    [self initTitles];
    
    
}

- (void)initTitles{


    NSArray *titleArray = [NSArray arrayWithObjects:@"未使用",@"已使用",@"已过期", nil];
    self.titleView.title = titleArray;
    [self.titleView setupViewControllerWithFatherVC:self childVC:[self setChildVC]];
    [self.view addSubview:self.titleView];
    


}
- (NSArray <HXSBaseViewController *>*)setChildVC{
    
    HXSCouponViewController * couponViewController = [HXSCouponViewController controllerFromXibWithModuleName:@"Coupon"];
    couponViewController.couponScope = kHXSCouponScopeNone;
    couponViewController.fromPersonalVC = YES;
    
    HXSCouponUsedViewController *usedVc = [[HXSCouponUsedViewController alloc] init];
    usedVc.couponScope = kHXSCouponScopeNone;
    usedVc.fromPersonalVC = YES;
    
    HXSDatedViewController *dated = [[HXSDatedViewController alloc] init];
    
    NSArray *childVc = [NSArray arrayWithObjects:couponViewController,usedVc,dated,nil];
    return childVc;
   
    

}
#pragma mark - getter
- (JohnTopTitleView *)titleView{
    
    if (!_titleView) {
        _titleView = [[JohnTopTitleView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    return _titleView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
