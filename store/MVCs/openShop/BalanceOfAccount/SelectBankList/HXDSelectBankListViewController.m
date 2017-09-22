//
//  HXDSelectBankListViewController.m
//  59dorm
//
//  Created by J006 on 16/3/3.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXDSelectBankListViewController.h"
#import "HXDSelectBankListTableViewCell.h"
#import "HXSPersonal.h"

@interface HXDSelectBankListViewController ()

@property (weak, nonatomic)     IBOutlet UITableView            *mainTableView;
@property (nonatomic, strong)   HXDAddBankInforParamEntity      *paramEntity;
@property (nonatomic, copy)     NSArray                         *bankListArray;

@end

@implementation HXDSelectBankListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBar];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadTheBankList];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark init

- (void)initTheHXDSelectBankListViewControllerWithEntity:(HXDAddBankInforParamEntity *)entity
{
    _paramEntity = entity;
}

- (void)initNavigationBar
{
    self.navigationItem.title = @"选择银行卡";
}

- (void)initTableView
{
    [_mainTableView registerNib:[UINib nibWithNibName:HXDSelectBankListTableViewCellIndentify bundle:nil] forCellReuseIdentifier:HXDSelectBankListTableViewCellIndentify];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    NSInteger section = 0;
    if(_bankListArray)
        section = 1;
    
    return section;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if(_bankListArray)
        rows = [_bankListArray count];
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     HXDSelectBankListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HXDSelectBankListTableViewCellIndentify];
    HXDBankEntity *entity = [_bankListArray objectAtIndex:indexPath.row];
    [cell initSelectBankListTableViewCellWith:entity];
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44;
    return height;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    return headerView;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXDBankEntity *entity = [_bankListArray objectAtIndex:indexPath.row];
    _paramEntity.bankIdStr = entity.bankIDStr;
    _paramEntity.bankNameStr = entity.bankNameStr;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark networking load

/**
 *  获取可供选择的银行列表
 */
- (void)loadTheBankList
{
    [HXSLoadingView showLoadingInView:self.view];
    
    __weak typeof(self) weakSelf = self;
    
    /*
    [[HXSPersonal sharedManager] fetchBankListComplete:^(HXDErrorCode status, NSString *message, NSArray *banksArray)
    {
        [HXSLoadingView closeInView:self.view];
        weakSelf.bankListArray = banksArray;
        [weakSelf.mainTableView reloadData];
    } failure:^(NSString *errorMessage) {
        
        [HXSLoadingView closeInView:self.view];
        if (weakSelf.view)
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:@"读取银行列表失败." afterDelay:1.5];
    }];*/
}

@end
