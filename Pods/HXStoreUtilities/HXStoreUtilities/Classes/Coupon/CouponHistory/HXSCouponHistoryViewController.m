//
//  HXSCouponHistoryViewController.m
//  store
//
//  Created by 格格 on 16/10/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCouponHistoryViewController.h"

// Models
#import "HXSCouponViewModel.h"

// views
#import "HXSCouponViewCell.h"
#import "HXSCouponListSectionFooterView.h"
#import "HXSLoadingView.h"
#import "UIScrollView+HXSPullRefresh.h"
#import "MBProgressHUD+HXS.h"
#import "UIViewController+Extensions.h"
#import "UIColor+Extensions.h"

@interface HXSCouponHistoryViewController ()<UITableViewDelegate,
                                             UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *coupons;

@end

#pragma mark - lifeCycle

@implementation HXSCouponHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNva];
    
    [self initialPrama];
    
    [self initialTable];
    
    [self fatchCoupons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

+ (instancetype)couponHistoryViewController
{
   return [HXSCouponHistoryViewController controllerFromXibWithModuleName:@"Coupon"];
}


#pragma mark - initial

- (void)initialNva
{
    self.title = @"历史优惠券";
}

- (void)initialPrama
{
    self.coupons = [NSMutableArray array];
}

- (void)initialTable
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"Coupon" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSCouponViewCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([HXSCouponViewCell class])];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    __weak typeof(self) weakSelf = self;
    
    [self.tableView addRefreshHeaderWithCallback:^{
        
        [weakSelf fatchCoupons];
        
    }];

}


#pragma mark - webService

- (void)fatchCoupons
{
    [HXSLoadingView showLoadingInView:self.view];
    
    __weak typeof(self) weakSelf = self;
    
    [HXSCouponViewModel fatchCouponsWithAvailable:@(HXSCouponAvailableTypeHistory)
                                            scope:kHXSCouponScopeNone
                                         complete:^(HXSErrorCode code, NSString *message, NSArray *coupons,NSNumber *dueCountNum) {
                                             
                                             [HXSLoadingView closeInView:weakSelf.view];
                                             [weakSelf.tableView endRefreshing];
                                             
                                             if (kHXSNoError == code) {
                                                 
                                                 [weakSelf.coupons removeAllObjects];
                                                 [weakSelf.coupons addObjectsFromArray:coupons];
                                                 
                                                 [weakSelf.tableView reloadData];
                                                 
                                                 if (0 >= [coupons count]) {
                                                     UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
                                                     label.font = [UIFont systemFontOfSize:13.0f];
                                                     label.textColor = [UIColor colorWithRGBHex:0x999999];
                                                     label.text = @"暂无历史优惠券";
                                                     label.textAlignment = NSTextAlignmentCenter;
                                                     
                                                     [weakSelf.tableView setTableFooterView:label];
                                                 } else {
                                                     [weakSelf.tableView setTableFooterView:nil];
                                                 }
                                                 
                                                 return ;
                                             }
                                             
                                             [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                             
                                         }];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
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

@end
