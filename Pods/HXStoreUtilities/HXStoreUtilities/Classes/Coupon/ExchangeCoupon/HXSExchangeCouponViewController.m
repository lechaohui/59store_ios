//
//  HXSExchangeCouponViewController.m
//  store
//
//  Created by 格格 on 16/10/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSExchangeCouponViewController.h"

// Cntrollers

// Models
#import "HXSCouponViewModel.h"

// Views
#import "HXSInfoInputCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "HXSExchangeCouponFooterView.h"
#import "HXSLoadingView.h"
#import "MBProgressHUD+HXS.h"
#import "UIViewController+Extensions.h"

@interface HXSExchangeCouponViewController ()<UITableViewDelegate,
                                              UITableViewDataSource>

@property (nonatomic, weak) IBOutlet TPKeyboardAvoidingTableView *tableView;
@property (nonatomic, strong) HXSInfoInputCell *couponCodeInputCell;
@property (nonatomic, strong) HXSExchangeCouponFooterView *footerView;

@end

@implementation HXSExchangeCouponViewController


#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNav];
    
    [self initialTableView];
    
    [self registKVO];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:self.couponCodeInputCell.valueTextField];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

+ (instancetype)exchangeCouponViewController
{
    return [HXSExchangeCouponViewController controllerFromXibWithModuleName:@"Coupon"];
}


#pragma mark - initial

- (void)initialNav
{
    self.navigationItem.title = @"券号兑换";
}

- (void)initialTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionFooterHeight = 0.1;
}


#pragma mark - KVO

- (void)registKVO
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.couponCodeInputCell.valueTextField];

}


#pragma mark - webService

- (void)exchangeCoupon
{
    [HXSLoadingView showLoadingInView:self.view];
    
    __weak typeof(self) weakSelf = self;
    
    [HXSCouponViewModel bindCouponWithCode:self.couponCodeInputCell.valueTextField.text
                                  complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
                                      
                                      [HXSLoadingView closeInView:weakSelf.view];
                                      
                                      if (kHXSNoError == code) {
                                          
                                          if ([weakSelf.delegate respondsToSelector:@selector(exchangeCouponSuccessed)]) {
                                              [self.delegate exchangeCouponSuccessed];
                                          }
                                          
                                           UIImageView *imageView  =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_done"]];
                                          [MBProgressHUD showInView:weakSelf.view customView:imageView status:message afterDelay:1.5];

                                          [weakSelf.navigationController popViewControllerAnimated:YES];
                                          
                                      } else {
                                          
                                          [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                      }
        
    }];
}


#pragma mark - UITableViewDelegate/UITableVIewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.couponCodeInputCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 84;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.footerView;
}


#pragma mark - UITextFieldDelegate

- (void)textFieldTextChanged:(NSNotification *)obj
{
    if(self.couponCodeInputCell.valueTextField.text.length > 0) {
        self.footerView.changeButton.enabled = YES;
    } else {
        self.footerView.changeButton.enabled = NO;
    }
}

#pragma mark - Getter/Setter

- (HXSInfoInputCell *)couponCodeInputCell
{
    if (nil == _couponCodeInputCell) {
        
        _couponCodeInputCell = [HXSInfoInputCell infoInputCell];
        _couponCodeInputCell.keyLabel.text = @"兑换码";
        _couponCodeInputCell.valueTextField.placeholder = @"请输入有效兑换码";
        _couponCodeInputCell.valueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _couponCodeInputCell;
}

- (HXSExchangeCouponFooterView *)footerView
{
    if(nil == _footerView) {
        _footerView = [HXSExchangeCouponFooterView exchangeCouponFooterView];
        _footerView.changeButton.enabled = NO;
        [_footerView.changeButton addTarget:self action:@selector(exchangeCoupon) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}


@end
