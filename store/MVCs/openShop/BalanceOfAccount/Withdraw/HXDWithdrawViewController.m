//
//  HXDWithdrawViewController.m
//  59dorm
//
//  Created by wupei on 16/7/7.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXDWithdrawViewController.h"
//#import "HXDWithdrawSuccessViewController.h"
#import "NSString+Addition.h"
#import "HXSPayPasswordAlertView.h"
#import "HXDAddBankInforParamEntity.h"

@interface HXDWithdrawViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UIAlertViewDelegate,HXSPayPasswordAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView  *bankIconImageView;
@property (weak, nonatomic) IBOutlet UILabel      *bankNameLabel; // 银行名称
@property (weak, nonatomic) IBOutlet UILabel      *cardNumLabel; // 卡号

@property (weak, nonatomic) IBOutlet UILabel      *withdrawMoneyLabel; // 可提现金额
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;

@property (weak, nonatomic) IBOutlet UIButton     *confirmBtn; // 确认提交
@property (weak, nonatomic) IBOutlet UITextField  *moneyTF;    // 提现金额输入框

@property (weak, nonatomic) IBOutlet UILabel *minWithdrawCountLabel; // 最小提现金额
@property (weak, nonatomic) IBOutlet UILabel *reachTipLabel;  // 到账提示文案


@property (nonatomic, strong) UIAlertView                   *customAlertView;
@property (nonatomic, strong) HXSPayPasswordAlertView       *walletPasswordAlertview;//支付密码填写
@property (nonatomic, strong) HXDAddBankInforParamEntity    *bankInfoEntity;
@property (nonatomic, strong) NSNumber                      *mankeepAssets;
@property (nonatomic, assign) BOOL                          isMike;
@property (nonatomic, strong) NSString                      *availableCash;//店长的可提现金额
@property (nonatomic, assign) CGFloat                       minWithdrawCount;


@end

@implementation HXDWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialView];
    [self initialNotification];
    self.scrollerView.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /*
    if ([HXDUserAccount currentAccount].accountType == HXDAccountTypeShopOwnerAndMankeep ||
        [HXDUserAccount currentAccount].accountType == HXDAccountTypeOnlyShopOwner) {
        
        [self getShoperAvalableCash];
    }*/
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (instancetype)initWithEntity:(HXDAddBankInforParamEntity *)bankInfoEntity mankeepAssets:(NSNumber *)mankeepAssets WithIsMike:(BOOL)isMike {
    if (self = [super init]) {
        _bankInfoEntity = bankInfoEntity;
        _mankeepAssets = mankeepAssets;
        _isMike = isMike;
        _minWithdrawCount = isMike ? 20.0 : 50.0;
    }
    return self;
}

/**
 *  提交金额和密码
 *
 *  @param money    金额
 *  @param passward 密码
 */
/*
- (void)submitWithMoney:(NSNumber *)money passwd:(NSString *)passward {
    
    NSDictionary *parameterDic = @{
                                   @"money":   money,
                                   @"passwd":  passward,
                                   };
    //需要判断是 店长还是脉客
    NSString *url = HXD_DORM_WITHDRAWAL;//默认是店长
    
    if (self.isMike) {//脉客
        url  = HXD_MK_WITHDRAW;
        NSString *mankeepIdStr = [HXDUserAccount currentAccount].mankeepId;
        parameterDic = @{
                         @"mk_id":    mankeepIdStr,
                         @"amount":   money,
                         @"pay_password":  passward,
                         };
    }
    WS(ws);
    [WebService postRequest:url
                 parameters:parameterDic
                   progress:nil
                   encToken:nil
                    isLogin:YES
                    success:^(HXDErrorCode status, NSString *msg, NSDictionary *data) {
                       
                       if (kHXDNoError != status) {
                           [MBProgressHUD showInViewWithoutIndicator:ws.view status:msg afterDelay:1.5];
                           return ;
                       }
                       //提现提交成功
                       HXDWithdrawSuccessViewController *successVC = [[HXDWithdrawSuccessViewController alloc] initWithMinWithdrawCount:self.minWithdrawCount mankeepIdentity:self.isMike];
                       [ws.navigationController pushViewController:successVC animated:YES];
                        
                   } failure:^(HXDErrorCode status, NSString *msg, NSDictionary *data) {
                       [ws.walletPasswordAlertview close];
                       [MBProgressHUD showInViewWithoutIndicator:ws.view status:msg afterDelay:1.5];
                   }];
}*/


