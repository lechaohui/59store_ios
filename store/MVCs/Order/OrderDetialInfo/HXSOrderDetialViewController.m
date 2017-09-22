//
//  HXSOrderDetialViewController.m
//  store
//
//  Created by 格格 on 16/8/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSOrderDetialViewController.h"

// Controllers
#import "HXSOrderAppraiseViewController.h"
#import "HXSWebViewController.h"
#import "HXSCMBPayViewController.h"

// Views
#import "HXSOrderDetialOperateView.h"
#import "HXSCustomAlertView.h"
#import "HXSActionSheet.h"
#import "HXSShareView.h"

// Models
#import "HXSMyOrder.h"
#import "HXSOrderViewModel.h"
#import "HXSOrderDetialDataSource.h"
#import "HXSActionSheetModel.h"
#import "HXSAlipayManager.h"
#import "HXSBaiHuaHuaPayModel.h"
#import "HXSCreditPayManager.h"
#import "HXSWXApiManager.h"

#import "Udesk.h"
#import "UdeskAgentMenuViewController.h"
#import "HXSMediator+AccountModule.h"


@interface HXSOrderDetialViewController ()<UITableViewDelegate,
                                           UITableViewDataSource,
                                           HXSOrderDetialOperateViewDelegate,
                                           HXSOrderDetialDataSourceDelegate,
                                           HXSAlipayDelegate,
                                           HXSWechatPayDelegate,
                                           HXSOrderAppraiseViewControllerDelegate,
                                           HXSCMBPayViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *myTable;
@property (nonatomic, weak) IBOutlet HXSOrderDetialOperateView *operateView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *operateViewBotton;
@property (nonatomic, strong) UIButton *contactButton;

@property (nonatomic, strong) HXSOrderDetialDataSource *dataSource;

@property (nonatomic, strong) NSString *orderSnStr;
@property (nonatomic, strong) HXSMyOrder *myOrder;

@property (nonatomic, assign) BOOL waitPayCheck;


@end

@implementation HXSOrderDetialViewController


#pragma mark - lift cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigation];
    
    [self initialPrama];
    
    [self initialOperateView];
    
    [self initialTable];
    
    [self initialNewConfigUdesk];
    
    [self fectchMyOederDetial];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self changeNavigationBarBackgroundColor:[UIColor colorWithRGBHex:navBarWhiteBgColorValue]
                        pushBackButItemImage:[UIImage imageNamed:@"fanhui"]
                     presentBackButItemImage:[UIImage imageNamed:@"xia"]
                                  titleColor:[UIColor colorWithRGBHex:navBarWhiteTitleVolorValue]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self changeNavigationBarNormal];
}

+ (instancetype)controllerWithMyOrder:(NSString *)order_sn;
{
    HXSOrderDetialViewController *controller = [[HXSOrderDetialViewController alloc]initWithNibName:nil bundle:nil];
    controller.orderSnStr = order_sn;
    
    return controller;
}

#pragma mark - override

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


#pragma mark - initial

