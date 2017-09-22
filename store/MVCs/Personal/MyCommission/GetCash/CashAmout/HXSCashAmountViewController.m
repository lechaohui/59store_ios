//
//  HXSCashAmountViewController.m
//  store
//
//  Created by 格格 on 16/10/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCashAmountViewController.h"

// Controllers
#import "HXSCashSucceedViewController.h"

// Models
#import "HXSWithdrawalRecordViewModel.h"

// Views
#import "TPKeyboardAvoidingTableView.h"
#import "HXSCashAmountBankCell.h"
#import "HXSCashAmountCell.h"
#import "HXSCashAmountSectionFooter.h"

// Others
#import "NSDecimalNumber+HXSStringValue.h"

@interface HXSCashAmountViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) IBOutlet TPKeyboardAvoidingTableView *table;
@property (nonatomic, strong) NSString *allAmount;
@property (nonatomic, strong) HXSCashBankInfo *cashBankInfo;

@property (nonatomic, strong) HXSCashAmountBankCell *cashAmountBankCell;
@property (nonatomic, strong) HXSCashAmountCell     *cashAmountCell;
@property (nonatomic, strong) HXSCashAmountSectionFooter *sectionFooter;

@end

@implementation HXSCashAmountViewController


#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNav];
    
    [self registeKVO];
    
    [self initialTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:self.cashAmountCell.cashTextField];
}

+ (instancetype)controllerWithAllAmount:(NSString *)allAmount cashBankInfo:(HXSCashBankInfo *)cashBankInfo;
{
    HXSCashAmountViewController *controller = [HXSCashAmountViewController controllerFromXib];
    controller.allAmount = allAmount;
    controller.cashBankInfo = cashBankInfo;
    
    return controller;
}


#pragma mark - initial

- (void)initialNav
{
    self.navigationItem.title = @"提现";
}

- (void)initialTable
{
    [self.table registerNib:[UINib nibWithNibName:NSStringFromClass([HXSCashAmountBankCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSCashAmountBankCell class])];
    
    [self.table registerNib:[UINib nibWithNibName:NSStringFromClass([HXSCashAmountCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSCashAmountCell class])];
    
    self.table.delegate = self;
    self.table.dataSource = self;
    
    self.table.separatorColor = [UIColor colorWithRGBHex:0xe1e2e3];
}

- (void)registeKVO
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFieldTextChanged:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:self.cashAmountCell.cashTextField];
}


#pragma mark - Target/Action

- (void)cashButtonClicked
{
    NSDecimalNumber *allAmountNum = [[NSDecimalNumber alloc]initWithString:self.allAmount];
    NSDecimalNumber *cashAmountNum = [[NSDecimalNumber alloc]initWithString:self.cashAmountCell.cashTextField.text];
    NSDecimalNumber *minAmountNum = [[NSDecimalNumber alloc]initWithString:@"10.00"];
    
    if ( NSOrderedAscending  ==  [cashAmountNum compare:minAmountNum]) {
        
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"最低提现金额10元" afterDelay:1.5];
        
        return;
    }
    
    if (NSOrderedAscending == [allAmountNum compare:cashAmountNum]) {
        
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"超出本次可提现金额" afterDelay:1.5];

        return;
    }
    
    WS(weakSelf);
    
    [HXSWithdrawalRecordViewModel addWithdrawWithbankCardId:self.cashBankInfo.bankCardIdStr
                                                      money:[cashAmountNum decimalNumberOfDecimalPlaces:2 decimalNumber:cashAmountNum]
                                                   complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
                                                          
                                                          if (kHXSNoError == code) {
                                                              
                                                              HXSCashSucceedViewController * controller = [HXSCashSucceedViewController controllerWithCashStr:weakSelf.cashAmountCell.cashTextField.text];
                                                              
                                                              [weakSelf.navigationController pushViewController:controller animated:YES];
                                                              
                                                              return ;
                                                          
                                                          }
                                                          
                                                          [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
        
    }];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldTextChanged:(NSNotification *)obj
{
    if (self.cashAmountCell.cashTextField.text.length > 0) {
        
        _sectionFooter.cashButton.enabled = YES;
        self.cashAmountCell.placeholderLabel.hidden = YES;
        
    } else {
        
        _sectionFooter.cashButton.enabled = NO;
        self.cashAmountCell.placeholderLabel.hidden = NO;
    }

}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        return 60;
    }
    
    return 122;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(0 == section) {
        return 15;
    }
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (0 == section) {
        return 10;
    }
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (1 == section) {
        
        return self.sectionFooter;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section){
        return self.cashAmountBankCell;
    }
    
    return self.cashAmountCell;
}


#pragma mark - Getter

- (HXSCashAmountBankCell *)cashAmountBankCell
{
    if (nil == _cashAmountBankCell) {
        
        _cashAmountBankCell = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([HXSCashAmountBankCell class]) owner:nil options:nil].firstObject;
        _cashAmountBankCell.cashBankInfo = self.cashBankInfo;
    }
    
    return _cashAmountBankCell;
}

- (HXSCashAmountCell *)cashAmountCell
{
    if (nil == _cashAmountCell) {
        
        _cashAmountCell = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([HXSCashAmountCell class]) owner:nil options:nil].firstObject;
        _cashAmountCell.allAmountStr = self.allAmount;
        
        _cashAmountCell.cashTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [_cashAmountCell becomeFirstResponder];
    }
    
    return _cashAmountCell;
}

- (HXSCashAmountSectionFooter *)sectionFooter
{
    if(nil == _sectionFooter) {
        
        _sectionFooter = [HXSCashAmountSectionFooter sectionFooter];
        _sectionFooter.cashButton.enabled = NO;
        [_sectionFooter.cashButton addTarget:self action:@selector(cashButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _sectionFooter;

}


@end
