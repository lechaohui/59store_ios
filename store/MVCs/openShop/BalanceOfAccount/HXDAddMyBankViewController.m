//
//  HXDAddMyBankViewController.m
//  59dorm
//
//  Created by J006 on 16/3/2.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXDAddMyBankViewController.h"
#import "HXDAddMyBankTableViewCell.h"
//#import "HXDMyPersonalInModel.h"
#import "HXDSelectBankListViewController.h"

#define footerViewHeight 300

@interface HXDAddMyBankViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) UIButton  *confirmButton;//确定
@property (nonatomic, strong) HXDAddBankInforParamEntity *paramEntity;

@end

@implementation HXDAddMyBankViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationBar];
    
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.mainTableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}


#pragma mark init

- (void)initNavigationBar
{
    self.navigationItem.title = @"银行卡";
}

- (void)initTableView
{
    [_mainTableView registerNib:[UINib nibWithNibName:HXDAddMyBankTableViewCellIdentify bundle:nil] forCellReuseIdentifier:HXDAddMyBankTableViewCellIdentify];
    [_mainTableView setSeparatorColor:RGB(225, 226, 227)];
    _mainTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    [self updateSubmitButtonStatus];

    
}

#pragma mark - target
- (void)initAddMyBankViewControllerWithEntity:(HXDAddBankInforParamEntity*)entity
{
    _paramEntity = entity;

}
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    NSInteger section = 2;
    
    return section;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 1;
    if(section == 0)
        rows = 4;
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXDAddMyBankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HXDAddMyBankTableViewCellIdentify];
    if(indexPath.section==0)
    {
        switch (indexPath.row) {
            case 0:
            {
                [cell initTheCellWithTitle:@"所属银行" andWithType:kHXDMyBankEditTypeBankType andWithEntity:self.paramEntity];
                cell.inputTextField.delegate = self;
                break;
            }
                
            case 1:
            {
                [cell initTheCellWithTitle:@"持卡人姓名" andWithType:kHXDMyBankEditTypeUserName andWithEntity:self.paramEntity];
                cell.inputTextField.delegate = self;
                break;
            }
            case 2:
            {
                [cell initTheCellWithTitle:@"开户地" andWithType:kHXDMyBankEditTypeBankAddress andWithEntity:self.paramEntity];
                cell.inputTextField.delegate = self;
                break;
            }
                
            default:
            {
              
                [cell initTheCellWithTitle:@"开户网点" andWithType:kHXDMyBankEditTypeBankShop andWithEntity:self.paramEntity];
                cell.inputTextField.delegate = self;

                break;
            }
        }
    }
    else
    {
        [cell initTheCellWithTitle:@"银行卡号" andWithType:kHXDMyBankEditTypeBankNums andWithEntity:self.paramEntity];
        
    }
    // 输入框通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section==0)
        return 0.1;
    return footerViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
    [headerView setBackgroundColor:RGB(244, 245, 246)];
    
    return headerView;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    if(section==0)
        return nil;
    UIView *mainFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, footerViewHeight)];
    [mainFooterView setBackgroundColor:RGB(244, 245, 246)];
    [mainFooterView addSubview:self.confirmButton];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainFooterView).offset(20);
        make.centerX.equalTo(mainFooterView);
        make.left.equalTo(mainFooterView).offset(15);
        make.right.equalTo(mainFooterView).offset(-15);
        make.height.mas_equalTo(44);
    }];
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(footerViewTapToDismissInput)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    [mainFooterView addGestureRecognizer:singleTapRecognizer];
    return mainFooterView;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section==0 && indexPath.row==0)
    {
    
        HXDSelectBankListViewController *bankListVC = [HXDSelectBankListViewController controllerFromXib];
        [bankListVC initTheHXDSelectBankListViewControllerWithEntity:_paramEntity];
        [self.navigationController pushViewController:bankListVC animated:YES];
        
    }
    
}

#pragma mark private methods


- (void)textFieldChanged:(UITextField *)textField
{
    [self updateSubmitButtonStatus];
}

- (void)updateSubmitButtonStatus
{
    self.confirmButton.enabled = (_paramEntity.bankIdStr && ![_paramEntity.bankIdStr isEqualToString:@""])
    && (_paramEntity.openLocationStr && ![_paramEntity.openLocationStr isEqualToString:@""])
    && (_paramEntity.openLocationStr && ![_paramEntity.openLocationStr isEqualToString:@""])
    && (_paramEntity.openAccountStr && ![_paramEntity.openAccountStr isEqualToString:@""])
    && (_paramEntity.cardNumberStr && ![_paramEntity.cardNumberStr isEqualToString:@""])
    && (_paramEntity.cardHolderNameStr && ![_paramEntity.cardHolderNameStr isEqualToString:@""]);
}

/**
 *  确定提交银行卡信息
 */
- (void)confirmAction
{
    if (_paramEntity.cardNumberStr.length < 4) {
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"银行卡卡号最少不小于4位" afterDelay:1.5];
        return ;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //__weak typeof(self) weakSelf = self;
    /*
    [[HXDMyPersonalInModel sharedManager] uploadTheBankInforWithBankEntity:_paramEntity Complete:^(HXDErrorCode status, NSString *message, NSString *currentStatus) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (weakSelf.updateSucessBlock) {
            weakSelf.updateSucessBlock();
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *errorMessage) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        if (weakSelf.view)
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:errorMessage afterDelay:1.5];
    }];*/
}

#pragma mark UITapGestureRecognizerTap

- (void)footerViewTapToDismissInput
{
    NSArray *cells = [_mainTableView visibleCells];
    for (HXDAddMyBankTableViewCell *cell in cells)
        [cell.inputTextField resignFirstResponder];
}

#pragma mark getter

- (UIButton*)confirmButton
{
    if(!_confirmButton)
    {
        //30为两边边距,44为高度
        _confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 44)];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor colorWithRGBHex:0x4bbef8]forState:UIControlStateDisabled];
        [_confirmButton setBackgroundColor:RGB(27, 167, 250)];
        
        [_confirmButton.layer setBorderWidth:1];
        [_confirmButton.layer setBorderColor:RGB(27, 167, 250).CGColor];
        _confirmButton.clipsToBounds = YES;
        _confirmButton.layer.cornerRadius = 5;
        [_confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (HXDAddBankInforParamEntity*)paramEntity
{
    if(!_paramEntity)
    {
        _paramEntity = [[HXDAddBankInforParamEntity alloc]init];
    }
    return _paramEntity;
}

@end