- (void) initialNavigation
{
    self.navigationItem.title = @"订单详情";

    self.contactButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    [self.contactButton setImage:[UIImage imageNamed:@"ic_Contact"] forState:UIControlStateNormal];
    
    [self.contactButton addTarget:self
                      action:@selector(navRightItemClicked)
            forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.contactButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
  
    
    
}

- (void)initialPrama
{
    self.waitPayCheck = NO;
    self.dataSource = [[HXSOrderDetialDataSource alloc]init];
    self.dataSource.delegate = self;
}

- (void)initialOperateView
{
    self.operateView.delegate = self;
    self.operateView.layer.borderWidth = 1;
    self.operateView.layer.borderColor = HXS_COLOR_SEPARATION_STRONG.CGColor;
    [self.operateView setBackgroundColor:[UIColor whiteColor]];
}

- (void)initialTable
{
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    
    [self.myTable setBackgroundColor:[UIColor clearColor]];
    [self.myTable setSeparatorColor:HXS_COLOR_SEPARATION_STRONG];
    
    WS(weakSelf);
    [self.myTable addRefreshHeaderWithCallback:^{
        [weakSelf fectchMyOederDetial];
    }];
}

- (void)initialNewConfigUdesk
{
    // 构造参数
    HXSUserInfo *userInfo = [HXSUserAccount currentAccount].userInfo;
    
    NSString *nick_name = userInfo.basicInfo.uName;
    NSString *sdk_token = [[HXSUserAccount currentAccount] strToken];
    NSString *uid = [NSString stringWithFormat:@"%@", userInfo.basicInfo.uid];
    
    
    //获取用户自定义字段
    [UdeskManager getCustomerFields:^(id responseObject, NSError *error) {
        
        NSDictionary *customerFieldValueDic = @{};
        for (NSDictionary *dict in responseObject[@"user_fields"]) {
            if ([dict[@"field_label"] isEqualToString:@"用户id"]) {
                NSString *keyStr = dict[@"field_name"];
                
                customerFieldValueDic = @{keyStr: uid};
            }
        }
        
        NSDictionary *userDic = @{
                                  @"sdk_token":              [NSString md5:sdk_token],
                                  @"nick_name":              nick_name,
                                  @"customer_field":         customerFieldValueDic,
                                  };
        
        NSDictionary *parameters = @{@"user":userDic};
        // 创建用户
        [UdeskManager createCustomerWithCustomerInfo:parameters];
    }];
    
}


#pragma mark - Target/Action

- (void)navRightItemClicked
{
    self.contactButton.enabled = NO;
    
    UdeskSDKManager *chatViewManager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle defaultStyle]];
    
    [chatViewManager pushUdeskViewControllerWithType:UdeskMenu viewController:self];
    
    self.contactButton.enabled = YES;
}

