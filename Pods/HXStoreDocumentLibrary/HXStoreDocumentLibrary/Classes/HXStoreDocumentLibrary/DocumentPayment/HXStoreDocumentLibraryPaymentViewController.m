//
//  HXStoreDocumentLibraryPaymentViewController.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/26.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibraryPaymentViewController.h"

//vc
#import "HXStoreDocumentLibraryPaymentResultViewController.h"

//views
#import "UIRenderingButton.h"
#import "HXSPrintAmountTableViewCell.h"
#import "HXSPrintPayMentTypeTableViewCell.h"

//model
#import "HXSPaymentOrderModel.h"
#import "HXSOrderRequest.h"
#import "HXSActionSheetEntity.h"
#import "HXSUserCreditcardInfoEntity.h"
#import "HXSUserInfo.h"
#import "HXSCreditPayManager.h"


//other
#import "HXStoreDocumentLibraryImport.h"
#import "HXSMediator.h"
#import "HXSMediator+OrderModule.h"
#import "HXSWXApiManager.h"
#import "HXSAlipayManager.h"

#define HXS_USAGE_EVENT_CHOOSE_PAYMENT_TYPE         @"choose_payment_type"         // 选择支付类型

static CGFloat const confirmViewHeight = 84;

typedef NS_ENUM(NSInteger,HXSPrintPaymentSectionIndex){
    HXSPrintPaymentSectionIndexPayAmount             = 0,//实付金额
    HXSPrintPaymentSectionIndexPayType               = 1,//支付方式
};

@interface HXStoreDocumentLibraryPaymentViewController ()<HXSAlipayDelegate,
                                                          HXSWechatPayDelegate>

@property (weak, nonatomic) IBOutlet UITableView                        *mainTableView;
@property (nonatomic, strong) UIView                                    *nextStepView;
@property (nonatomic, strong) UIRenderingButton                         *nextStepButton;
@property (nonatomic, strong) UIView                                    *payTypeContentView;
@property (nonatomic, strong) HXSOrderInfo                              *orderInfo;
@property (nonatomic, strong) NSArray<HXSActionSheetEntity *>           *dataSource;
/** 选择的支付类型*/
@property (nonatomic, strong) NSNumber                                  *selectedPayType;
@property (nonatomic, assign) BOOL                                      installMent;
@property (nonatomic, assign) HXSPrintPaymentType                       currentPaymentType;

@end

@implementation HXStoreDocumentLibraryPaymentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initOrderInforAttach];
    
    [self initialNavigationBar];
    
    [self initTableView];
    
    [self fetchPayTypeFormServer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - create

+ (instancetype)createPrintDocumentPaymentVCWithOrderInfo:(HXSOrderInfo *)orderInfo
                                              installment:(BOOL)installment
                                                  andType:(HXSPrintPaymentType)type
{
    HXStoreDocumentLibraryPaymentViewController *vc = [HXStoreDocumentLibraryPaymentViewController controllerFromXibWithModuleName:@"HXStoreDocumentLibrary"];
    vc.orderInfo    = orderInfo;
    vc.installMent  = installment;
    vc.currentPaymentType = type;
    return vc;
}

#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    switch (_currentPaymentType)
    {
        case HXSPrintPaymentTypeDocBuy:
        {
            self.navigationItem.title = @"支付";
        }
            
            break;
            
        default:
        {
            self.navigationItem.title = @"支付订单";
        }
            break;
    }

    [self.navigationItem.leftBarButtonItem setAction:@selector(giveUpPayingOrder)];
}

- (void)giveUpPayingOrder
{
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                      message:@"确认放弃支付吗？"
                                                              leftButtonTitle:@"取消"
                                                            rightButtonTitles:@"确认"];
    WS(weakSelf);
    
    alertView.rightBtnBlock = ^(void){
        switch (weakSelf.currentPaymentType)
        {
            case HXSPrintPaymentTypeDocBuy:
            {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
                
                break;
                
            default:
            {
                [weakSelf gotoOrderDetialViewController:NO];
            }
                break;
        }
    };
    
    [alertView show];
}

