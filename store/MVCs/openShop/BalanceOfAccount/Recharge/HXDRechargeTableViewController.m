//
//  HXDRechargeTableViewController.m
//  store
//
//  Created by caixinye on 2017/9/11.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXDRechargeTableViewController.h"

#import "HXDRechargeTableViewController.h"
#import "HXDRechargeMoneyTableViewCell.h"
#import "HXDRechargeBtnTableViewCell.h"
#import "HXSAlipayManager.h"

//#import "HXDPaymentCodeModel.h"
#import "HXDRechargeSuccessViewController.h"


NSString *const moneyCell = @"HXDRechargeMoneyTableViewCell";
NSString *const btnCell   = @"HXDRechargeBtnTableViewCell";


@interface HXDRechargeTableViewController ()<UITableViewDelegate, UITableViewDataSource, HXSAlipayDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *moneyTextField;
@property (nonatomic, strong) UIButton    *rechargeBtn;
//@property (nonatomic, strong) HXDAlipayOrderInfoEntity *orderInfoEntity;

@property (nonatomic, assign) BOOL isHaveDian;
@property (nonatomic, assign) BOOL isFirstZero;

@end

@implementation HXDRechargeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialView];
    [self initialtableView];
    
    
}
- (void)initialView {
    
    
    
    [self.view becomeFirstResponder];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tap];
    
}
- (void)initialtableView {
    
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    //背景
    UIView *titleBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    titleBackView.backgroundColor=[UIColor colorWithHexString:@"fde25c"];
    [self.view addSubview:titleBackView];
    
    UILabel *titleLb=[Maker makeLb:CGRectMake(0, 20, SCREEN_WIDTH, 44)
                             title:@"充值"
                         alignment:NSTextAlignmentCenter
                              font:[UIFont systemFontOfSize:18]
                         textColor:[UIColor colorWithHexString:@"333333"]];
    [titleBackView addSubview:titleLb];
    
    //backbut
    UIButton *bacBut = [Maker makeBtn:CGRectMake(15, 25, 25, 34) title:nil img:@"btn_back_normal" font:nil target:self action:@selector(back)];
    [titleBackView addSubview:bacBut];
    //self.title = @"充值";
    
    //__weak typeof(self) weakSelf = self;
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(weakSelf.view);
//    
//    }];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HXDRechargeMoneyTableViewCell" bundle:nil] forCellReuseIdentifier:moneyCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"HXDRechargeBtnTableViewCell" bundle:nil] forCellReuseIdentifier:btnCell];
    
}
- (void)initWithAccountId:(NSNumber *)accountId {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        HXDRechargeMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:moneyCell];
        
        self.moneyTextField = cell.moneyTextField;
        self.moneyTextField.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(udpateMoneyStatus:) name:UITextFieldTextDidChangeNotification object:self.moneyTextField];
        return cell;
    }
    else {
        HXDRechargeBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:btnCell];
        cell.backgroundColor = [UIColor clearColor];
        
        self.rechargeBtn = cell.rechargeBtn;
        [self updateMoneyButtonStatus:NO];
        [self.rechargeBtn addTarget:self action:@selector(goToRecharge) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    return nil;
}
- (void)goToRecharge {
    
    if ([self.moneyTextField.text floatValue] > 0) {
        [self getOrderIDStrAndNotifyURLStr];
    }else{
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"充值金额有误" afterDelay:1.5];
    }
}
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)getOrderIDStrAndNotifyURLStr {
    
    
    
    /*
    [WebService getRequest:HXD_PAY_DORM_RECHARGE
                parameters:nil
                  progress:nil
                  encToken:nil
                   isLogin:YES
                   success:^(HXDErrorCode status, NSString *msg, NSDictionary *data) {
                       
                       if ([data isKindOfClass:[NSDictionary class]] && nil != data) {
                           
                           self.orderInfoEntity.orderIDStr = [data objectForKey:@"order_id"];
                           self.orderInfoEntity.productDescriptionStr = [data objectForKey:@"notify_url"];
                           self.orderInfoEntity.orderTypeNameStr = @"充值";
                           self.orderInfoEntity.orderAmountFloatNum = [NSNumber numberWithFloat:[self.moneyTextField.text floatValue]];//订单金额
                           [[HXSAlipayManager sharedManager] pay:self.orderInfoEntity delegate:self];
                       }
                   } failure:^(HXDErrorCode status, NSString *msg, NSDictionary *data) {
                       [MBProgressHUD showInViewWithoutIndicator:self.view status:msg afterDelay:1.5];
                       DLog(@"充值====%@",msg);
                   }];*/
    
}
- (void)udpateMoneyStatus:(NSNotification *)notification
{
    BOOL hasInputed = NO;
    
    if (0 != [self.moneyTextField.text length] && nil == self.moneyTextField.markedTextRange) {
        hasInputed = YES;
    }
    
    [self updateMoneyButtonStatus:hasInputed];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Update Money Button Status

- (void)updateMoneyButtonStatus:(BOOL)isEnabled
{
    if (isEnabled) {
        [self.rechargeBtn setBackgroundColor:UIColorFromRGB(0x33A2FF)];
    } else {
        [self.rechargeBtn setBackgroundColor:UIColorFromRGB(0xD1D2D2)];
        
    }
    [self.rechargeBtn setEnabled:isEnabled];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 10;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (1 == indexPath.row) {
        
    }
}

- (void)hideKeyBoard
{
    [self.view endEditing:YES];
}
#pragma mark - UITextFieldDelegate

/**
 *  在textField 的代理中 处理 小数点和 0 的输入
 *
 *  @param textField   self.moneyTextField
 *  @param range
 *  @param string
 *
 *  @return  可否输入
 */

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.moneyTextField) {
        
        if ([textField.text rangeOfString:@"."].location==NSNotFound) {
            _isHaveDian = NO;
        }
        if ([textField.text rangeOfString:@"0"].location==NSNotFound) {
            _isFirstZero = NO;
        }
        
        if ([string length]>0)
        {
            unichar single=[string characterAtIndex:0];//当前输入的字符
            if ((single >='0' && single<='9') || single=='.')//数据格式正确
            {
                
                if([textField.text length]==0){
                    if(single == '.'){
                        //首字母不能为小数点
                        return NO;
                    }
                    if (single == '0') {
                        _isFirstZero = YES;
                        return YES;
                    }
                }
                
                if (single=='.'){
                    if(!_isHaveDian)//text中还没有小数点
                    {
                        _isHaveDian=YES;
                        return YES;
                    }else{
                        return NO;
                    }
                }else if(single=='0'){
                    if ((_isFirstZero&&_isHaveDian)||(!_isFirstZero&&_isHaveDian)) {
                        //首位有0有.（0.01）或首位没0有.（10200.00）可输入两位数的0
                        if([textField.text isEqualToString:@"0.0"]){
                            return NO;
                        }
                        NSRange ran=[textField.text rangeOfString:@"."];
                        int tt=(int)(range.location-ran.location);
                        if (tt <= 2){
                            return YES;
                        }else{
                            return NO;
                        }
                    }else if (_isFirstZero&&!_isHaveDian){
                        //首位有0没.不能再输入0
                        return NO;
                    }else{
                        return YES;
                    }
                }else{
                    if (_isHaveDian){
                        //存在小数点，保留两位小数
                        NSRange ran=[textField.text rangeOfString:@"."];
                        int tt= (int)(range.location-ran.location);
                        if (tt <= 2){
                            return YES;
                        }else{
                            return NO;
                        }
                    }else if(_isFirstZero&&!_isHaveDian){
                        //首位有0没点
                        return NO;
                    }else{
                        return YES;
                    }
                }
            }else{
                //输入的数据格式不正确
                return NO;
            }
        }else{
            return YES;
        }
    }
    return YES;
}

