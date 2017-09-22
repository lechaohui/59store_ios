//
//  HXSPersonMainViewController.m
//  store
//
//  Created by caixinye on 2017/9/16.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXSPersonMainViewController.h"

#import "HXSPersonalInfoTableViewController.h"
#import "HXSPersonal.h"
#import "HXSCouponViewController.h"
#import "HXSCouponMainViewController.h"
#import "HXDAddMyBankViewController.h"
#import "HXSChangePasswordViewController.h"
#import "HXSGetCashViewController.h"
#import "HXSBindCardViewController.h"

#import "HXSSite.h"
#import "HXSPersonalInfoModel.h"


@interface HXSPersonMainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImage *avatarImage;

@property (nonatomic, strong) NSArray *dataSource;
@property(nonatomic,strong)UITableView *tableView;

@property (nonatomic, strong) HXSPersonalInfoModel *personalInfoModel;


@end

@implementation HXSPersonMainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    
   
    
   // [HXSUsageManager trackEvent:kUsageEventPersonalInfoModify parameter:nil];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:self.tableView];
    [self intialDataSource];
    [self.tableView reloadData];
    
}
#pragma mark - Initial Methods
- (void)intialDataSource{

    HXSUserAccount *userAccount = [HXSUserAccount currentAccount];
    HXSUserBasicInfo *basicInfo = userAccount.userInfo.basicInfo;
    HXSUserFinanceInfo *finalInfo = userAccount.userInfo.financeInfo;
    
    
    NSArray *arraySection0 = [NSArray arrayWithObjects:
                              basicInfo.portrait ? basicInfo.portrait : @"未设置",
                              (basicInfo.couponQuantity>0) ? [NSString stringWithFormat:@"%d张",basicInfo.couponQuantity] : @"暂无优惠券",nil];
    
   // BOOL hasSignPasswd = [HXSUserAccount currentAccount].userInfo.basicInfo.passwordFlag;
    BOOL hasPayPasswd = [[HXSUserAccount currentAccount].userInfo.creditCardInfo.baseInfoEntity.havePasswordIntNum boolValue];
    NSArray *arraySection1 = [NSArray arrayWithObjects:
                              hasPayPasswd ? @"******" : @"未设置",
                              nil];
    

    BOOL hasCard = finalInfo.idCardNo;
    NSArray *section2 = [NSArray arrayWithObjects:hasCard ? @"******":@"添加银行卡", nil];

    self.dataSource = [NSArray arrayWithObjects:arraySection0, arraySection1,section2, nil];
    
    return;



}
#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    /*
    if (section ==0) {
        return 2;
        
    }else if (section==1){
    
        return 1;
    
    }

    return 0;*/
    NSArray *rows = self.dataSource[section];
    return rows.count;


}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *iden = @"cell_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:iden];
    }
    HXSUserAccount *userAccount = [HXSUserAccount currentAccount];
    HXSUserBasicInfo *basicInfo = userAccount.userInfo.basicInfo;
    HXSUserFinanceInfo *finalInfo = userAccount.userInfo.financeInfo;
    NSArray *textArr = @[@[@"个人信息",@"优惠券"],@[@"支付密码"],@[@""]];
    //add avatar in section 0 row 0
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *imageView = (UIImageView *)[cell.detailTextLabel subviewOfClassType:[UIImageView class]];
        if (imageView == nil) {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 0, 36, 36)];
        }
        
        if (self.avatarImage != nil) {
            
            imageView.image = self.avatarImage;
            self.avatarImage = nil;
        } else {
            
            NSString * url = [basicInfo.portrait stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"img_headsculpture"]];
        }
        
        CGRect frame = imageView.frame;
        frame.origin.y = 4.0;
        imageView.frame = frame;
        imageView.layer.cornerRadius = 36/2.0;
        imageView.clipsToBounds = YES;
        imageView.layer.borderWidth = 0.5;
        imageView.layer.borderColor = [UIColor colorWithRGBHex:0x6BCBFC].CGColor;
        
        [cell.contentView addSubview:imageView];
        

    } else if (indexPath.section==2){
        
        if (!finalInfo.idCardNo) {
            
            //没有银行卡
            UIImageView *imgView = [Maker makeImgView:CGRectMake((SCREEN_WIDTH-80)/2, 10, 30, 20) img:@"ic_addgoods_normal"];
            [cell.contentView addSubview:imgView];
            UILabel *titleLb = [Maker makeLb:CGRectMake(CGRectGetMaxX(imgView.frame)+2, 10, SCREEN_WIDTH/2-80, 20) title:@"添加银行卡" alignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"606060"]];
            [cell.contentView addSubview:titleLb];
        
        }else{
        
            //有银行卡
            
            
            
    
        }
        
    }else { // config the detailTextLabel
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"606060"];
        cell.detailTextLabel.text = self.dataSource[indexPath.section][indexPath.row];
        
        if (cell.detailTextLabel.text == nil || cell.detailTextLabel.text.length < 1) {
            
            cell.detailTextLabel.text = @"未填写";
        }

    }
    
    cell.textLabel.text = textArr[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"222222"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //cell.separatorInset = UIEdgeInsetsMake(0, 17, 0, 0);
    
    return cell;


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    if (indexPath.section==0&&indexPath.row==0) {
        return 50;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section==0) {
        return 10;
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section==2) {
        
        return 40;
    }

    return 0.01;

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{


    if (section==2) {
        UILabel *titleLb = [Maker makeLb:CGRectMake(20, 15, SCREEN_WIDTH-40, 23) title:@"银行卡(用于提现)" alignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"b0b0b0"]];
        
        return titleLb;
        
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    if (indexPath.section==0&&indexPath.row==0) {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PersonalInfo" bundle:nil];
    UIViewController *personalInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"HXSPersonalInfoTableViewController"];
        
    [self.navigationController pushViewController:personalInfoVC animated:YES];
        
    }else if (indexPath.section ==0&&indexPath.row==1){
    
    
        HXSCouponMainViewController *mainVc = [[HXSCouponMainViewController alloc] init];
        [self.navigationController pushViewController:mainVc animated:YES];
        /*
        HXSCouponViewController * couponViewController = [HXSCouponViewController controllerFromXibWithModuleName:@"Coupon"];
        couponViewController.couponScope = kHXSCouponScopeNone;
        couponViewController.fromPersonalVC = YES;
        [self.navigationController pushViewController:couponViewController animated:YES];*/
    
    }else if (indexPath.section ==1&&indexPath.row==0){
    
        
        //修改支付密码
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PersonalInfo"
                                                             bundle:[NSBundle mainBundle]];
        HXSChangePasswordViewController *VC = [storyboard instantiateViewControllerWithIdentifier:@"HXSChangePasswordViewController"];
        
        BOOL hasOldPassword = NO;
        VC.mode = HXSChangePasswordPay;
        
        [HXSUsageManager trackEvent:kUsageEventSettingPayPasswd parameter:nil];
        hasOldPassword = [[HXSUserAccount currentAccount].userInfo.creditCardInfo.baseInfoEntity.havePasswordIntNum boolValue];
       
        VC.hasOldPassword = hasOldPassword;
        
        [self.navigationController pushViewController:VC animated:YES];
    
    }
    else if (indexPath.section==2){
    
        HXSUserAccount *userAccount = [HXSUserAccount currentAccount];
        HXSUserFinanceInfo *finalInfo = userAccount.userInfo.financeInfo;
        if (finalInfo.idCardNo.length==0) {
            
        
            /*
            //没有银行卡.点击进入绑定银行卡
            HXDAddMyBankViewController *bind = [[HXDAddMyBankViewController alloc] init];
            [self.navigationController pushViewController:bind animated:YES];*/
            
            HXSBindCardViewController *bind = [[HXSBindCardViewController alloc] init];
            [self.navigationController pushViewController:bind animated:YES];
            
            
        }else{
        
        
        }
    }

}
#pragma mark - Setter Getter Methods

- (HXSPersonalInfoModel *)personalInfoModel
{
    if (nil == _personalInfoModel) {
        _personalInfoModel = [[HXSPersonalInfoModel alloc] init];
    }
    
    return _personalInfoModel;
}
- (UITableView *)tableView{

    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */

@end
