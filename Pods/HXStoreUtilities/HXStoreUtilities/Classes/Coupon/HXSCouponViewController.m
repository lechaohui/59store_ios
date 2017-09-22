//
//  HXSCouponViewController.m
//  store
//
//  Created by chsasaw on 14/12/4.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSCouponViewController.h"

// viewControllers
#import "HXSExchangeCouponViewController.h"
#import "HXSCouponHistoryViewController.h"

// models
#import "HXSCouponViewModel.h"
#import "HXSCoupon.h"

// views
#import "HXSCouponViewCell.h"
#import "HXSCouponListSectionHeaderView.h"
#import "HXSCouponListFooterView.h"
#import "HXSCouponListSectionFooterView.h"
#import "UIScrollView+HXSPullRefresh.h"
#import "HXSLoadingView.h"
#import "MBProgressHUD+HXS.h"

// Others
#import "UIColor+Extensions.h"
#import "HXSMediator.h"

static NSString * const kIllustrateUrl = @"http://gala.59store.com/static/coupon/";

@interface HXSCouponViewController ()<UITableViewDelegate,
                                      UITableViewDataSource,
                                      HXSCouponListFooterViewDelegate,
                                      HXSCouponListSectionHeaderViewDelegate,
                                      HXSExchangeCouponViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * coupons;
@property (nonatomic, strong) NSNumber *dueCountNum;

@end

@implementation HXSCouponViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initialNav];
    
    [self initialPrama];
    
    [self initialTableView];
    
    [self fatchCoupons];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    HXSCouponListFooterView *footerView = [HXSCouponListFooterView footerView];
    footerView.delegate = self;
    [self.tableView setTableFooterView:footerView];

}

#pragma mark - initial

- (void)initialNav
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"优惠券";
}

- (void)initialPrama
{
    self.coupons = [NSMutableArray array];
}

- (void)initialTableView
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"Coupon" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSCouponViewCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([HXSCouponViewCell class])];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = 120;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRGBHex:0xf5f6f7];
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 5;
    
    __weak typeof(self) weakSelf = self;
    
    [self.tableView addRefreshHeaderWithCallback:^{
        
        [weakSelf fatchCoupons];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - webService

- (void)fatchCoupons
{
    [HXSLoadingView showLoadingInView:self.view];
    
    __weak typeof(self) weakSelf = self;
    
    if (_couponScope != kHXSCouponScopePrint) {
        [HXSCouponViewModel fatchCouponsWithAvailable:@(HXSCouponAvailableTypeAvailable)
                                                scope:_couponScope
                                             complete:^(HXSErrorCode code, NSString *message, NSArray *coupons,NSNumber *dueCountNum) {
                                                 
                                                 [HXSLoadingView closeInView:weakSelf.view];
                                                 [weakSelf.tableView endRefreshing];
                                                 
                                                 if (kHXSNoError == code) {
                                                     
                                                     [weakSelf.coupons removeAllObjects];
                                                     [weakSelf.coupons addObjectsFromArray:coupons];
                                                     
                                                     weakSelf.dueCountNum = dueCountNum;
                                                     
                                                     [weakSelf.tableView reloadData];
                                                     
                                                     
                                                     return ;
                                                 }
                                                 [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                             }];
    } else {
        
        
        [HXSCouponViewModel getPrintCouponpicListWithType:_docTypeNum
                                                   amount:_docCouponAmountNum
                                                    isAll:_isAll
                                                 complete:^(HXSErrorCode code, NSString *message, NSArray *printCoupons)
         {
             [HXSLoadingView closeInView:weakSelf.view];
             [weakSelf.tableView endRefreshing];
             
             if (kHXSNoError == code) {
                 
                 [weakSelf.coupons removeAllObjects];
                 [weakSelf.coupons addObjectsFromArray:printCoupons];
                 
                 weakSelf.dueCountNum = @(0);
                 
                 [weakSelf.tableView reloadData];
                 
                 
                 return ;
             }
             [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
         }];
        
    }

}


#pragma mark - Target/Action

- (void)navRightItemButtonClicked
{
    HXSExchangeCouponViewController *exchangeCouponViewController = [HXSExchangeCouponViewController exchangeCouponViewController];
    exchangeCouponViewController.delegate = self;
    [self.navigationController pushViewController:exchangeCouponViewController animated:YES];
}

#pragma mark - UITabBarDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.coupons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSCoupon * coupon = [self.coupons objectAtIndex:indexPath.row];
    HXSCouponViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSCouponViewCell class]) forIndexPath:indexPath];
    cell.coupon = coupon;
    cell.indexPath = indexPath;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HXSCouponListSectionHeaderView *view = [HXSCouponListSectionHeaderView couponListSectionHeaderView];
    view.dueCountNum = self.dueCountNum;
    view.couponCountNum = [NSNumber numberWithInteger:[self.coupons count]];
    view.delegate = self;
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.coupons.count <= 0) {
        
        return 185;
    }
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.coupons.count <= 0) {
        
        HXSCouponListSectionFooterView *view = [HXSCouponListSectionFooterView sectionFooterView];
        return view;
    }
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSCoupon * coupon = [self.coupons objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(didSelectCoupon:)]) {
        
        [self.delegate  didSelectCoupon:coupon];
    }
    
    if (!self.fromPersonalVC) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - HXSCouponListSectionFooterViewDelegate

- (void)historyCouponButtonClocked
{
    HXSCouponHistoryViewController *controller = [HXSCouponHistoryViewController couponHistoryViewController];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - HXSCouponListSectionHeaderViewDelegate

- (void)illustrateButtonClicked
{
    UIViewController *viewController = [[HXSMediator sharedInstance] performActionWithUrl:[NSURL URLWithString:kIllustrateUrl]
                                                                               completion:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - HXSExchangeCouponViewControllerDelegate

- (void)exchangeCouponSuccessed
{
    [self fatchCoupons];
}

@end
