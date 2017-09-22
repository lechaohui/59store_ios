//
//  HXDBalanceOfAccountViewController.m
//  store
//
//  Created by caixinye on 2017/9/8.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXDBalanceOfAccountViewController.h"

#import "HXDAddBankInforParamEntity.h"
#import "HXDSellerInfoModel.h"
#import "HXDRechargeTableViewController.h"
#import "HXDWithdrawViewController.h"
#import "HXDAddMyBankViewController.h"

@interface HXDBalanceOfAccountViewController ()



@property (nonatomic, strong) HXDAddBankInforParamEntity *bankInfoEntity;
@property (nonatomic, strong) HXDSellerInfoViewModel *sellerInfoEntity;

@property (nonatomic, assign) BOOL isBind;//是否绑定
@property (assign, nonatomic) BOOL hasPayPwd;  // 支付密码
@property (assign, nonatomic) BOOL hasLoginPwd;// 登录密码

@end

@implementation HXDBalanceOfAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTitleview];
    [self initSubviews];
    
    
}

- (void)initTitleview{

    self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    //背景
    UIView *titleBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    titleBackView.backgroundColor=[UIColor colorWithHexString:@"fde25c"];
    [self.view addSubview:titleBackView];
    
    UILabel *titleLb=[Maker makeLb:CGRectMake(0, 20, SCREEN_WIDTH, 44)
                             title:@"店长资产"
                         alignment:NSTextAlignmentCenter
                              font:[UIFont systemFontOfSize:18]
                         textColor:[UIColor colorWithHexString:@"333333"]];
    [titleBackView addSubview:titleLb];
    
    //backbut
    UIButton *bacBut = [Maker makeBtn:CGRectMake(15, 25, 25, 34) title:nil img:@"btn_back_normal" font:nil target:self action:@selector(back)];
    [titleBackView addSubview:bacBut];
    
    //rightBut
    UIButton *rightBut = [Maker makeBtn:CGRectMake(SCREEN_WIDTH-65, 30, 60, 25) title:@"交易记录" img:nil font:[UIFont systemFontOfSize:14] target:self action:@selector(dealDtail:)];
    [titleBackView addSubview:rightBut];
    
    

}
- (void)initSubviews{

    //qianbi_icon
    UIImageView *logo = [Maker makeImgView:CGRectMake((SCREEN_WIDTH-80)/2.0, 64+20, 80, 80) img:@"qianbi_icon"];
    [self.view addSubview:logo];
    
    //moneyLabel
    UILabel *moneyLabel = [Maker makeLb:CGRectMake(0, CGRectGetMaxY(logo.frame)+20, SCREEN_WIDTH, 20) title:@"100元" alignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor]];
    [self.view addSubview:moneyLabel];

    
    //rechargeBtn
    UIButton *rechargeBtn = [Maker makeBtn:CGRectMake(10, CGRectGetMaxY(moneyLabel.frame)+20, SCREEN_WIDTH-20, 40) title:@"充值" img:nil font:[UIFont systemFontOfSize:16] target:self action:@selector(jumpToRecharge)];
    rechargeBtn.layer.cornerRadius = 5.0;
    rechargeBtn.titleLabel.textColor = [UIColor whiteColor];
    [rechargeBtn setBackgroundColor:[UIColor colorWithHexString:@"fde25c"]];
    [self.view addSubview:rechargeBtn];
    
    //withdrawBtn
    UIButton *withdrawBtn = [Maker makeBtn:CGRectMake(10, CGRectGetMaxY(rechargeBtn.frame)+20, SCREEN_WIDTH-20, 40) title:@"提现" img:nil font:[UIFont systemFontOfSize:16] target:self action:@selector(jumpToWithdraw)];
    withdrawBtn.layer.cornerRadius = 5.0;
    withdrawBtn.titleLabel.textColor = [UIColor blackColor];
    [withdrawBtn setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:withdrawBtn];
    

    
}
#pragma mark - target
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)dealDtail:(UIButton *)sender{




}
- (void)jumpToRecharge{

   
    HXDRechargeTableViewController *rechargeVC = [[HXDRechargeTableViewController alloc] init];
    [self.navigationController pushViewController:rechargeVC animated:YES];
    


}
- (void)jumpToWithdraw{

    if(self.bankInfoEntity.cardNumberStr)// 有银行卡号，说明已经绑定
    {
        self.isBind = YES;
    }
    if (!self.isBind) {
        // 银行卡没有绑定
        HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@""
                                                                          message:@"您尚未绑定银行卡，去绑定?"
                                                                  leftButtonTitle:@"不,谢谢"
                                                                rightButtonTitles:@"好,去绑定"];
        
        alertView.leftBtnBlock = ^(void){
            // do nothing
        };
        
        alertView.rightBtnBlock = ^(void) {
            HXDAddMyBankViewController *addBankCard = [[HXDAddMyBankViewController alloc] init];
            addBankCard.updateSucessBlock = ^() {
                
                [self getSellerBankInfo];
                
            };
            [self.navigationController pushViewController:addBankCard animated:YES];
        };
        [alertView show];
    }else if (!self.hasPayPwd){//没有支付密码
        // 没有支付密码
        HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@""
                                                                          message:@"为了您的账户安全,请先设置支付密码"
                                                                  leftButtonTitle:@"取消"
                                                                rightButtonTitles:@"去设置"];
        
        alertView.leftBtnBlock = ^(void){
            // do nothing
        };
        /*
        alertView.rightBtnBlock = ^(void) {
            HXDSettingPwdViewController *settingPwdVC = [[HXDSettingPwdViewController alloc] initWithPwdMode:HXSChangePasswordPay];
            [self.navigationController pushViewController:settingPwdVC animated:YES];
        };*/
        [alertView show];
    }
    else
    {
        HXDWithdrawViewController *withdrawVC = [[HXDWithdrawViewController alloc] initWithEntity:self.bankInfoEntity
                                                                                    mankeepAssets:nil
                                                                                       WithIsMike:NO];
        [self.navigationController pushViewController:withdrawVC animated:YES];
    }



}
#pragma mark networking

- (void)getSellerBankInfo {
    
    WS(ws);
    [HXSLoadingView showLoadingInView:self.view];
    [HXDSellerInfoModel fetchSellerBankInfoComplete:^(HXDErrorCode status, NSString *msg, HXDAddBankInforParamEntity *bankInfoModel) {
        
        [HXSLoadingView closeInView:ws.view];
        
        if (status == kHXDNoError) {
            
            ws.bankInfoEntity = bankInfoModel;
            
        } else {
            [MBProgressHUD showInViewWithoutIndicator:ws.view status:msg afterDelay:1.5];
        }
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