- (void)displaySelectPayTypeView:(NSArray *)payMethodsArr
{
     HXSActionSheet *sheet = [HXSActionSheet actionSheetWithMessage:@"请选择支付方式" cancelButtonTitle:@"取消"];
    
    WS(weakSelf);
    
    /** 支付相关的界面用的HXSOrderInfo,这里先用HXSOrderInfo，后期再改 */
    HXSOrderInfo *order = [[HXSOrderInfo alloc]init];
    order.order_sn = self.myOrder.orderDetailInfo.orderIdStr;
    order.order_amount = [self.myOrder.orderDetailInfo.payAmountDecNum yuanDecialNum];
    order.typeName = @"";
    order.type = self.myOrder.orderDetailInfo.bizTypeStr.intValue;
    
    // 时间为毫秒 将时间转为秒
    NSDecimalNumber *timeDivider = [NSDecimalNumber decimalNumberWithString:@"1000"];
    NSDecimalNumber *orderTimeMaoSec = [NSDecimalNumber decimalNumberWithString:self.myOrder.orderDetailInfo.orderTimeStr];
    NSDecimalNumber *orderTimeSec = [orderTimeMaoSec decimalNumberByDividingBy:timeDivider];
    order.add_time = orderTimeSec;
    
    for (int i = 0; i < [payMethodsArr count]; i++) {
        HXSActionSheetEntity *sheetEntity = [payMethodsArr objectAtIndex:i];
        switch ([sheetEntity.payTypeIntNum integerValue]) {
            case kHXSOrderPayTypeCash:
            {
                HXSAction *action = [HXSAction actionWithMethods:sheetEntity
                                                         handler:^(HXSAction *action) {
                                                             [weakSelf payCheckWithBlock:^{
                                                                 [weakSelf changeToCrashPay];
                                                             }];
                                                         }];
                [sheet addAction:action];
            }
                break;
                
            case kHXSOrderPayTypeZhifu:
            {
                HXSAction *payAction = [HXSAction actionWithMethods:sheetEntity
                                                            handler:^(HXSAction *action) {
                                                                
                                                                [weakSelf payCheckWithBlock:^{
                                                                    [[HXSAlipayManager sharedManager] pay:order delegate:weakSelf];
                                                                }];
                                                                
                                                            }];
                
                [sheet addAction:payAction];
            }
                break;
                
            case kHXSOrderPayTypeWechatApp:
            {
                HXSAction *wechatPayAction = [HXSAction actionWithMethods:sheetEntity
                                                                  handler:^(HXSAction *action) {
                                                                      
                                                                      [weakSelf payCheckWithBlock:^{
                                                                          [[HXSWXApiManager sharedManager] wechatPay:order delegate:weakSelf];
                                                                      }];
                                                                  }];
                [sheet addAction:wechatPayAction];
            }
                break;
                
            case kHXSOrderPayTypeCreditCard:
            {
                HXSAction *baiHuahuaAction = [HXSAction actionWithMethods:sheetEntity
                                                                  handler:^(HXSAction *action) {
                                                                      
                                                                      [weakSelf payCheckWithBlock:^{
                                                                          [[HXSCreditPayManager instance] checkCreditPay:^(HXSCreditCheckResultType operation) {
                                                                              if (operation == HXSCreditCheckSuccess) {
                                                                                  [weakSelf payOrderWith:kHXSOrderPayTypeCreditCard withErrorMessage:nil];
                                                                              }
                                                                          }];
                                                                      }];
                                                                  }];
                
                [sheet addAction:baiHuahuaAction];
            }
                break;
                
            case kHXSOrderPayTypeAlipayScan:
            {
                // Do nothing
            }
                break;
                
            case kHXSOrderPayTypeCMB:
            {
                HXSAction *cmbPayAction = [HXSAction actionWithMethods:sheetEntity
                                                                  handler:^(HXSAction *action) {
                                                                      
                                                                      [weakSelf payCheckWithBlock:^{
                                                                          NSString *tokenStr = [[HXSMediator sharedInstance] HXSMediator_token];
                                                                          NSString *urlStr = [[ApplicationSettings instance] cmbPayURL];
                                                                          NSString *url = [NSString stringWithFormat:urlStr, order.order_sn, [order.order_amount doubleValue], tokenStr];
                                                                          HXSCMBPayViewController *cmbVC = [HXSCMBPayViewController createCMBPayWithUrl:url delegate:self];
                                                                          
                                                                          [weakSelf.navigationController pushViewController:cmbVC animated:YES];
                                                                      }];
                                                                  }];
                [sheet addAction:cmbPayAction];
            }
                break;
                
                
            default:
                break;
        }
    }
    
    [sheet show];
}

- (void)changeToCrashPay
{
    WS(weakSelf);
    
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@""
                                                                      message:@"您确定要将该订单转为货到付款吗?"
                                                              leftButtonTitle:@"取消"
                                                            rightButtonTitles:@"货到付款"];
    
    alertView.rightBtnBlock = ^{
        [weakSelf cashPay];
    };
    [alertView show];

}


#pragma mark - Baihuahua Methods

