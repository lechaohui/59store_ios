//
//  HXSCommissionMoreViewController.m
//  store
//
//  Created by 格格 on 16/10/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommissionMoreViewController.h"

// Model
#import "HXSCommissionModel.h"

// Views
#import "HXSCommissionMoreSectionHeader.h"
#import "HXSMyCommissionCell.h"
#import "HXSCommissionNoDataView.h"

@interface HXSCommissionMoreViewController ()<UITableViewDelegate,
                                              UITableViewDataSource,
                                              HXSCommissionMoreSectionHeaderDelegate>

@property (nonatomic, weak) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) HXSCommissionMoreSectionHeader *sectionHeader;
@property (nonatomic, strong) HXSCommission *commission;

@property (nonatomic, strong) NSMutableArray *dataMArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) BOOL isMore;

@property (nonatomic, strong) HXSCommissionNoDataView *commissionNoDataView;

@end

@implementation HXSCommissionMoreViewController


#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNav];
    
    [self initialParam];
    
    [self initialTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - initial

- (void)initialNav
{
    self.navigationItem.title = @"收支明细";
}

- (void)initialParam
{
    self.size = 20;
    self.dataMArr = [NSMutableArray arrayWithCapacity:20];
}

- (void)initialTable
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
    
    [HXSCommissionModel getCommissionRewardsWithPage:@(currentPage)
                                                size:@(self.size)
                                           startTime:self.sectionHeader.startDateTimestamp
                                             endTime:self.sectionHeader.endDateTimestamp
                                            complete:^(HXSErrorCode code, NSString *message, HXSCommission *commission) {
                                               
                                               [HXSLoadingView closeInView:weakSelf.view];
                                               [weakSelf.myTableView endRefreshing];
                                               [[weakSelf.myTableView infiniteScrollingView] stopAnimating];
                                               
                                               if (kHXSNoError == code ) {
                                                   
                                                   if (!weakSelf.isMore) {
                                                       [weakSelf.dataMArr removeAllObjects];
                                                       
                                                       weakSelf.commission = commission;
                                                       weakSelf.sectionHeader.commission = commission;
                                                   }
                                                   
                                                   weakSelf.page = currentPage;
                                                   [weakSelf.dataMArr addObjectsFromArray:commission.itemsArr];
                                                   
                                                   [weakSelf.myTableView reloadData];
                                                   [weakSelf.myTableView setShowsInfiniteScrolling:commission.itemsArr.count>0];
                                                   
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


#pragma mark - HXSCommissionMoreSectionHeaderDelegate

- (void)selectTimeChange
{
    self.isMore = NO;
    [self fetchPrintOrderList];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataMArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.dataMArr.count > 0 ? 0.1 : 300;
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
    [cell setupCommissionCellWithCommissionEntity:commissionEntity from:YES];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Getter

- (HXSCommissionMoreSectionHeader *)sectionHeader
{
    if (nil == _sectionHeader) {
        _sectionHeader = [HXSCommissionMoreSectionHeader sectionHeader];
        _sectionHeader.delegate = self;
    }
    
    return _sectionHeader;
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