#pragma mark - HXSAlipayDelegate

/*
 9000 订单支付成功
 8000 正在处理中
 4000 订单支付失败
 6001 用户中途取消
 6002 网络连接出错
 */
- (void)payCallBack:(NSString *)status message:(NSString *)message result:(NSDictionary *)result
{
    if ([status isEqualToString:@"9000"]) { // success
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                HXDRechargeSuccessViewController *rechargeSuccessVC  = [[HXDRechargeSuccessViewController alloc] initWithMoneyStr:self.moneyTextField.text];
                [self.navigationController pushViewController:rechargeSuccessVC animated:YES];
            });
        }
        
        
    }else if ([status isEqualToString:@"6001"]){
        
        [MBProgressHUD showInViewWithoutIndicator:self.view.window status:@"用户中途取消" afterDelay:1.5];
//        [MBProgressHUD showInViewWithoutIndicator:self.view.window
//                                           status:@"用户中途取消" image:[UIImage imageNamed:@"ku_icon"] afterDelay:1.5];
        
    }else
    {
        NSString *messageStr = @"充值失败,请重新支付";
        [MBProgressHUD showInViewWithoutIndicator:self.view.window
                                           status:messageStr
                                       afterDelay:1.5f];
        
    }
    
}

#pragma mark - 懒加载

- (UITableView*)tableView {
    if (nil == _tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)
                                                 style:UITableViewStyleGrouped];
    }
    return _tableView;
}

/*
- (HXDAlipayOrderInfoEntity *)orderInfoEntity
{
    if (nil == _orderInfoEntity) {
        _orderInfoEntity = [[HXDAlipayOrderInfoEntity alloc] init];
    }
    
    return _orderInfoEntity;
}*/
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

@end
