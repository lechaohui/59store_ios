//
//  HXSCouponUsedViewController.m
//  Pods
//
//  Created by caixinye on 2017/9/18.
//
//

#import "HXSCouponUsedViewController.h"



// views
#import "HXSCouponViewCell.h"
#import "HXSCouponListSectionHeaderView.h"
#import "UIScrollView+HXSPullRefresh.h"
#import "HXSLoadingView.h"
#import "MBProgressHUD+HXS.h"
#import "HXSCouponListSectionFooterView.h"





// models
#import "HXSCouponViewModel.h"


// Others
#import "UIColor+Extensions.h"
#import "HXSMediator.h"

static NSString * const kIllustrateUrl = @"http://gala.59store.com/static/coupon/";


@interface HXSCouponUsedViewController ()<UITableViewDelegate,UITableViewDataSource,HXSCouponListSectionHeaderViewDelegate>


@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * coupons;
@property (nonatomic, strong) NSNumber *dueCountNum;



@end

@implementation HXSCouponUsedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.coupons = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    
    [self.tableView addRefreshHeaderWithCallback:^{
        
        [weakSelf fatchCoupons];
        
    }];
}
- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    



}
#pragma mark - lazymethod
- (UITableView *)tableView{
    
    if (!_tableView) {

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];

        _tableView.backgroundColor = [UIColor colorWithRGBHex:0xf5f6f7];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.coupons.count;


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 120;

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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    HXSCoupon * coupon = [self.coupons objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(didSelectCoupon:)]) {
        
        [self.delegate  didSelectCoupon:coupon];
    }
    
    if (!self.fromPersonalVC) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark - fetchData
- (void)fatchCoupons{


   [HXSLoadingView showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    
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
    


}

#pragma mark - HXSCouponListSectionHeaderViewDelegate
- (void)illustrateButtonClicked
{
    UIViewController *viewController = [[HXSMediator sharedInstance] performActionWithUrl:[NSURL URLWithString:kIllustrateUrl]
                                                                               completion:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