- (void)initialView
{
    self.title = @"提现";

    self.view.backgroundColor = [UIColor colorWithRGBHex:0xf4f5f6];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tap];
    
    self.moneyTF.delegate = self;
    
    [self updateMoneyButtonStatus:NO];
    [self.confirmBtn.layer setCornerRadius:5];
    [self.confirmBtn addTarget:self action:@selector(confirmSubmit) forControlEvents:UIControlEventTouchUpInside];
    //配置银行卡信息
    if (self.bankInfoEntity.cardNumberStr) {
        //图片
        [self.bankIconImageView sd_setImageWithURL:[NSURL URLWithString:self.bankInfoEntity.bankImageStr] placeholderImage:[UIImage imageNamed:@"default_user_icon"]];
        [self.bankNameLabel setText:self.bankInfoEntity.bankNameStr];
        NSInteger length = self.bankInfoEntity.cardNumberStr.length;
        NSString *numStr = [self.bankInfoEntity.cardNumberStr substringFromIndex:(length - 4)];
        [self.cardNumLabel setText:[NSString stringWithFormat:@"(尾号%@)",numStr]];
    }
    
    if (self.isMike) {
        self.withdrawMoneyLabel.text = [NSString stringWithFormat:@"￥ %.2f",[self.mankeepAssets floatValue]];
        self.minWithdrawCountLabel.text = [NSString stringWithFormat:@"￥%.2f",self.minWithdrawCount];
        self.reachTipLabel.text = @"提现申请提交后两个工作日内到账，节假日顺延。";
    }
}

/**
 *  获取店长客提现金额
 */
/*
- (void)getShoperAvalableCash {
    WS(ws);
    [WebService getRequest:HXD_DORM_AVAILABLE_CASH
                parameters:nil
                  progress:nil
                  encToken:nil isLogin:YES success:^(HXDErrorCode status, NSString *msg, NSDictionary *data) {
                      
                      if (nil != data && [data isKindOfClass:[NSDictionary class]]) {
                          if (!self.isMike) {
                             self.withdrawMoneyLabel.text = [NSString stringWithFormat:@"￥ %.2f",[[data objectForKey:@"available_cash"] floatValue]];
                              self.availableCash = [NSString stringWithFormat:@"%@",[data objectForKey:@"available_cash"]];
                          }
                      }
                      
                  } failure:^(HXDErrorCode status, NSString *msg, NSDictionary *data) {
                      [MBProgressHUD showInViewWithoutIndicator:ws.view status:msg afterDelay:1.5];
                  }];
}*/

/**
 *  初始化通知，键盘和Textfiled
 */
- (void)initialNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(udpateMoneyStatus:) name:UITextFieldTextDidChangeNotification object:self.moneyTF];
}

#pragma mark - confirm Button Action

- (void)confirmSubmit {
    float maxAvailableCash;
    if (self.isMike) {
        maxAvailableCash = [self.mankeepAssets floatValue];
    }else{
        maxAvailableCash = [self.availableCash floatValue];
    }
    
    if ([self.moneyTF.text floatValue] < self.minWithdrawCount ) {
        NSString *status = [NSString stringWithFormat:@"可提现金额最少为%0.2f元哦~", self.minWithdrawCount];
        [MBProgressHUD showInViewWithoutIndicator:self.view.window status:status afterDelay:2.0];
    } else if([self.moneyTF.text floatValue] > maxAvailableCash) {
        [MBProgressHUD showInViewWithoutIndicator:self.view.window status:@"已超过最大可提现金额哦~" afterDelay:2.0];
    }else {
        [self showAlert];
    }
}

/**
 *  显示提示框
 */
- (void)showAlert
{
    [self.view endEditing:YES];
    
    HXSPayPasswordAlertView *alertView = [[HXSPayPasswordAlertView alloc] initWithTitle:@"请输入支付密码"
                                                                               message:nil
                                                                       leftButtonTitle:@"取消"
                                                                     rightButtonTitles:@"付款"];
    alertView.customAlertViewDelegate = self;
    self.walletPasswordAlertview = alertView;
    [self.walletPasswordAlertview show];
}

#pragma mark HXSPayPasswordAlertViewDelegate

- (void)alertView:(HXSPayPasswordAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
           passwd:(NSString *)passwd
  exemptionStatus:(NSNumber *)hasSelectedExemptionBoolNum {
    
    if (1 == buttonIndex) {
        //NSString *md5Password = [NSString md5:passwd];//密码加密
        //[self submitWithMoney:[NSNumber numberWithFloat:[self.moneyTF.text floatValue]] passwd:md5Password];
    }else {
        [self.walletPasswordAlertview close];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)hideKeyBoard {
    [self.view endEditing:YES];
}


// 限制输入两位小数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    
    [futureString  insertString:string atIndex:range.location];
    
    NSInteger flag = 0;
    
    const NSInteger limited = 2;//小数点后需要限制的个数
    
    for (NSInteger i = futureString.length - 1; i >= 0; i--) {
        
        if ([futureString characterAtIndex:i] == '.') {
            if (flag > limited) {
                return NO;
            }
            break;
        }
        flag++;
    }
    return YES;
}

- (void)udpateMoneyStatus:(NSNotification *)notification
{
    BOOL hasInputed = NO;
    if (0 != [self.moneyTF.text length] && nil == self.moneyTF.markedTextRange) {
        hasInputed = YES;
    }
    [self updateMoneyButtonStatus:hasInputed];
}

#pragma mark - Update Money Button Status

- (void)updateMoneyButtonStatus:(BOOL)isEnabled
{
    [self.confirmBtn setEnabled:isEnabled];
}

#pragma mark - keyBorad Notification

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        self.scrollerView.contentOffset = CGPointMake(0, 50);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        self.scrollerView.contentOffset = CGPointMake(0,0);
    }];
    
}

@end
