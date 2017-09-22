//
//  HXSMyCommissionViewController.m
//  store
//
//  Created by 格格 on 16/4/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

// Controllers
#import "HXSGetCashViewController.h"
#import "HXSMyCommissionViewController.h"
#import "HXSCommissionMoreViewController.h"
#import "HXSWithdrawalRecordViewController.h"

// Views
#import "HXSMyCommissionTableHeaderView.h"
#import "HXSMyCommissionSectionHeader.h"
#import "HXSMyCommissionCell.h"
#import "HXSCommissionNoDataView.h"

// Model
#import "HXSCommissionModel.h"
static NSString *HXSMyCommissionCellId       = @"HXSMyCommissionCell";

@interface HXSMyCommissionViewController ()<UITableViewDelegate,
                                            UITableViewDataSource,
                                            GetCashDelegate,
                                            HXSMyCommissionSectionHeaderDelegate>

@property (nonatomic, weak) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) HXSCommission *commission;
@property (nonatomic, strong) NSMutableArray *dataMArr;

@property (nonatomic, strong) HXSMyCommissionTableHeaderView *myCommissionTableHeaderView;
@property (nonatomic, strong) HXSMyCommissionSectionHeader *myCommissionSectionHeader;
@property (nonatomic, strong) HXSCommissionNoDataView *commissionNoDataView;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) BOOL isMore;

@end

@implementation HXSMyCommissionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNav];
    [self initialPrama];
    
    [self.myCommissionTableHeaderView updategetCashButtonStatus:NO];
    
    [self initialMyTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark- initial

- (void)initialNav
{
    self.navigationItem.title = @"收入";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提现记录" style:UIBarButtonItemStylePlain target:self action:@selector(navRightButtonClicked)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
}

- (void)initialPrama
{
    self.size = 20;
    self.dataMArr = [NSMutableArray arrayWithCapacity:20];
}

- (void)initialMyTableView
{
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorColor = [UIColor colorWithRGBHex:0xe1e2e3];
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSMyCommissionCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSMyCommissionCell class]) ];
    
    __weak typeof (self) weakSelf = self;
    [self.myTableView addRefreshHeaderWithCallback:^{
        self.isMore = NO;
        [weakSelf fetchPrintOrderList];
    }];
    
    [HXSLoadingView showLoadingInView:self.view];
    [self fetchPrintOrderList];
    
    [self.myTableView addInfiniteScrollingWithActionHandler:^{
        self.isMore = YES;
        [weakSelf fetchPrintOrderList];
    }];
    [self.myTableView setShowsInfiniteScrolling:NO];
    
    
}


#pragma mark - reflash

- (void)reloadTableHeaderView
{
    self.myCommissionTableHeaderView.myCommissionLabel.text = [NSString stringWithFormat:@"%.2f",self.commission.amountWalletStr.doubleValue ];
    if(self.commission.amountWalletStr.doubleValue  > 0)
        [self.myCommissionTableHeaderView updategetCashButtonStatus:YES];
    else
        [self.myCommissionTableHeaderView updategetCashButtonStatus:NO];
    
    [self.myCommissionTableHeaderView setNeedsLayout];
}


#pragma mark - webService