- (void)payOrderWith:(HXSOrderPayType)payType withErrorMessage:(NSString *)errorMessageStr
{
    switch (payType) {
        case kHXSOrderPayTypeCreditCard:
        {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            
            HXSMyOrderItem *itemEntity = [self.myOrder.orderItemsArr firstObject];
            NSString *titleStr                = itemEntity.nameStr;
            
            HXSCreditPayOrderInfo *order = [[HXSCreditPayOrderInfo alloc] init];
            order.tradeTypeIntNum = [NSNumber numberWithInteger:kHXStradeTypeNormal];
            order.orderSnStr = self.myOrder.orderDetailInfo.orderIdStr;
            order.orderTypeIntNum = [numberFormatter numberFromString:self.myOrder.orderDetailInfo.bizTypeStr];
            
            order.amountFloatNum = [self.myOrder.orderDetailInfo.payAmountDecNum yuanDecialNum];
            order.discountFloatNum = [self.myOrder.orderDetailInfo.discountDecNum yuanDecialNum];
            
            order.orderDescriptionStr = titleStr;
            order.periodsIntNum = [NSNumber numberWithInteger:1];
            
            __weak typeof(self) weakSelf = self;
            [[HXSCreditPayManager instance] payOrder:order completion:^(HXSCreditPayResulType operation, NSString *message, NSDictionary *info) {
                switch (operation) {
                    case HXSCreditPaySuccess:
                    {
                        [weakSelf dealWithBaiHuaHuaResult:YES];
                    }
                        break;
                    case HXSCreditPayCanceled:
                    {
                        [weakSelf dealWithBaiHuaHuaResult:NO];
                    }
                        break;
                    case HXSCreditPayGetPasswdBack:
                    {
                        // do nothing
                    }
                        break;
                    case HXSCreditPayFailed:
                    {
                        [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                           status:message
                                                       afterDelay:1.5f];
                        [weakSelf dealWithBaiHuaHuaResult:NO];
                    }
                        break;
                        
                    default:
                        break;
                }
            }];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)dealWithBaiHuaHuaResult:(BOOL)hasPaid
{
    HXSCustomAlertView *alertView = nil;
    
    if (hasPaid) {
        alertView = [[HXSCustomAlertView alloc] initWithTitle:@"支付结果"
                                                      message:@"支付成功"
                                              leftButtonTitle:@"确定"
                                            rightButtonTitles:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pay_success" object:nil];
        [self fectchMyOederDetial];
        if ([self.delegate respondsToSelector:@selector(orderStatusChange)]) {
            [self.delegate orderStatusChange];
        }
        
    } else {
        alertView = [[HXSCustomAlertView alloc] initWithTitle:@"支付结果"
                                                      message:@"支付失败"
                                              leftButtonTitle:@"确定"
                                            rightButtonTitles:nil];
    }
    
    [alertView show];
}


#pragma mark - pay call back

- (void)payCallBack:(NSString *)status message:(NSString *)message result:(NSDictionary *)result
{
    NSString *messageStr = nil;
    if(status.intValue == 9000) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pay_success" object:nil];
        [self fectchMyOederDetial];
        if ([self.delegate respondsToSelector:@selector(orderStatusChange)]) {
            [self.delegate orderStatusChange];
        }
        messageStr = @"支付成功";
    }else if(status.intValue == 6001){
        messageStr = (message && message.length > 0)?message:@"用户取消";
    }else if(status.intValue == 4000) {
        messageStr = @"支付失败";
    }else if (message.length > 0) {
        messageStr = message;
    }
    
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"支付结果"
                                                                      message:messageStr
                                                              leftButtonTitle:@"确定"
                                                            rightButtonTitles:nil];
    [alertView show];
    
}



#pragma mark - webService

- (void)fectchMyOederDetial
{
    WS(weakSelf);
    
    [HXSLoadingView showLoadingInView:self.view];
    
    [HXSOrderViewModel fecthOrderDetialWithOrderId:self.orderSnStr
                                          complete:^(HXSErrorCode status, NSString *message, HXSMyOrder *myOrder) {
        
                                              if (kHXSNoError == status) {
                                                  
                                                  if ([myOrder.orderStatus.statusTextStr isEqualToString:@"待支付"]
                                                      && weakSelf.waitPayCheck == NO) {
                                                      weakSelf.waitPayCheck = YES;
                                                      
                                                      dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
                                                      dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                                                          [weakSelf fectchMyOederDetial];
                                                      });
                                                  } else {
                                                      
                                                      [HXSLoadingView closeInView:weakSelf.view];
                                                      [weakSelf.myTable endRefreshing];
                                                      
                                                      weakSelf.myOrder = myOrder;
                                                      weakSelf.dataSource.myOrder = myOrder;
                                                      [weakSelf updateOperateView];
                                                      [weakSelf.myTable reloadData];
                                                      
                                                  }
                                                  
                                              } else {
                                                  [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                                  [weakSelf.navigationController popViewControllerAnimated:YES];
                                              }
    }];
 }

