//
//  HXSOrderListViewController.m
//  store
//
//  Created by 格格 on 16/8/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSOrderListViewController.h"

// Controllers
#import "HXSOrderDetialViewController.h"
#import "HXSOrderAppraiseViewController.h"
#import "HXSCMBPayViewController.h"

// Models
#import "HXSOrderViewModel.h"
#import "HXSOrderProgress.h"
#import "HXSMyOrder.h"
#import "HXSActionSheetModel.h"
#import "HXSAlipayManager.h"
#import "HXSBaiHuaHuaPayModel.h"
#import "HXSCreditPayManager.h"
#import "HXSWXApiManager.h"

// Views
#import "HXShopNameAndOrderStatusCell.h"
#import "HXSGoodsInfoCell.h"
#import "HXSOrderBillCell.h"
#import "HXSOrderListOperateCell.h"
#import "HXSActionSheet.h"
#import "HXSShareView.h"

#import "HXSMediator+AccountModule.h"

typedef NS_ENUM(NSInteger, OrderListViewCellType)
{
    orderListViewCellTypeOrderHeader     = 0,
    orderListViewCellTypeOrderItem       = 1,
    orderListViewCellTypeOrderFooter     = 2,
    orderListViewCellTypeOrderOperate    = 3
};

static CGFloat const kTableViewSectionHeaderHeight       = 0.1;
static CGFloat const kTableViewSectionFooterHeight       = 10.0;

static CGFloat const kHXShopNameAndOrderStatusCellHeight = 50.0;
static CGFloat const kHXSGoodsInfoCellHeight             = 80.0;
static CGFloat const kHXSOrderBillCellHeight             = 44.0;
static CGFloat const kHXSOrderOperateCellHeight          = 50.0;

static CGFloat const kHXSGoodsInfoCellSeparatorInset     = 80.0;
static CGFloat const KOtherCellSeparatorInset            = 0.0;

@interface HXSOrderListViewController () <UITableViewDelegate,
                                          UITableViewDataSource,
                                          HXSOrderDetialViewControllerDelegate,
                                          HXSOrderListOperateCellDelegate,
                                          HXSOrderAppraiseViewControllerDelegate,
                                          HXSAlipayDelegate,
                                          HXSWechatPayDelegate,
                                          HXSCMBPayViewControllerDelegate>

@property (nonatomic,weak) IBOutlet UITableView *myTable;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger size;
@property (nonatomic,assign) BOOL ifGetMore;

@property (nonatomic, strong) NSMutableArray *dataMarr;
@property (nonatomic, strong) UIView *noDataFooterView;
@property (nonatomic, assign) BOOL firstLoaded;

@property (nonatomic, strong) HXSMyOrder *tempOrder;

@end

@implementation HXSOrderListViewController


#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialPrama];
    
    [self initialTable];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.firstLoaded) {
        [HXSLoadingView showLoadingInView:self.view];
        self.firstLoaded = YES;
    }
    
    [self fetchMyOrders];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


+ (HXSOrderListViewController *)controllerWithOrderProgress:(HXSOrderProgress *)orderProgress
{
    HXSOrderListViewController *controller = [[HXSOrderListViewController alloc]initWithNibName:nil bundle:nil];
    controller.orderProgress = orderProgress;
    return controller;
}

- (void)dealloc
{
    self.orderDetialStatusChange = nil;
}

#pragma mark - initial

- (void)initialPrama
{
    self.page = 1;
    self.size = 20;
    self.ifGetMore = NO;
    self.dataMarr = [NSMutableArray array];
}