- (void)fetchPrintOrderList
{
    NSInteger currentPage;
    
    if (self.isMore) {
        currentPage = self.page + 1;
    } else {
        currentPage = 1;
    }
    
    WS(weakSelf);
    
    NSNumber *endTime = @((long long)([NSDate date].timeIntervalSince1970));
    NSNumber *startTime = @((long long)([[NSDate date] dateAfterDay: -7].timeIntervalSince1970));
    
    
    [HXSCommissionModel getCommissionRewardsWithPage:@(currentPage)
                                                size:@(self.size)
                                           startTime:startTime
                                             endTime:endTime
                                            complete:^(HXSErrorCode code, NSString *message, HXSCommission *commission) {
                                                     
                                                     [HXSLoadingView closeInView:weakSelf.view];
                                                     [weakSelf.myTableView endRefreshing];
                                                     [[weakSelf.myTableView infiniteScrollingView] stopAnimating];
                                                     
                                                     if (kHXSNoError == code ) {
                                                         
                                                         weakSelf.commission = commission;

                                                         if (!weakSelf.isMore) {
                                                             [weakSelf.dataMArr removeAllObjects];
                                                         }
                                                         
                                                         weakSelf.page = currentPage;
                                                         [weakSelf.dataMArr addObjectsFromArray:commission.itemsArr];
                                                         
                                                         [weakSelf.myTableView reloadData];
                                                         [weakSelf.myTableView setShowsInfiniteScrolling:commission.itemsArr.count>0];
                                                         
                                                         [weakSelf reloadTableHeaderView];
                                                         
                                                         return ;
                                                     }
                                                     
                                                     [weakSelf.myTableView setShowsInfiniteScrolling:NO];
                                                     if(code != kHXSItemNotExit) {
                                                         [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                            status:message
                                                                                        afterDelay:1.5f];
                                                     }
        
    }];
    
}


#pragma mark - Target/Action

- (void)navRightButtonClicked
{
    HXSWithdrawalRecordViewController *controller = [HXSWithdrawalRecordViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}

// 点击取现
- (void)getCrashButtonClicked
{
    HXSGetCashViewController *getCashViewController = [HXSGetCashViewController controllerWithAllAmount:self.commission.amountWalletStr];
    getCashViewController.delegate = self;
    [self.navigationController pushViewController:getCashViewController animated:YES];
}


#pragma mark - GetCashDelegate

- (void)getCashSuccessed
{
    self.isMore = NO;
    [self fetchPrintOrderList];
}


#pragma mark - HXSMyCommissionSectionHeaderDelegate

- (void)moreDetailsButtonClicked
{
    HXSCommissionMoreViewController *controller = [HXSCommissionMoreViewController controllerFromXib];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - UITabelViewDelegate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(0 == section) {
        return 0;
    }
    
    return self.dataMArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(0 == section) {
        return 104;
    }
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(0 == section) {
        return self.myCommissionTableHeaderView;
    }
    
    return self.myCommissionSectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (0 != section) {
        return self.dataMArr.count > 0 ? 0.1 : 300;
    }
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.dataMArr.count > 0 ? nil : self.commissionNoDataView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSMyCommissionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSMyCommissionCell class])];
    HXSCommissionEntity *commissionEntity = [self.dataMArr objectAtIndex:indexPath.row];
    [cell setupCommissionCellWithCommissionEntity:commissionEntity from:NO];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataMArr.count - 1 > indexPath.row) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    } else {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
}


#pragma mark - Get Set Methods

- (HXSMyCommissionTableHeaderView *)myCommissionTableHeaderView
{
    if(!_myCommissionTableHeaderView) {
        _myCommissionTableHeaderView = [HXSMyCommissionTableHeaderView headerView];
        [_myCommissionTableHeaderView.getCashButton addTarget:self action:@selector(getCrashButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _myCommissionTableHeaderView.myCommissionLabel.text = [NSString stringWithFormat:@"%.2f",self.commission.amountWalletStr.doubleValue ];
    }
     return _myCommissionTableHeaderView;
}

- (HXSMyCommissionSectionHeader *)myCommissionSectionHeader
{
    if(!_myCommissionSectionHeader) {
        _myCommissionSectionHeader = [HXSMyCommissionSectionHeader sectionHeader];
        _myCommissionSectionHeader.delegate = self;
    }
    return _myCommissionSectionHeader;
}

- (HXSCommissionNoDataView *)commissionNoDataView
{
    if(!_commissionNoDataView) {
        _commissionNoDataView = [HXSCommissionNoDataView noDataView];
        [_commissionNoDataView setBackgroundColor:self.myTableView.backgroundColor];
    }
    return _commissionNoDataView;
}

@end