- (void)cancleOrder
{
    WS(weakSelf);
    
    [HXSLoadingView showLoadingInView:self.view];
    
    [HXSOrderViewModel cancleOrderWithOrderId:self.myOrder.orderDetailInfo.orderIdStr
                                     complete:^(HXSErrorCode status, NSString *message, NSDictionary *dic) {
                                         
                                         [HXSLoadingView closeInView:weakSelf.view];
                                         
                                         if (kHXSNoError == status) {
                                             [weakSelf fectchMyOederDetial];
                                             
                                             if ([weakSelf.delegate respondsToSelector:@selector(orderStatusChange)]) {
                                                 [weakSelf.delegate orderStatusChange];
                                             }
                                             
                                         } else {
                                             [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                         }
    }];
}

- (void)cashPay
{
    [HXSLoadingView showLoadingInView:self.view];
    
    WS(weakSelf);
    
    [HXSOrderViewModel cashOnDeliveryWithOrderId:self.myOrder.orderDetailInfo.orderIdStr
                                     complete:^(HXSErrorCode status, NSString *message, NSDictionary *dic) {
        
                                         [HXSLoadingView closeInView:weakSelf.view];
                                         
                                         if (kHXSNoError == status) {
                                             
                                             [weakSelf fectchMyOederDetial];
                                             
                                             if ([weakSelf.delegate respondsToSelector:@selector(orderStatusChange)]) {
                                                 [weakSelf.delegate orderStatusChange];
                                             }

                                             return;
                                         }
                                         
                              [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
        
    }];
}


- (void)payCheckWithBlock:(void (^)()) block
{
    [HXSLoadingView showLoadingInView:self.view];
    
    WS(weakSelf);
    
    [HXSOrderViewModel payCheckWithOrderId:self.orderSnStr
                                  complete:^(HXSErrorCode status, NSString *message, NSDictionary *dic) {
                                      
                                      [HXSLoadingView closeInView:weakSelf.view];
                                      
                                      if (kHXSNoError == status) {
                                          block();
                                          return ;
                                      }
                                      
                                      [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                      [weakSelf fectchMyOederDetial];
        
    }];
}


#pragma mark - HXSWechatPayDelegate

- (void)wechatPayCallBack:(HXSWechatPayStatus)status
                  message:(NSString *)message
                   result:(NSDictionary *)result
{
    NSString *messageStr = nil;
    
    if (HXSWechatPayStatusSuccess == status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pay_success" object:nil];
        [self fectchMyOederDetial];
        
        if ([self.delegate respondsToSelector:@selector(orderStatusChange)]) {
            [self.delegate orderStatusChange];
        }
        
        messageStr = @"支付成功";
    } else {
        messageStr = @"支付失败";
    }
    
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"支付结果"
                                                                      message:messageStr
                                                              leftButtonTitle:@"确定"
                                                            rightButtonTitles:nil];
    [alertView show];
}

#pragma mark - HXSCMBPayViewControllerDelegate

- (void)cmbPayFailure
{
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"支付结果"
                                                                      message:@"支付失败"
                                                              leftButtonTitle:@"确定"
                                                            rightButtonTitles:nil];
    [alertView show];
}

- (void)cmbPaySuccess
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pay_success" object:nil];
    [self fectchMyOederDetial];
    
    if ([self.delegate respondsToSelector:@selector(orderStatusChange)]) {
        [self.delegate orderStatusChange];
    }
    
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"支付结果"
                                                                      message:@"支付成功"
                                                              leftButtonTitle:@"确定"
                                                            rightButtonTitles:nil];
    [alertView show];
}


#pragma mark - HXSOrderDetialDataSourceDelegate

// 倒计时为0秒的时候，重新请求，刷新界面
- (void)countdownOver
{
    [self fectchMyOederDetial];
    
    if ([self.delegate respondsToSelector:@selector(orderStatusChange)]) {
        [self.delegate orderStatusChange];
    }
}