- (void)initTableView
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"HXStoreDocumentLibrary" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSPrintAmountTableViewCell class])
                                               bundle:bundle]
         forCellReuseIdentifier:NSStringFromClass([HXSPrintAmountTableViewCell class])];
    
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSPrintPayMentTypeTableViewCell class]) bundle:bundle]
         forCellReuseIdentifier:NSStringFromClass([HXSPrintPayMentTypeTableViewCell class])];
}

- (void)initOrderInforAttach
{
    if(_currentPaymentType != HXSPrintPaymentTypeDocBuy
       || !_orderInfo) {
        return;
    }
    
    NSString *attachStr = nil;
    HXSEnvironmentType environmentType = [[ApplicationSettings instance] currentEnvironmentType];
    if (environmentType == HXSEnvironmentStage) {
        attachStr = @"http://mobileapi.59store.net/library/new/doc/back";
    } else if(environmentType == HXSEnvironmentQA) {
        attachStr = @"http://mobileapi.59shangcheng.com/library/new/doc/back";
    } else {
        attachStr = @"http://mobileapi.59store.com/library/new/doc/back";
    }
    
    _orderInfo.attach = attachStr;
}


#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger section = 2;
    
    if(!_dataSource
       || _dataSource.count == 0) {
        section = 0;
    }
    
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    switch (section) {
        case HXSPrintPaymentSectionIndexPayType:
        {
            rows = [_dataSource count];
        }
            
            break;
            
        default:
        {
            rows = 1;
        }
            break;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case HXSPrintPaymentSectionIndexPayType:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSPrintPayMentTypeTableViewCell class])
                                                   forIndexPath:indexPath];
        }
            
            break;
            
        default:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSPrintAmountTableViewCell class])
                                            forIndexPath:indexPath];
        }
            break;
    }
    
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CGFloat height = 44;
    
    switch (indexPath.section) {
        case HXSPrintPaymentSectionIndexPayType:
        {
            height = 62;
        }
            
            break;
            
        default:
        {
            height = 44;
        }
            break;
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case HXSPrintPaymentSectionIndexPayType:
        {
            HXSPrintPayMentTypeTableViewCell *tempCell = (HXSPrintPayMentTypeTableViewCell *)cell;
            
            HXSActionSheetEntity *entity = self.dataSource[indexPath.row];
            tempCell.actionSheetEntity = entity;            
            //检测是否开通了59钱包以及是否钱包金额充足
            if (entity.payTypeIntNum.intValue == kHXSOrderPayTypeCreditCard) {
                [tempCell getStoreCreditPayInfoWithPayAmount:self.orderInfo.order_amount];
            }
        }
            
            break;
            
        default:
        {
            HXSPrintAmountTableViewCell *tempCell = (HXSPrintAmountTableViewCell *)cell;
            [tempCell setAmountNum:_orderInfo.order_amount];
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0;
    if(section == HXSPrintPaymentSectionIndexPayType) {
        height = 44;
    }
    
    return height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == HXSPrintPaymentSectionIndexPayType) {
        return self.payTypeContentView;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == HXSPrintPaymentSectionIndexPayType) {
        HXSActionSheetEntity *entity = _dataSource[indexPath.row];
        _selectedPayType = entity.payTypeIntNum;
        
        [_nextStepButton setEnabled:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - HXSAlipayDelegate

- (void)payCallBack:(NSString *)status message:(NSString *)message result:(NSDictionary *)result
{
    BOOL payResult = NO;
    
    if (status.intValue == 9000) { // 支付成功
        payResult = YES;
    } else {
        payResult = NO;
    }
    [self payDoneAndBackWithSuccess:payResult];
}

#pragma mark - HXSWechatPayDelegate

- (void)wechatPayCallBack:(HXSWechatPayStatus)status message:(NSString *)message result:(NSDictionary *)result
{
    BOOL payResult = NO;
    
    if (HXSWechatPayStatusSuccess == status) {
        payResult = YES;
    } else {
        payResult = NO;
    }
    
    [self payDoneAndBackWithSuccess:payResult];
}


#pragma mark - pay done and Back

- (void)payDoneAndBackWithSuccess:(BOOL)isSuccess
{
    switch (_currentPaymentType)
    {
        case HXSPrintPaymentTypePicPrint:
        {
            [self gotoOrderDetialViewController:isSuccess];
        }
            
            break;
            
        case HXSPrintPaymentTypeDocBuy:
        {
            [self.navigationController popViewControllerAnimated:YES];
            if(self.delegate
               && [self.delegate respondsToSelector:@selector(payFinishWithType:andSuccess:)]) {
                [self.delegate payFinishWithType:_currentPaymentType
                                      andSuccess:isSuccess];
            }
        }
            
            break;
            
        default:
        {
            if(isSuccess) {
                NSMutableArray<HXSOrderItem *> *array = [self checkCartArrayHasNoDocFromLib];
                
                if(array && array.count > 0) {
                    HXStoreDocumentLibraryPaymentResultViewController *resultVC = [HXStoreDocumentLibraryPaymentResultViewController createDocumentLibraryPaymentResultVCWithArray:_cartArray
                                                                                                                                                                      andOrderInfo:_orderInfo];
                    [self replaceCurrentViewControllerWith:resultVC animated:YES];
                } else {
                    [self gotoOrderDetialViewController:isSuccess];
                }
            } else {
                [self gotoOrderDetialViewController:isSuccess];
            }
        }
            break;
    }
}


#pragma mark - networking

- (void)fetchPayTypeFormServer
{
    WS(weakSelf);
    [HXSPaymentOrderModel fetchPayMethodsWith:@(_orderInfo.type)
                                    payAmount:_orderInfo.order_amount
                                  installment:@(_installMent) complete:^(HXSErrorCode code, NSString *message, NSArray *payArr) {
                                      [weakSelf.mainTableView endRefreshing];
                                      [HXSLoadingView closeInView:weakSelf.view];
                                      
                                      if (kHXSNoError != code
                                          || (0 >= payArr.count)) {
                                          if (weakSelf.isFirstLoading) {
                                              [HXSLoadingView showLoadFailInView:weakSelf.view
                                                                           block:^{
                                                                               [weakSelf fetchPayTypeFormServer];
                                                                           }];
                                          } else {
                                              [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                 status:message
                                                                             afterDelay:2.0f];
                                          }
                                          [weakSelf.mainTableView setTableFooterView:nil];
                                          [weakSelf.mainTableView setHidden:YES];
                                          return ;
                                      }
                                      
                                      weakSelf.firstLoading = NO;
                                      weakSelf.dataSource = payArr;
                                      [weakSelf.mainTableView reloadData];
                                      [weakSelf.mainTableView setTableFooterView:weakSelf.nextStepView];
                                  }];
}

- (void)checkPayStatus
{
    [MBProgressHUD showInView:self.view];
    
    WS(weakSelf);
    HXSOrderRequest *request = [[HXSOrderRequest alloc] init];
    [request fetchPayStatusWithOrderSN:_orderInfo.order_sn
                              compelte:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
                                  [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                  
                                  if (kHXSNoError != code) {
                                      [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                         status:message
                                                                     afterDelay:1.5f
                                                           andWithCompleteBlock:^{
                                                               [weakSelf gotoOrderDetialViewController:NO];
                                                           }];
                                      
                                      return ;
                                  }
                                  
                                  [weakSelf doPayAction];
                              }];
}


#pragma mark - Button Action

- (void)confirmPayAction:(UIButton *)button
{
    switch (_currentPaymentType)
    {
        case HXSPrintPaymentTypeDocBuy:
        {
            [self doPayAction];
        }
            
            break;
            
        default:
        {
            [self checkPayStatus];
        }
            break;
    }
}

/**
 *  执行支付操作
 */
- (void)doPayAction
{
    __weak typeof(self) weakSelf = self;
    
    switch ([self.selectedPayType integerValue]) {
            //现金
        case kHXSOrderPayTypeCash:
        {
            [HXSUsageManager trackEvent:HXS_USAGE_EVENT_CHOOSE_PAYMENT_TYPE parameter:@{@"business_type":self.orderInfo.typeName,@"type":@"货到付款"}];
            
            if(self.orderInfo.type == kHXSOrderTypeDorm) {
                HXSOrderRequest *request = [[HXSOrderRequest alloc] init];
                [request changeOrderPayTypeWithOrderSN:self.orderInfo.order_sn
                                              compelte:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
                                                  if (code == kHXSNoError)
                                                  {
                                                      [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
                                                      [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:2.0];
                                                      [weakSelf gotoOrderDetialViewController:YES];
                                                  }
                                                  else
                                                  {
                                                      [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
                                                      [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:2.0];
                                                  }
                                                  
                                              }];
            }
            
        }
            break;
            // 支付宝
        case  kHXSOrderPayTypeZhifu:
        {
            [HXSUsageManager trackEvent:HXS_USAGE_EVENT_CHOOSE_PAYMENT_TYPE parameter:@{@"business_type":_orderInfo.typeName,@"type":@"支付宝"}];
            [[HXSAlipayManager sharedManager] pay:_orderInfo
                                         delegate:self];
        }
            break;
            // 微信公众号支付
        case kHXSOrderPayTypeWechat:
        {
            // Do nothing
        }
            break;
            // 白花花支付
        case  kHXSOrderPayTypeBaiHuaHua:
        {
            // Do nothing
        }
            break;
            // 支付宝扫码付
        case kHXSOrderPayTypeAlipayScan:
        {
            // Do nothing
        }
            break;
            // 微信刷卡支付
        case  kHXSOrderPayTypeWechatScan:
        {
            // Do nothing
        }
            break;
            // 微信App支付
        case kHXSOrderPayTypeWechatApp:
        {
            if ([[HXSWXApiManager sharedManager] isWechatInstalled]) {
                [HXSUsageManager trackEvent:HXS_USAGE_EVENT_CHOOSE_PAYMENT_TYPE parameter:@{@"business_type":_orderInfo.typeName,@"type":@"微信"}];
                [[HXSWXApiManager sharedManager] wechatPay:_orderInfo
                                                  delegate:self];
            } else {
                HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                                  message:@"请先安装微信用户端, 再选择微信支付"
                                                                          leftButtonTitle:@"确认"
                                                                        rightButtonTitles:nil];
                
                [alertView show];
            }
        }
            break;
            // 信用钱包支付
        case kHXSOrderPayTypeCreditCard:
        {
            [HXSUsageManager trackEvent:HXS_USAGE_EVENT_CHOOSE_PAYMENT_TYPE parameter:@{@"business_type":_orderInfo.typeName,@"type":@"59钱包"}];
        }
            break;
            
        default:
            break;
    }
    
}

/**
 *  白花花 分期支付
 */
- (void)payOrderWithBaiHuaHua
{
    __weak typeof(self) weakSelf = self;
    
    HXSCreditPayOrderInfo *order = [[HXSCreditPayOrderInfo alloc] init];
    
    order.tradeTypeIntNum        = [NSNumber numberWithInteger:kHXStradeTypeNormal];
    order.orderSnStr             = _orderInfo.order_sn;
    order.orderTypeIntNum        = @(_orderInfo.type);
    order.amountFloatNum         = _orderInfo.order_amount;
    order.discountFloatNum       = _orderInfo.discount;
    order.orderDescriptionStr    = _orderInfo.orderDescriptionStr;
    order.periodsIntNum          = [NSNumber numberWithInteger:1];
    order.callBackUrlStr         = _orderInfo.attach;
    
    
    [[HXSCreditPayManager instance] payOrder:order completion:^(HXSCreditPayResulType operation, NSString *message, NSDictionary *info) {
        
        switch (operation) {
            case HXSCreditPayCanceled:
                // Do nothing
                break;
                
            case HXSCreditPaySuccess:
            {
                [self gotoOrderDetialViewController:YES];
            }
                break;
                
            case HXSCreditPayGetPasswdBack:
            case HXSCreditPayFailed:
            {
                [MBProgressHUD showInView:weakSelf.view
                               customView:nil
                                   status:message
                               afterDelay:1.5f
                            completeBlock:^{
                                [weakSelf gotoOrderDetialViewController:NO];
                            }];
            }
                break;
                
            default:
                break;
        }
    }];
}


#pragma mark - check Is cart has No doc from lib

/**
 *检测购物车中的文件是否没有文库的,如果有则剔除
 */
- (NSMutableArray<HXSMyPrintOrderItem *> *)checkCartArrayHasNoDocFromLib
{
    if(!_cartArray
       || _cartArray.count == 0) {
        return nil;
    }
    
    NSMutableArray<HXSMyPrintOrderItem *> *needToDeleteItem = [NSMutableArray array];
    
    for (HXSMyPrintOrderItem *orderItem in _cartArray) {
        if([orderItem.isFromLibraryDocumentNum boolValue]) {
            [needToDeleteItem addObject:orderItem];
        }
    }
    
    if(needToDeleteItem.count > 0) {
        [_cartArray removeObjectsInArray:needToDeleteItem];
    }
    
    return _cartArray;
}


#pragma mark - Jump Action

/**
 *  跳转到订单详情界面
 */
- (void)gotoOrderDetialViewController:(BOOL)result
{
    NSDictionary *dic = @{@"order_sn":self.orderInfo.order_sn};
    UIViewController *vc = [[HXSMediator sharedInstance] HXSMediator_orderDetailViewControllerWithParams:dic];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self replaceCurrentViewControllerWith:vc animated:YES];
}


#pragma mark getter

- (UIRenderingButton *)nextStepButton
{
    if(nil == _nextStepButton) {
        _nextStepButton = [[UIRenderingButton alloc]init];
        [_nextStepButton setCornerRadius:3];
        [_nextStepButton setTitle:@"确认支付" forState:UIControlStateNormal];
        [_nextStepButton setBackgroundColor:[UIColor colorWithRGBHex:0x07A9FA]];
        [_nextStepButton setBorderWidth:0.5];
        [_nextStepButton setEnabled:NO];
        [_nextStepButton setBorderColor:[UIColor colorWithRGBHex:0xe5e5e5]];
        [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextStepButton addTarget:self action:@selector(confirmPayAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextStepButton;
}

- (UIView *)nextStepView
{
    if(nil == _nextStepView) {
        _nextStepView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, confirmViewHeight)];
        [_nextStepView setBackgroundColor:[UIColor clearColor]];
        [_nextStepView addSubview:self.nextStepButton];
        [_nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nextStepView).offset(20);
            make.left.equalTo(_nextStepView).offset(15);
            make.right.equalTo(_nextStepView).offset(-15);
            make.height.mas_equalTo(44);
        }];
    }
    return _nextStepView;
}

- (UIView *)payTypeContentView
{
    if(nil == _payTypeContentView) {
        _payTypeContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        UILabel *label = [[UILabel alloc]init];
        [label setText:@"支付方式"];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        [label setTextColor:[UIColor colorWithRGBHex:0x999999]];
        [_payTypeContentView addSubview:label];
        [_payTypeContentView setBackgroundColor:[UIColor colorWithRGBHex:0xf5f6f7]];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_payTypeContentView).offset(15);
            make.centerY.equalTo(_payTypeContentView);
        }];
    }
    
    return _payTypeContentView;
}

@end
