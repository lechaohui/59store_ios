//
//  HXSBindCardViewController.m
//  store
//
//  Created by caixinye on 2017/9/19.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXSBindCardViewController.h"

// Model
#import "HXSPersonalInfoModel.h"
#import "HXSCashModel.h"

//controller
#import "HXSBankListViewController.h"

//views
#import "TPKeyboardAvoidingTableView.h"
#import "HXSGetCashTableViewCell.h"
#import "HXSGetCrashTableFooterView.h"


#define MAX_LENTH 3
#define limited 2
static NSString *HXSGetCashTableViewCellId = @"HXSGetCashTableViewCell";

@interface HXSBindCardViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>




@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cellArray;

/** 姓名 */
@property (nonatomic, strong) HXSGetCashTableViewCell *nameCell;
/** 卡号 */
@property (nonatomic, strong) HXSGetCashTableViewCell *cardNumCell;
/** 银行 */
@property (nonatomic, strong) HXSGetCashTableViewCell *bankCell;
/** 开户城市 */
@property (nonatomic, strong) HXSGetCashTableViewCell *cityCell;
/** 开户网点 */
@property (nonatomic, strong) HXSGetCashTableViewCell *netDotCell;

@property (nonatomic, strong) HXSGetCrashTableFooterView *footerView;

@property (nonatomic, strong) HXSCashBankInfo *bankInfo;
@property (nonatomic, strong) HXSBankEntity *bankEntity;




@end

@implementation HXSBindCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的银行卡";
    [self.view addSubview:self.tableView];
    [self initialPrama];
    [self registeKVO];
    [self getBankInfo];

}
#pragma mark - initial
- (UITableView *)tableView{
    
    if (!_tableView) {
      
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT-10)
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor= [UIColor colorWithRGBHex:0xf4f5f6];

    }
     return _tableView;

}
- (void)initialPrama{

    
    NSArray *arr0 = @[self.bankCell,
                      self.nameCell,
                      self.cityCell,
                      self.netDotCell];
    _cellArray = [NSMutableArray arrayWithObjects:
                  arr0,
                  @[self.cardNumCell],
                  nil];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:HXSGetCashTableViewCellId bundle:nil] forCellReuseIdentifier:HXSGetCashTableViewCellId];
    
    [self.tableView setTableFooterView:self.footerView];
    
    
}


#pragma mark - webService

- (void)getBankInfo
{
    [HXSLoadingView showLoadingInView:self.view];
    
    WS(weakSelf);
    
    [HXSCashModel getBankCordList:^(HXSErrorCode code, NSString *message, NSArray *bankList) {
        
        [HXSLoadingView closeInView:weakSelf.view];
        
        if (kHXSNoError == code) {
            
            if (bankList.count > 0) {
                
                weakSelf.bankInfo = [bankList firstObject];
            }
            
            return ;
        }
        
        [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
    }];

}

#pragma mark - KVO
- (void)registeKVO
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFieldTextChanged:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:self.nameCell.textField];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFieldTextChanged:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:self.cardNumCell.textField];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFieldTextChanged:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:self.bankCell.textField];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFieldTextChanged:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:self.cityCell.textField];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFieldTextChanged:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:self.netDotCell.textField];
    
}