// 联系商家
- (void)contactMerchant
{
    HXSCustomAlertView *alert = [[HXSCustomAlertView alloc]initWithTitle:@"拨打商家电话"
                                                                 message:self.myOrder.shopInfo.sellerPhoneStr
                                                         leftButtonTitle:@"取消"
                                                       rightButtonTitles:@"拨号"];
    WS(weakSelf);
    alert.rightBtnBlock = ^{
        
        NSString *phoneNumber = [@"tel://" stringByAppendingString:weakSelf.myOrder.shopInfo.sellerPhoneStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    };
    
    [alert show];
}


#pragma mark - HXSOrderDetialOperateViewDelegate

// 点击取消按钮
- (void)operateViewCancleButtonClicked
{
    if (([self.myOrder.orderDetailInfo.bizTypeStr isEqualToString:@"21"]
         ||[self.myOrder.orderDetailInfo.bizTypeStr isEqualToString:@"22"])
        && [self.myOrder.orderStatus.statusTextStr isEqualToString:@"待打印"]) {
    
        [MBProgressHUD showInViewWithoutIndicator:self.view
                                           status:@"请联系店长取消订单哦~" afterDelay:1.5];
        
        return;
    }
    
    HXSCustomAlertView *alert = [[HXSCustomAlertView alloc]initWithTitle:@"提醒"
                                                                 message:@"确定要取消订单吗？"
                                                         leftButtonTitle:@"放弃"
                                                       rightButtonTitles:@"取消订单"];
    
    WS(weakSelf);
    
    alert.rightBtnBlock = ^{
        [weakSelf cancleOrder];
    };
    
    [alert show];
}

// 点击立即支付按钮
- (void)operateViewPayNowButtonClicked
{
    WS(weakSelf);
    
    [HXSLoadingView showLoadingInView:self.view];
    
    [HXSOrderViewModel fetchPayMethodsWith:self.myOrder.orderDetailInfo.bizTypeStr
                                 payAmount:[self.myOrder.orderDetailInfo.payAmountDecNum yuanDecialNum]
                               installment:@"0" complete:^(HXSErrorCode code, NSString *message, NSArray *payArr) {
                                   
                                   [HXSLoadingView closeInView:weakSelf.view];
                                   
                                   if (kHXSNoError != code) {
                                       [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                          status:message
                                                                      afterDelay:1.5f];
                                       
                                       return ;
                                   }
                                   
                                   [weakSelf displaySelectPayTypeView:payArr];
        
    }];

}

// 查看参与详情
- (void)operateViewCheckDetailOfParticipateButtonClicked
{
    NSString *joinUrl = [self.myOrder.extInfoDic objectForKey:@"one_dollor_link"];
    
    if(joinUrl && [joinUrl isKindOfClass:[NSString class]] && joinUrl.length > 0) {
        [self pushToVCWithLink:joinUrl];
    }
}

// 查看约团详情
- (void)operateViewCheckDetailOfGroupButtonClicked
{
    NSString *groupUrl = [self.myOrder.extInfoDic objectForKey:@"group_link"];
    
    if(groupUrl && [groupUrl isKindOfClass:[NSString class]] && groupUrl.length > 0) {
         [self pushToVCWithLink:groupUrl];
    }
}

// 评价得10积分按钮点击
- (void)operateViewEvaluationButtonClicked
{
    HXSOrderAppraiseViewController *orderAppraiseViewController = [HXSOrderAppraiseViewController controllerWithShopInfo:self.myOrder.shopInfo orderId:self.myOrder.orderDetailInfo.orderIdStr];
    orderAppraiseViewController.delegate = self;
    
    [self.navigationController pushViewController:orderAppraiseViewController animated:YES];
}

// 邀请好友参团
- (void)operateViewJoinGroupButtonClicked
{
    __weak typeof(self) weakSelf = self;
    HXSShareParameter *parameter = [[HXSShareParameter alloc] init];
    parameter.shareTypeArr = @[@(kHXSShareTypeQQMoments), @(kHXSShareTypeWechatFriends),
                               @(kHXSShareTypeQQFriends), @(kHXSShareTypeWechatMoments),@(kHXSShareTypeCopyLink)];
    
    HXSShareView *shareView = [[HXSShareView alloc] initShareViewWithParameter:parameter
                                                                      callBack:^(HXSShareResult shareResult, NSString *msg)
                               {
                                   [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                      status:msg
                                                                  afterDelay:1.5];
                               }];
    
    
    HXSMyOrderItem *orderItem = [self.myOrder.orderItemsArr firstObject];
    NSString *missingNumStr = [self.myOrder.extInfoDic objectForKey:@"group_diff_num"];
    if (nil == missingNumStr) {
        missingNumStr = @"1";
    }
    
    shareView.shareParameter.titleStr    = [NSString stringWithFormat:@"还差%@人！我买了%@", missingNumStr, orderItem.nameStr];
    shareView.shareParameter.textStr     = @"今天在传说中特靠谱的59约团中发现了一件超值好货，吃瓜群众们都抢疯啦~";
    shareView.shareParameter.imageURLStr = orderItem.imgStr;
    NSString *groupUrl = [self.myOrder.extInfoDic objectForKey:@"group_link"];
    shareView.shareParameter.shareURLStr = groupUrl;
    [shareView show];
}


#pragma mark - HXSOrderAppraiseViewControllerDelegate(评价)

// 评价成功
- (void)appraiseSuccess
{
    [self fectchMyOederDetial];
    
    if ([self.delegate respondsToSelector:@selector(orderStatusChange)]) {
        [self.delegate orderStatusChange];
    }
}



#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.dataMArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SectionModel *sectionModel = [self.dataSource.dataMArr objectAtIndex:section];
    return sectionModel.rowInfoCellMarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionModel *sectionModel = [self.dataSource.dataMArr objectAtIndex:indexPath.section];
    RowModel *rowModel = [sectionModel.rowInfoCellMarr objectAtIndex:indexPath.row];
    
    return rowModel.cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionModel *sectionModel = [self.dataSource.dataMArr objectAtIndex:indexPath.section];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /* 账单信息和订单信息cell之间不需要分割线 */
    if (sectionModel.sectionType == OrderDetialSectionTypeBillInfo
        ||  sectionModel.sectionType == OrderDetialSectionTypeOrderInfo
        || sectionModel.sectionType == OrderDetialSectionTypeOrderStatus) {
        
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, SCREEN_WIDTH)];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionModel *sectionModel = [self.dataSource.dataMArr objectAtIndex:indexPath.section];
    RowModel *rowModel = [sectionModel.rowInfoCellMarr objectAtIndex:indexPath.row];

    return rowModel.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    SectionModel *sectionModel = [self.dataSource.dataMArr objectAtIndex:section];
    
    /* 商品信息和订单信息上方留有10像素的间隙 */
    if (sectionModel.sectionType == OrderDetialSectionTypeGoodsList
        || sectionModel.sectionType == OrderDetialSectionTypeOrderInfo ) {
        return 10.0;
    }
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


#pragma mark - Private Mothed

- (void)updateOperateView
{
    if (self.myOrder.viewButtonArr && self.myOrder.viewButtonArr.count > 0) {
        self.operateViewBotton.constant = -1;
        self.operateView.viewButtonArr = self.myOrder.viewButtonArr;
    } else {
        self.operateViewBotton.constant = -45;
    }
}

#pragma mark Puch To LinkStr VCs

- (void)pushToVCWithLink:(NSString *)linkStr
{
    NSURL *url = [NSURL URLWithString:linkStr];
    if (nil == url) {
        url = [NSURL URLWithString:[linkStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    UIViewController *viewController = [[HXSMediator sharedInstance] performActionWithUrl:url
                                                                               completion:nil];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
