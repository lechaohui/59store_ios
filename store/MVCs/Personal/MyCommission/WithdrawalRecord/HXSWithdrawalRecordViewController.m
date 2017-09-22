//
//  HXSWithdrawalRecordViewController.m
//  store
//
//  Created by 格格 on 16/10/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSWithdrawalRecordViewController.h"

// Models
#import "HXSWithdrawalRecordViewModel.h"

// Views
#import "HXSWithdraWalRecordSectionHeader.h"
#import "HXSWithdraWalRecordCell.h"
#import "HXSTableViewNoDataView.h"

@interface HXSWithdrawalRecordViewController ()<UITableViewDelegate,
                                                UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataMArr;
@property (nonatomic, strong) NSNumber *allAmountNum;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic,assign) BOOL ifGetMore;

@end

@implementation HXSWithdrawalRecordViewController


#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNav];
    
    [self initprama];
    
    [self initialTabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - initial

- (void)initialNav
{
    self.navigationItem.title = @"提现记录";
}

- (void)initprama
{
    self.page = 0;
    self.size = 20;
    self.dataMArr = [NSMutableArray arrayWithCapacity:20];
    self.ifGetMore = NO;

}

- (void)initialTabel
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSWithdraWalRecordCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HXSWithdraWalRecordCell class])];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 68;
    
    WS(weakSelf);
    
    [self.tableView addRefreshHeaderWithCallback:^{
        weakSelf.ifGetMore = NO;
        [weakSelf fatchData];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.ifGetMore = YES;
        [weakSelf fatchData];
    }];
    
    [self.tableView setShowsInfiniteScrolling:NO];
    
    
    [HXSLoadingView showLoadingInView:self.view];
    [self fatchData];
}


#pragma mark - webService

- (void)fatchData
{
    NSInteger currentpage;
    if(self.ifGetMore) {
        currentpage = self.page + 1;
    } else {
        currentpage = 1;
    }
    
    WS(weakSelf);
    
    [HXSWithdrawalRecordViewModel fatchWithdrawRecordWithPage:@(currentpage)
                                                         size:@(self.size)
                                                     complete:^(HXSErrorCode code, NSString *message, NSArray *withdrawRecords, NSNumber *amount) {
                                                         
                                                         [HXSLoadingView closeInView:weakSelf.view];
                                                         
                                                         [weakSelf.tableView endRefreshing];
                                                         [[weakSelf.tableView infiniteScrollingView] stopAnimating];
                                                         
                                                         if(kHXSNoError == code) {
                                                             
                                                             if(weakSelf.ifGetMore) {
                                                             } else {
                                                                 [weakSelf.dataMArr removeAllObjects];
                                                             }
                                                             weakSelf.page = currentpage;
                                                             
                                                             [weakSelf.tableView setShowsInfiniteScrolling:withdrawRecords.count > 0];
                                                             
                                                             [weakSelf.dataMArr addObjectsFromArray:withdrawRecords];
                                                             
                                                             weakSelf.allAmountNum = amount;
                                                             
                                                             [weakSelf.tableView reloadData];
                                                             
                                                         } else {
                                                             [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                                         }
        
    }];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataMArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.dataMArr.count > 0 ? 0.1 :202;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HXSWithdraWalRecordSectionHeader *headerView =  [HXSWithdraWalRecordSectionHeader sectionHeader];
    headerView.amountLabel.text = [NSString stringWithFormat:@"￥%.2f",self.allAmountNum.floatValue ];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.dataMArr.count > 0 ? nil : [HXSTableViewNoDataView tableViewNoDataView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSWithdraWalRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSWithdraWalRecordCell class]) forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    HXSWithdrawRecode *withdrawRecode = [self.dataMArr objectAtIndex:indexPath.row];
    cell.withdrawRecode = withdrawRecode;
    
    return cell;
}

@end