- (HXSGetCashTableViewCell *)bankCell
{
    if(!_bankCell) {
        _bankCell = [HXSGetCashTableViewCell crashTableViewCell];
        _bankCell.nameLabel.text = @"所属银行";
        _bankCell.textField.placeholder = @"请选择所属银行";
        _bankCell.textField.delegate = self;
        _bankCell.textField.enabled = NO;
        _bankCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return _bankCell;
}

- (HXSGetCashTableViewCell *)cityCell
{
    if(!_cityCell) {
        _cityCell = [HXSGetCashTableViewCell crashTableViewCell];
        _cityCell.nameLabel.text = @"开户地";
        _cityCell.textField.placeholder = @"请输入开户城市";
        _cityCell.textField.delegate = self;
    }
    return _cityCell;
}

- (HXSGetCashTableViewCell *)netDotCell
{
    if(!_netDotCell) {
        _netDotCell = [HXSGetCashTableViewCell crashTableViewCell];
        _netDotCell.nameLabel.text = @"开户网点";
        _netDotCell.textField.placeholder = @"请输入开户网点";
        _netDotCell.textField.delegate = self;
    }
    return _netDotCell;
}

- (HXSGetCashTableViewCell *)cardNumCell
{
    if(!_cardNumCell) {
        _cardNumCell = [HXSGetCashTableViewCell crashTableViewCell];
        _cardNumCell.nameLabel.text = @"卡号";
        _cardNumCell.textField.placeholder = @"请输入银行卡号";
        _cardNumCell.textField.delegate = self;
        _cardNumCell.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _cardNumCell;
}

- (HXSGetCashTableViewCell *)nameCell
{
    if(!_nameCell) {
        _nameCell = [HXSGetCashTableViewCell crashTableViewCell];
        _nameCell.nameLabel.text = @"持卡人姓名";
        _nameCell.textField.placeholder = @"请输入开户人姓名";
        _nameCell.textField.delegate = self;
    }
    return _nameCell;
}
- (HXSGetCrashTableFooterView *)footerView
{
    if(!_footerView) {
        _footerView = [HXSGetCrashTableFooterView footerView];
        [_footerView.getCrashButton setTitleColor:[UIColor colorWithR:255 G:255 B:255 A:0.5] forState:UIControlStateDisabled];
        [_footerView.getCrashButton addTarget:self
                                       action:@selector(getCrashButtonClicked)
                             forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

- (void)setBankInfo:(HXSCashBankInfo *)bankInfo
{
    _bankInfo = bankInfo;
    self.cityCell.textField.text = _bankInfo.bankCityStr;
    self.bankCell.textField.text = _bankInfo.bankNameStr;
    self.cardNumCell.textField.text = _bankInfo.bankCardNoStr;
    self.nameCell.textField.text = _bankInfo.bankUserNameStr;
    self.netDotCell.textField.text = _bankInfo.bankSiteStr;
    
    self.footerView.getCrashButton.enabled = [self getCrashButtonEnable];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.footerView.getCrashButton.enabled = [self getCrashButtonEnable];
}

- (void)textFieldTextChanged:(NSNotification *)obj
{
    self.footerView.getCrashButton.enabled = [self getCrashButtonEnable];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *mutableStr = [[NSMutableString alloc] initWithString:textField.text];
    [mutableStr replaceCharactersInRange:range withString:string];
    
    if (25 < [mutableStr length]) { // 最大长度为 25
        return NO;
    }
    
    return YES;
}

#pragma mark - UITableViewDelegate/UITablbeViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = _cellArray [section];
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if (section ==0) {
        return 10;
    }
    return 0.1;
    
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[NSBundle mainBundle]loadNibNamed:@"GetCashSectionHeader" owner:nil options:nil].firstObject;
    return sectionHeaderView;
}*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSGetCashTableViewCell *cell = [[_cellArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];//[_cellArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    HXSGetCashTableViewCell *cell = [[_cellArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if(cell == self.bankCell) {
        
        HXSBankListViewController *bankListViewController = [[HXSBankListViewController alloc]initWithNibName:nil bundle:nil];
        __weak typeof(self) weakSelf = self;
        bankListViewController.completion = ^(HXSBankEntity *item){
            [weakSelf selectBank:item];
        };
        [self.navigationController pushViewController:bankListViewController animated:YES];
    }
}

- (void)selectBank:(HXSBankEntity *)item
{
    if (self.bankInfo) {
        self.bankInfo.bankCodeStr = item.codeStr;
        self.bankInfo.bankNameStr = item.nameStr;
    }
    self.bankEntity = item;
    self.bankCell.textField.text = item.nameStr;
    [self.tableView reloadData];
    
}
#pragma mark - Get Set Methods

- (BOOL)getCrashButtonEnable
{
    BOOL isEnable = NO;
    
    if ((0 < [self.nameCell.textField.text length])
        && (0 < [self.cardNumCell.textField.text length])
        && (0 < [self.bankCell.textField.text length])
        && (0 < [self.cityCell.textField.text length])
        && (0 < [self.netDotCell.textField.text length])) {
        isEnable = YES;
    }
    
    if (10 > [self.cardNumCell.textField.text length]) { // 银行最小长度10
        isEnable = NO;
    }
    
    
    return isEnable;
}

#pragma mark - TarGet/Action
// 点击申请取现按钮
- (void)getCrashButtonClicked
{
    if (nil != self.bankInfo) {
        
        [self updateBankCardInfo];
        
    } else {
        
        [self addBankCardInfo];
    }
    
}
- (void)updateBankCardInfo
{
    WS(weakSelf);
    
    [HXSLoadingView showLoadingInView:self.view];
    
    self.bankInfo.bankUserNameStr = self.nameCell.textField.text;
    self.bankInfo.bankCardNoStr = self.cardNumCell.textField.text;
    self.bankInfo.bankCityStr = self.cityCell.textField.text;
    self.bankInfo.bankSiteStr = self.netDotCell.textField.text;
    
    [HXSCashModel updateBankCardInfoWithCashBankInfo:self.bankInfo
                                            complete:^(HXSErrorCode code, NSString *message, NSDictionary *data) {
                                                
                                                [HXSLoadingView closeInView:weakSelf.view];
                                                if(kHXSNoError == code){
                                                    
                                                    
                                                   // HXSUserAccount *userAccount = [HXSUserAccount currentAccount];
                                                    //HXSUserBasicInfo *basicInfo = userAccount.userInfo.basicInfo;
                                                    //HXSUserFinanceInfo *finalInfo = userAccount.userInfo.financeInfo;
                                                    
                                                    //缺少标志，标志已经绑定银行卡的标记，有了该标记就可以更新HXSUserAccount，让后台加该标记
                                                    // update user info in basic info class.
                                                    [[[HXSUserAccount currentAccount] userInfo] updateUserInfo];
                                                   
                                                    /*
                                                    HXSCashAmountViewController *controller = [HXSCashAmountViewController controllerWithAllAmount:weakSelf.allAmount cashBankInfo:self.bankInfo];
                                                    [weakSelf.navigationController pushViewController:controller animated:YES];*/
                                                    
                                                }else{
                                                    
                                                    
                                                    [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:1.5];
                                                }
                                            }];
}
- (void)addBankCardInfo
{
    WS(weakSelf);
    [HXSLoadingView showLoadingInView:self.view];
    
    HXSCashBankInfo *cashBankInfo = [[HXSCashBankInfo alloc]init];
    cashBankInfo.bankUserNameStr = self.nameCell.textField.text;
    cashBankInfo.bankCardNoStr = self.cardNumCell.textField.text;
    cashBankInfo.bankCodeStr = self.bankEntity.codeStr;
    cashBankInfo.bankCityStr = self.cityCell.textField.text;
    cashBankInfo.bankSiteStr = self.netDotCell.textField.text;
    
    [HXSCashModel addWithdrawWithCashBankInfo:(HXSCashBankInfo *)cashBankInfo
                                     complete:^(HXSErrorCode code, NSString *message, NSDictionary *data) {
                                         
                                         [HXSLoadingView closeInView:weakSelf.view];
                                         if(kHXSNoError == code){
                                             
                                             /*
                                             HXSCashAmountViewController *controller = [HXSCashAmountViewController controllerWithAllAmount:weakSelf.allAmount cashBankInfo:cashBankInfo];
                                             
                                             [weakSelf.navigationController pushViewController:controller animated:YES];*/
                                             
                                         }else{
                                             [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:1.5];
                                         }
                                     }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