- (void)initialTable
{
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.separatorColor = HXS_COLOR_SEPARATION_STRONG;
    
    [self.myTable registerNib:[UINib nibWithNibName:NSStringFromClass([HXShopNameAndOrderStatusCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXShopNameAndOrderStatusCell class])];
    [self.myTable registerNib:[UINib nibWithNibName:NSStringFromClass([HXSGoodsInfoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSGoodsInfoCell class])];
    [self.myTable registerNib:[UINib nibWithNibName:NSStringFromClass([HXSOrderBillCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSOrderBillCell class])];
    
    [self.myTable registerNib:[UINib nibWithNibName:NSStringFromClass([HXSOrderBillCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSOrderBillCell class])];
    [self.myTable registerNib:[UINib nibWithNibName:NSStringFromClass([HXSOrderListOperateCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSOrderListOperateCell class])];
    
    WS(weakSelf);
    
    [self.myTable addRefreshHeaderWithCallback:^{
        weakSelf.ifGetMore = NO;
        [weakSelf fetchMyOrders];
    }];
    
    [self.myTable addInfiniteScrollingWithActionHandler:^{
        weakSelf.ifGetMore = YES;
        [weakSelf fetchMyOrders];
    }];
    
    [self.myTable setShowsInfiniteScrolling:NO];

}


#pragma mark - Target/Action

- (void)refresh
{
    [self fetchMyOrders];
}


#pragma mark - webService

- (void)fetchMyOrders
{
    NSInteger currentpage;
    if(self.ifGetMore) {
        currentpage = self.page + 1;
    } else {
        currentpage = 1;
    }
    
    WS(weakSelf);
    
    [HXSOrderViewModel fecthMyordersWithQueryStatus:self.orderProgress.fatchName
                                               page:currentpage
                                           pageSize:self.size
                                           complete:^(HXSErrorCode status, NSString *message, NSArray *ordersArr) {
                                               
                                               [HXSLoadingView closeInView:weakSelf.view];
                                               
                                               [weakSelf.myTable endRefreshing];
                                               [[weakSelf.myTable infiniteScrollingView] stopAnimating];
                                               
                                               if(kHXSNoError == status) {
                                                   
                                                   if(weakSelf.ifGetMore) {
                                                   } else {
                                                       [weakSelf.dataMarr removeAllObjects];
                                                   }
                                                   weakSelf.page = currentpage;
                                                   
                                                   [weakSelf.myTable setShowsInfiniteScrolling:ordersArr.count > 0];
                                                   
                                                   [weakSelf.dataMarr addObjectsFromArray:ordersArr];
                                                   
                                                   if(weakSelf.dataMarr.count > 0) {
                                                       
                                                       [weakSelf.myTable setTableFooterView:nil];
                                                   } else {
                                                       [weakSelf.myTable setTableFooterView:weakSelf.noDataFooterView];
                                                   }
                                                   
                                                   [weakSelf.myTable reloadData];
                                               
                                               } else {
                                                   [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                               }
    }];
    
}

- (void)fectchMyOederDetial:(HXSMyOrder *)order
{
    WS(weakSelf);
    
    [HXSLoadingView showLoadingInView:self.view];
    
    [HXSOrderViewModel fecthOrderDetialWithOrderId:order.orderDetailInfo.orderIdStr
                                          complete:^(HXSErrorCode status, NSString *message, HXSMyOrder *myOrder) {
                                              
                                              [HXSLoadingView closeInView:weakSelf.view];
                                              
                                              if (kHXSNoError == status) {
                                                  
                                                  NSInteger index = [weakSelf.dataMarr indexOfObject:order];
                                                  
                                                  if (index < [weakSelf.dataMarr count]) {
                                                      [weakSelf.dataMarr replaceObjectAtIndex:index withObject:myOrder];
                                                      
                                                      [weakSelf.myTable reloadSections:[NSIndexSet indexSetWithIndex:index]  withRowAnimation:UITableViewRowAnimationFade];
                                                  }
                                                  
                                                  [weakSelf orderStatusChange];
                                                  
                                              } else {
                                                  [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                                  [weakSelf.navigationController popViewControllerAnimated:YES];
                                              }
                                          }];
}

- (void)cancleOrder:(HXSMyOrder *)order
{
    WS(weakSelf);
    
    [HXSLoadingView showLoadingInView:self.view];
    
    [HXSOrderViewModel cancleOrderWithOrderId:order.orderDetailInfo.orderIdStr
                                     complete:^(HXSErrorCode status, NSString *message, NSDictionary *dic) {
                                         
                                         [HXSLoadingView closeInView:weakSelf.view];
                                         
                                         if (kHXSNoError == status) {
                                             
                                             [weakSelf refreshData:order];
                                         }
                                         
                                         [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                     }];

}

- (void)payCheckWithOrder:(HXSMyOrder *)order block:(void (^)()) block
{
    [HXSLoadingView showLoadingInView:self.view];
    
    WS(weakSelf);
    
    [HXSOrderViewModel payCheckWithOrderId:order.orderDetailInfo.orderIdStr
                                  complete:^(HXSErrorCode status, NSString *message, NSDictionary *dic) {
                                      
                                      [HXSLoadingView closeInView:weakSelf.view];
                                      
                                      if (kHXSNoError == status) {
                                          block();
                                          return ;
                                      }
                                      
                                      [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                      
                                      [weakSelf orderStatusChange];
                                      
                                  }];
}

- (void)cashPay:(HXSMyOrder *)order
{
    [HXSLoadingView showLoadingInView:self.view];
    
    WS(weakSelf);
    
    [HXSOrderViewModel cashOnDeliveryWithOrderId:order.orderDetailInfo.orderIdStr
                                        complete:^(HXSErrorCode status, NSString *message, NSDictionary *dic) {
                                            
                                            [HXSLoadingView closeInView:weakSelf.view];
                                            
                                            if (kHXSNoError == status) {
                                                
                                                [weakSelf refreshData:order];
                                                
                                                return;
                                            }
                                            
                                            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                            
                                        }];
}

#pragma mark - private Mothed

- (void)refreshData:(HXSMyOrder *)order
{
    if (nil != order) {
        
        if(HXSOrderProgressTypeAll != self.orderProgress.progressType) {
            [self.dataMarr removeObject:order];
            [self orderStatusChange];
            
            if(self.dataMarr.count > 0) {
                [self.myTable setTableFooterView:nil];
            } else {
                [self.myTable setTableFooterView:self.noDataFooterView];
            }
            
            [self.myTable reloadData];
        } else {
            [self fectchMyOederDetial:order];
        }
    }
    

}

- (OrderListViewCellType)cellTypeWithOrder:(HXSMyOrder *)order row:(NSInteger)row
{
    if (0 == row) {
        
        return orderListViewCellTypeOrderHeader;
        
    } else if (order.orderItemsArr.count + 1 == row) {
        
        return orderListViewCellTypeOrderFooter;
        
    } else if (order.orderItemsArr.count + 2 == row) {
    
        return orderListViewCellTypeOrderOperate;
        
    } else {
        
        return orderListViewCellTypeOrderItem;
    }

}

- (void)displaySelectPayTypeView:(NSArray *)payMethodsArr order:(HXSMyOrder *)myOrder
{
    HXSActionSheet *sheet = [HXSActionSheet actionSheetWithMessage:@"请选择支付方式" cancelButtonTitle:@"取消"];
    
    WS(weakSelf);
    
    /** 支付相关的界面用的HXSOrderInfo,这里先用HXSOrderInfo，后期再改 */
    HXSOrderInfo *order = [[HXSOrderInfo alloc]init];
    order.order_sn = myOrder.orderDetailInfo.orderIdStr;
    order.order_amount = [myOrder.orderDetailInfo.payAmountDecNum yuanDecialNum];
    order.typeName = @"";
    order.type = myOrder.orderDetailInfo.bizTypeStr.intValue;
    
    // 时间为毫秒 将时间转为秒
    NSDecimalNumber *timeDivider = [NSDecimalNumber decimalNumberWithString:@"1000"];
    NSDecimalNumber *orderTimeMaoSec = [NSDecimalNumber decimalNumberWithString:myOrder.orderDetailInfo.orderTimeStr];
    NSDecimalNumber *orderTimeSec = [orderTimeMaoSec decimalNumberByDividingBy:timeDivider];
    order.add_time = orderTimeSec;
    
    for (int i = 0; i < [payMethodsArr count]; i++) {
        HXSActionSheetEntity *sheetEntity = [payMethodsArr objectAtIndex:i];
        switch ([sheetEntity.payTypeIntNum integerValue]) {
            case kHXSOrderPayTypeCash:
            {
                HXSAction *action = [HXSAction actionWithMethods:sheetEntity
                                                         handler:^(HXSAction *action) {
                                                             [weakSelf payCheckWithOrder:myOrder block:^{
                                                                 [weakSelf changeToCrashPay:myOrder];
                                                             }];
                                                         }];
                [sheet addAction:action];
            }
                break;
                
            case kHXSOrderPayTypeZhifu:
            {
                HXSAction *payAction = [HXSAction actionWithMethods:sheetEntity
                                                            handler:^(HXSAction *action) {
                                                                
                                                                [weakSelf payCheckWithOrder:myOrder block:^{
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
                                                                      
                                                                      [weakSelf payCheckWithOrder:myOrder block:^{
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
                                                                      
                                                                      [weakSelf payCheckWithOrder:myOrder block:^{
                                                                          [[HXSCreditPayManager instance] checkCreditPay:^(HXSCreditCheckResultType operation) {
                                                                              if (operation == HXSCreditCheckSuccess) {
                                                                                  [weakSelf payOrderWith:kHXSOrderPayTypeCreditCard withErrorMessage:nil order:myOrder];
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
                                                                   [weakSelf payCheckWithOrder:myOrder block:^{
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

- (void)changeToCrashPay:(HXSMyOrder *)order
{
    WS(weakSelf);
    
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@""
                                                                      message:@"您确定要将该订单转为货到付款吗?"
                                                              leftButtonTitle:@"取消"
                                                            rightButtonTitles:@"货到付款"];
    
    alertView.rightBtnBlock = ^{
        [weakSelf cashPay:order];
    };
    [alertView show];
    
}

#pragma mark - Baihuahua Methods

- (void)payOrderWith:(HXSOrderPayType)payType withErrorMessage:(NSString *)errorMessageStr order:(HXSMyOrder *)myOrder
{
    switch (payType) {
        case kHXSOrderPayTypeCreditCard:
        {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            
            HXSMyOrderItem *itemEntity = [myOrder.orderItemsArr firstObject];
            NSString *titleStr                = itemEntity.nameStr;
            
            HXSCreditPayOrderInfo *order = [[HXSCreditPayOrderInfo alloc] init];
            order.tradeTypeIntNum = [NSNumber numberWithInteger:kHXStradeTypeNormal];
            order.orderSnStr = myOrder.orderDetailInfo.orderIdStr;
            order.orderTypeIntNum = [numberFormatter numberFromString:myOrder.orderDetailInfo.bizTypeStr];
            
            order.amountFloatNum = [myOrder.orderDetailInfo.payAmountDecNum yuanDecialNum];
            order.discountFloatNum = [myOrder.orderDetailInfo.discountDecNum yuanDecialNum];
            
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
        [self refreshData:self.tempOrder];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"pay_success" object:nil];
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
        
        [self refreshData:self.tempOrder];
        
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

#pragma mark - HXSWechatPayDelegate

- (void)wechatPayCallBack:(HXSWechatPayStatus)status
                  message:(NSString *)message
                   result:(NSDictionary *)result
{
    NSString *messageStr = nil;
    
    if (HXSWechatPayStatusSuccess == status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pay_success" object:nil];
        
        [self refreshData:self.tempOrder];
        
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
    
    [self refreshData:self.tempOrder];
    
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"支付结果"
                                                                      message:@"支付成功"
                                                              leftButtonTitle:@"确定"
                                                            rightButtonTitles:nil];
    [alertView show];
}


#pragma mark - HXSOrderListOperateCellDelegate

// 点击取消按钮
- (void)operateViewCancleButtonClicked:(HXSMyOrder *)order
{
    if (([order.orderDetailInfo.bizTypeStr isEqualToString:@"21"]
         ||[order.orderDetailInfo.bizTypeStr isEqualToString:@"22"])
        && [order.orderStatus.statusTextStr isEqualToString:@"待打印"]) {
        
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
        [weakSelf cancleOrder:order];
    };
    
    [alert show];

}
// 点击立即支付按钮
- (void)operateViewPayNowButtonClicked:(HXSMyOrder *)order
{
    self.tempOrder = order;
    
    WS(weakSelf);
    
    [HXSLoadingView showLoadingInView:self.view];
    
    [HXSOrderViewModel fetchPayMethodsWith:order.orderDetailInfo.bizTypeStr
                                 payAmount:[order.orderDetailInfo.payAmountDecNum yuanDecialNum]
                               installment:@"0" complete:^(HXSErrorCode code, NSString *message, NSArray *payArr) {
                                   
                                   [HXSLoadingView closeInView:weakSelf.view];
                                   
                                   if (kHXSNoError != code) {
                                       [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                          status:message
                                                                      afterDelay:1.5f];
                                       
                                       return ;
                                   }
                                   
                                   [weakSelf displaySelectPayTypeView:payArr order:order];
                                   
                               }];

}
// 查看参与详情
- (void)operateViewCheckDetailOfParticipateButtonClicked:(HXSMyOrder *)order
{
    __weak typeof(self) weakSelf = self;
    [self fetchOrderDetialWithOrderID:order.orderDetailInfo.orderIdStr
                         afterOperate:^(HXSMyOrder *myOrder) {
                             BEGIN_MAIN_THREAD
                             NSString *joinUrl = [myOrder.extInfoDic objectForKey:@"one_dollor_link"];
                             
                             if(joinUrl && [joinUrl isKindOfClass:[NSString class]] && joinUrl.length > 0) {
                                 [weakSelf pushToVCWithLink:joinUrl];
                             }
                             END_MAIN_THREAD
                         }];
}
// 查看约团详情
- (void)operateViewCheckDetailOfGroupButtonClicked:(HXSMyOrder *)order
{
    __weak typeof(self) weakSelf = self;
    [self fetchOrderDetialWithOrderID:order.orderDetailInfo.orderIdStr
                         afterOperate:^(HXSMyOrder *myOrder) {
                             BEGIN_MAIN_THREAD
                             NSString *groupUrl = [myOrder.extInfoDic objectForKey:@"group_link"];
                             
                             if(groupUrl && [groupUrl isKindOfClass:[NSString class]] && groupUrl.length > 0) {
                                 [weakSelf pushToVCWithLink:groupUrl];
                             }
                             END_MAIN_THREAD
                         }];
}
// 评价得10积分按钮点击
- (void)operateViewEvaluationButtonClicked:(HXSMyOrder *)order
{
    HXSOrderAppraiseViewController *orderAppraiseViewController = [HXSOrderAppraiseViewController controllerWithShopInfo:order.shopInfo orderId:order.orderDetailInfo.orderIdStr];
    orderAppraiseViewController.delegate = self;
    
    [self.navigationController pushViewController:orderAppraiseViewController animated:YES];
}

// 邀请好友约团
- (void)operateViewJoinGroupButtonClicked:(HXSMyOrder *)order
{
    __weak typeof(self) weakSelf = self;
    [self fetchOrderDetialWithOrderID:order.orderDetailInfo.orderIdStr
                         afterOperate:^(HXSMyOrder *myOrder) {
                             BEGIN_MAIN_THREAD
                             [weakSelf showShareViewWithOrder:myOrder];
                             END_MAIN_THREAD
                         }];
}


#pragma mark - HXSOrderAppraiseViewControllerDelegate

// 评价成功
- (void)appraiseSuccess
{
    [self refreshData:self.tempOrder];
}

#pragma mark - HXSOrderDetialViewControllerDelegate

- (void)orderStatusChange
{
    if (nil != self.orderDetialStatusChange) {
        self.orderDetialStatusChange();
    }
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataMarr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HXSMyOrder *myOrder = [self.dataMarr objectAtIndex:section];
    
    // 店铺介绍 + 商品个数 + 折扣信息 + 操作类型（如果有的话）
    return myOrder.viewButtonArr.count > 0 ? myOrder.orderItemsArr.count + 3 : myOrder.orderItemsArr.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSMyOrder *myOrder = [self.dataMarr objectAtIndex:indexPath.section];
    OrderListViewCellType cellType = [self cellTypeWithOrder:myOrder row:indexPath.row];
    
    if (orderListViewCellTypeOrderHeader == cellType) {
        
        HXShopNameAndOrderStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXShopNameAndOrderStatusCell class])];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.separatorInset = UIEdgeInsetsMake(0, KOtherCellSeparatorInset, 0, 0);
        cell.myOrder = myOrder;
        
        return cell;
        
    } else if (orderListViewCellTypeOrderFooter == cellType) {
        
        HXSOrderBillCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSOrderBillCell class])];
        
        cell.separatorInset = UIEdgeInsetsMake(0, KOtherCellSeparatorInset, 0, 0);
        cell.myOrder = myOrder;
        
        return  cell;
        
    } else if (orderListViewCellTypeOrderOperate == cellType) {
        
        HXSOrderListOperateCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSOrderListOperateCell class])];
        
        cell.myOrder = myOrder;
        cell.delegate = self;
        
        return  cell;
        
    } else {
        
        HXSGoodsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSGoodsInfoCell class])];
        
        HXSMyOrderItem *item = [myOrder.orderItemsArr objectAtIndex:indexPath.row - 1];
        cell.myOrderItem = item;
        
        if(indexPath.row >= myOrder.orderItemsArr.count) {
             cell.separatorInset = UIEdgeInsetsMake(0, KOtherCellSeparatorInset, 0, 0);
        } else {
            cell.separatorInset = UIEdgeInsetsMake(0, kHXSGoodsInfoCellSeparatorInset, 0, 0);
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSMyOrder *myOrder = [self.dataMarr objectAtIndex:indexPath.section];
    OrderListViewCellType cellType = [self cellTypeWithOrder:myOrder row:indexPath.row];
    if (orderListViewCellTypeOrderHeader == cellType) {
        
        return  kHXShopNameAndOrderStatusCellHeight;
        
    } else if (orderListViewCellTypeOrderFooter == cellType) {
        
        return  kHXSOrderBillCellHeight;
        
    } else if (orderListViewCellTypeOrderOperate == cellType) {
        
        return  kHXSOrderOperateCellHeight;
        
    } else {
        
        return kHXSGoodsInfoCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTableViewSectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kTableViewSectionFooterHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSMyOrder *myOrder = [self.dataMarr objectAtIndex:indexPath.section];
    
    HXSOrderDetialViewController *orderDetialViewController = [HXSOrderDetialViewController controllerWithMyOrder:myOrder.orderDetailInfo.orderIdStr];
    orderDetialViewController.delegate = self;
    [self.navigationController pushViewController:orderDetialViewController animated:YES];
 
}

#pragma mark - Puch To LinkStr VCs

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


#pragma mark - Fetch Order Detail & Operate Block

- (void)fetchOrderDetialWithOrderID:(NSString *)orderIdStr afterOperate:(void (^)(HXSMyOrder *myOrder))block
{
    WS(weakSelf);
    
    [HXSLoadingView showLoadingInView:self.view];
    
    [HXSOrderViewModel fecthOrderDetialWithOrderId:orderIdStr
                                          complete:^(HXSErrorCode status, NSString *message, HXSMyOrder *myOrder) {
                                              
                                              [HXSLoadingView closeInView:weakSelf.view];
                                              
                                              if (kHXSNoError == status) {
                                                  if (nil != block) {
                                                      block(myOrder);
                                                  }
                                              } else {
                                                  [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                              }
                                          }];
}

- (void)showShareViewWithOrder:(HXSMyOrder *)myOrder
{
    HXSShareParameter *parameter = [[HXSShareParameter alloc] init];
    parameter.shareTypeArr = @[@(kHXSShareTypeQQMoments), @(kHXSShareTypeWechatFriends),
                               @(kHXSShareTypeQQFriends), @(kHXSShareTypeWechatMoments),@(kHXSShareTypeCopyLink)];
    
    HXSShareView *shareView = [[HXSShareView alloc] initShareViewWithParameter:parameter
                                                                      callBack:^(HXSShareResult shareResult, NSString *msg)
                               {
                                   [MBProgressHUD showInViewWithoutIndicator:self.view
                                                                      status:msg
                                                                  afterDelay:1.5];
                               }];
    
    
    HXSMyOrderItem *orderItem = [myOrder.orderItemsArr firstObject];
    NSString *missingNumStr = [myOrder.extInfoDic objectForKey:@"group_diff_num"];
    if (nil == missingNumStr) {
        missingNumStr = @"1";
    }
    
    shareView.shareParameter.titleStr    = [NSString stringWithFormat:@"还差%@人！我买了%@", missingNumStr, orderItem.nameStr];
    shareView.shareParameter.textStr     = @"今天在传说中特靠谱的59约团中发现了一件超值好货，吃瓜群众们都抢疯啦~";
    shareView.shareParameter.imageURLStr = orderItem.imgStr;
    NSString *groupUrl = [myOrder.extInfoDic objectForKey:@"group_link"];
    shareView.shareParameter.shareURLStr = groupUrl;
    [shareView show];
}


#pragma mark - Getter

- (UIView *)noDataFooterView
{
    if(!_noDataFooterView) {
        _noDataFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 70)/2, 77, 70,78)];
        [imageView setImage:[UIImage imageNamed:@"img_anonymous"]];
        [_noDataFooterView addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 179, SCREEN_WIDTH, 21)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = @"暂时还没有订单哦";
        lable.textColor = HXS_TABBAR_ITEM_TEXT_COLOR_NORMAL;
        [lable setFont:[UIFont systemFontOfSize:14]];
        [_noDataFooterView addSubview:lable];
    }
    return _noDataFooterView;
}


@end
