//
//  HXSPrintCheckoutViewController.m
//  store
//
//  Created by 格格 on 16/3/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintCheckoutViewController.h"

// Controllers
#import "HXSDeliveryInfoViewController.h"
#import "HXSDormEditRemarksViewController.h"
#import "HXSLoginViewController.h"
#import "HXSPrintShoppingAddressVC.h"
#import "HXStoreDocumentLibraryPaymentViewController.h"
#import "HXSPaymentOrderViewController.h"
#import "HXSCouponViewController.h"

// Model
#import "HXSSettingsManager.h"
#import "HXSPrintCartEntity.h"
#import "HXSMyPrintOrderItem.h"
#import "HXSCoupon.h"
#import "HXSPrintModel.h"
#import "HXSPrintCouponValidate.h"
#import "HXSDeliveryEntity.h"
#import "HXSBuildingArea.h"
#import "HXSPrintCheckoutViewModel.h"

// Views
#import "HXSActionSheet.h"
#import "HXSPhoneIdentificationAndLoginView.h"
#import "HXSPrintCheckoutInputCell.h"
#import "HXSPrintMyOderTableViewCell.h"
#import "HXSPrintCheckOutWelfarePaperCell.h"
#import "HXSPrintCheckoutShopInfoCell.h"
#import "HXSPrintCheckoutAddrssTableViewCell.h"

//others
#import "HXSPrintHeaderImport.h"
#import "HXSAddressEntity.h"
#import "HXSSite.h"

typedef NS_ENUM(NSUInteger,HXSSectionType) {
    HXSSectionTypeUserInfo                  = 0,  // 用户信息
    HXSSectionTypeGoodsInfo                 = 1,  // 商品信息
    HXSSectionTypeWelfarePaper              = 2,  // 福利纸信息
    HXSSectionTypeCoupon                    = 3,  // 优惠券信息
    HXSSectionTypeDelivery                  = 4,  // 配送信息
    HXSSectionTypeRemark                    = 5   // 留言
};



static NSString *HXSPrintCheckoutInputCellIdentify      = @"HXSPrintCheckoutInputCell";
static NSString *HXSPrintOderTableViewCellIdentify       = @"HXSPrintMyOderTableViewCell";
static NSString *HXSPrintCheckoutSupplementCellIdentify = @"HXSPrintCheckoutShopInfoCell";

// 打印店 埋点
static NSString * const kUsageEventPrintConfirmCheckOut         = @"print_confirm_check_out";
static NSString * const kUsageEventPrintConfirmCheckOutSuc      = @"print_confirm_check_out_suc";
static NSString * const kUsageEventPrintConfirmCheckOutFail     = @"print_confirm_check_out_fail";

static NSInteger COUPON_POPOVER_TAG      = 100;
static NSInteger VERIFY_CODE_POPOVER_TAG = 101;

@interface HXSPrintCheckoutViewController ()<HXSCouponViewControllerDelegate,
                                             HXSDeliveryInfoViewControllerDelegate,
                                             HXSPrintCheckOutWelfarePaperCellDelegate,
                                             HXSPrintShoppingAddressVCDelegate>


@property(nonatomic,weak) IBOutlet UITableView                  *tableView;
@property(nonatomic,weak) IBOutlet UILabel                      *totalPagesLabel;
@property(weak, nonatomic) IBOutlet UILabel                     *actualAmoutLabel;
/**是否使用福利纸*/
@property(assign,nonatomic) BOOL                                ifUseWelfarePaper;
/**优惠券 */
@property (nonatomic, strong) HXSCoupon                         *coupon;
@property (nonatomic, strong) NSString                          *verifyCode;
@property (nonatomic, assign) HXSOrderPayType                   payType;
@property (nonatomic, strong) HXSPrintOrderInfo                 *printOrderInfo;
@property (nonatomic, strong) HXSDeliveryEntity                 *selectDeliveryEntity;
@property (nonatomic, strong) HXSDeliveryTime                   *selectDeliveryTime;
@property (nonatomic, strong) HXSDeliveryInfoViewController     *deliveryInfoVC;
@property (nonatomic, strong) HXSPrintCouponValidate            *validate;
/**购物车entity*/
@property (nonatomic, strong) HXSPrintCartEntity                *printCartEntity;
/***店铺entity*/
@property (nonatomic, strong) HXSShopEntity                     *shopEntity;
@property (nonatomic, strong) NSArray                           *sectionArray;
@property (nonatomic, strong) HXSPrintShoppingAddress           *shoppingAddress;
@property (nonatomic, assign) BOOL                              inScope;
@property (nonatomic, strong) HXSPrintCheckoutViewModel         *checkOutViewModel;
@property (nonatomic, strong) HXSActionSheet                    *couponSheet;

@end

@implementation HXSPrintCheckoutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigation];
    
    [self initialAttribute];
    
    [self initialTableView];
    
    [self refreshPrintCarEntityIsNeedToShowNoWalfareMessage:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{
    [[HXSSettingsManager sharedInstance] setRemarks:@""];
    
    self.printCartEntity      = nil;
    self.coupon         = nil;
    self.verifyCode     = nil;
    self.printOrderInfo = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshActualAmoutUI];
    [self.tableView reloadData];
}


#pragma mark - Override Methods

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - initialMethod

- (void)initialNavigation
{
    self.navigationItem.title = @"确认订单";
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initialAttribute
{
    self.ifUseWelfarePaper = NO; // 福利纸默认关闭状态
}

- (void)initPrintCheckoutViewControllerWithEntity:(HXSPrintCartEntity *)entity
                                andWithShopEntity:(HXSShopEntity *)shopEntity
{
    _printCartEntity = entity;
    _shopEntity      = shopEntity;
    
    BOOL isWhiteBlackPrintForDoc = [self.checkOutViewModel checkPrintListHasBlackWhitePrint:_printCartEntity.itemsArray];//有黑白打印文档
    
    if(_printCartEntity.docTypeNum.intValue == HXSPrintDocumentTypePicture
       || (_printCartEntity.docTypeNum.intValue == HXSPrintDocumentTypeOther
           && !isWhiteBlackPrintForDoc)) {
        _sectionArray = @[@(HXSSectionTypeUserInfo)
                          ,@(HXSSectionTypeGoodsInfo)
                          ,@(HXSSectionTypeCoupon)
                          ,@(HXSSectionTypeDelivery)
                          ,@(HXSSectionTypeRemark)];
    } else {
        _sectionArray = @[@(HXSSectionTypeUserInfo)
                          ,@(HXSSectionTypeGoodsInfo)
                          ,@(HXSSectionTypeWelfarePaper)
                          ,@(HXSSectionTypeCoupon)
                          ,@(HXSSectionTypeDelivery)
                          ,@(HXSSectionTypeRemark)];
    
    }
}

- (void)initialTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.separatorColor = [UIColor colorWithRGBHex:0xE5E6E7];
    _tableView.backgroundColor = [UIColor colorWithRGBHex:0xF5F6F7];
    _tableView.showsVerticalScrollIndicator = NO;
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"HXStorePrint" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    [_tableView registerNib:[UINib nibWithNibName:@"HXSPrintCheckoutInputCell" bundle:bundle] forCellReuseIdentifier:HXSPrintCheckoutInputCellIdentify];
    [_tableView registerNib:[UINib nibWithNibName:@"HXSPrintMyOderTableViewCell" bundle:bundle] forCellReuseIdentifier:HXSPrintOderTableViewCellIdentify];
    [_tableView registerNib:[UINib nibWithNibName:@"HXSPrintCheckoutShopInfoCell" bundle:bundle] forCellReuseIdentifier:HXSPrintCheckoutSupplementCellIdentify];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSPrintCheckOutWelfarePaperCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([HXSPrintCheckOutWelfarePaperCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSPrintCheckoutAddrssTableViewCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([HXSPrintCheckoutAddrssTableViewCell class])];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSNumber *num = [_sectionArray objectAtIndex:section];
    switch (num.integerValue) {
        case HXSSectionTypeUserInfo:
            return 1;
            break;
        case HXSSectionTypeGoodsInfo:
            return [self.printCartEntity.itemsArray count] + 1;//+1 为店铺名称
            break;
        case HXSSectionTypeWelfarePaper:
            return 1;
            break;
        case HXSSectionTypeCoupon:
            return 1;
            break;
        case HXSSectionTypeDelivery:
            return 1;
            break;
        case HXSSectionTypeRemark:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *num = [_sectionArray objectAtIndex:indexPath.section];
    if((num.integerValue == HXSSectionTypeGoodsInfo
        && indexPath.row > 0)
       || num.integerValue == HXSSectionTypeUserInfo) {
        return 80;
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSNumber *num = [_sectionArray objectAtIndex:section];
    
    if(num.integerValue == HXSSectionTypeUserInfo) {
        return 0.1;
    }
    else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.1;
    
    NSNumber *num = [_sectionArray objectAtIndex:section];
    
    if(num.integerValue == HXSSectionTypeRemark) {
        return 65.0;
    }
    
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *num = [_sectionArray objectAtIndex:indexPath.section];
    if(HXSSectionTypeUserInfo == num.integerValue){ // 收货地址
        HXSPrintCheckoutAddrssTableViewCell *addressCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSPrintCheckoutAddrssTableViewCell class])];
        
        [addressCell initCheckoutAddrssTableViewCellWithAdress:_shoppingAddress];
        
        return addressCell;
    } else if(HXSSectionTypeGoodsInfo == num.integerValue) { // 打印列表
        
        if(indexPath.row == 0) {
            HXSPrintCheckoutShopInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSPrintCheckoutSupplementCellIdentify];
            [cell initPrintCheckoutShopInfoCellWithEntity:_shopEntity];
            
            return cell;
        }
        
        HXSPrintMyOderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSPrintOderTableViewCellIdentify];
        HXSMyPrintOrderItem *item = self.printCartEntity.itemsArray[indexPath.row - 1];
        cell.printItem = item;
        
        return cell;
        
    } else if (HXSSectionTypeWelfarePaper == num.integerValue) { // 福利纸
        
        HXSPrintCheckOutWelfarePaperCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSPrintCheckOutWelfarePaperCell class])];
        
        [cell initPrintCheckOutWelfarePaperCellWithPrintCartEntity:_printCartEntity
                                              andIfUseWelfarePaper:_ifUseWelfarePaper];
        cell.delegate = self;
        
        return cell;
        
    } else if (HXSSectionTypeCoupon == num.integerValue) { // 优惠券
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = @"优惠券";
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.textLabel.textColor = [UIColor colorWithRGBHex:0x666666];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
        
        if (![HXSUserAccount currentAccount].isLogin) {
            [cell.detailTextLabel setText:@"登录后显示"];
            cell.detailTextLabel.textColor = HXS_PROMPT_TEXT_COLOR;
        } else {
            if([self.printCartEntity.couponDiscountDoubleNum floatValue] > 0) {
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"-￥%.2f", self.printCartEntity.couponDiscountDoubleNum.floatValue]];
                cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0xF9A502];
            } else {
                if(self.printCartEntity.couponHadNum.integerValue == 0) {
                    [cell.detailTextLabel setText:@"无可用优惠券"];
                    cell.detailTextLabel.textColor = HXS_PROMPT_TEXT_COLOR;
                } else {
                    [cell.detailTextLabel setText:@"有可用优惠券"];
                    cell.detailTextLabel.textColor = HXS_SPECIAL_COLOR;
                }
            }
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else if (HXSSectionTypeDelivery == num.integerValue) { // 配送信息
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = @"配送信息";
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.textLabel.textColor = [UIColor colorWithRGBHex:0x666666];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if(self.printCartEntity.sendTypeIntNum) {
            if(HXSPrintDeliveryTypeShopOwner == self.printCartEntity.sendTypeIntNum.doubleValue
               && self.printCartEntity.deliveryAmountDoubleNum) {
                if(self.printCartEntity.deliveryAmountDoubleNum.doubleValue <= 0.00) {
                    cell.detailTextLabel.text = @"店长配送：免费配送";
                    cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0x666666];
                } else {
                    NSString *str = [NSString stringWithFormat:@"店长配送：￥%.2f",self.printCartEntity.deliveryAmountDoubleNum.doubleValue];
                    NSString *subStr = [NSString stringWithFormat:@"￥%.2f",self.printCartEntity.deliveryAmountDoubleNum.doubleValue];
                    
                    NSMutableAttributedString *showStr = [[NSMutableAttributedString alloc]initWithString:str];
                    [showStr addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor colorWithRGBHex:0xF9A502]
                                    range:[str rangeOfString:subStr]];
                    
                    cell.detailTextLabel.attributedText = showStr;
                }
            } else if(HXSPrintDeliveryTypeSelf == self.printCartEntity.sendTypeIntNum.doubleValue) {
                cell.detailTextLabel.text = @"上门自取";
                cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            }
        } else {
            cell.detailTextLabel.text = @"";
        }
        return cell;
    } else if(HXSSectionTypeRemark == num.integerValue) {  // 留言
        UITableViewCell *messageCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        messageCell.textLabel.text = @"留言";
        messageCell.textLabel.font = [UIFont systemFontOfSize:14.0];
        messageCell.textLabel.textColor = [UIColor colorWithRGBHex:0x666666];
        messageCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        messageCell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
        messageCell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0xCCCCCC];
        
        NSString * remarks = [[HXSSettingsManager sharedInstance] getRemarks];
        if(remarks.length > 0) {
            messageCell.detailTextLabel.text = remarks;
            messageCell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0x666666];
        } else {
            messageCell.detailTextLabel.text = @"给店主留言(选填)";
            messageCell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0xCCCCCC];
        }
        
        return messageCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSNumber *num = [_sectionArray objectAtIndex:indexPath.section];
    if(HXSSectionTypeCoupon == num.integerValue) {
        if(![HXSUserAccount currentAccount].isLogin) { // 用户未登录，登录后匹配自动匹配优惠券
            [HXSLoginViewController showLoginController:self loginCompletion:^{
                [self refreshPrintCarEntityIsNeedToShowNoWalfareMessage:NO];
            }];
        } else {
            [self displayCouponSelectionActionSheet];
        }
        
    } else if(HXSSectionTypeDelivery == num.integerValue) { // 配送信息
        if(_selectDeliveryEntity) {
            [self.deliveryInfoVC setSelectDeliveryEntity:_selectDeliveryEntity
                                      selectDeliveryTime:_selectDeliveryTime];
        }
        
        [self.navigationController pushViewController:self.deliveryInfoVC animated:YES];
        
    } else if(HXSSectionTypeRemark == num.integerValue) { // 留言
        HXSDormEditRemarksViewController *remarksController = [HXSDormEditRemarksViewController controllerFromXibWithModuleName:@"HXStoreBase"];
        [self.navigationController pushViewController:remarksController animated:YES];
    } else if(HXSSectionTypeUserInfo == num.integerValue) { // 收货地址
        if(![HXSUserAccount currentAccount].isLogin) {
            [HXSLoginViewController showLoginController:self loginCompletion:^{
                HXSPrintShoppingAddressVC *addressVC = [HXSPrintShoppingAddressVC controllerFromXibWithModuleName:@"HXStorePrint"];
                addressVC.delegate = self;
                [self.navigationController pushViewController:addressVC animated:YES];
            }];
        } else {
            HXSPrintShoppingAddressVC *addressVC = [HXSPrintShoppingAddressVC controllerFromXibWithModuleName:@"HXStorePrint"];
            addressVC.delegate = self;
            [self.navigationController pushViewController:addressVC animated:YES];
        }
    }
    
}


#pragma mark - Networking

// 刷新购物车订单价格
- (void)refreshPrintCarEntityIsNeedToShowNoWalfareMessage:(BOOL)isNeedToShow
{
    [MBProgressHUD showInView:self.view];
    __weak typeof(self) weakSelf = self;
    
    NSNumber *openAdNum;
    if(self.printCartEntity.docTypeNum.intValue == HXSPrintDocumentTypePicture) {
        openAdNum = @(0);
    } else {
        openAdNum = self.ifUseWelfarePaper ? @(1) : @(0);
    }
    
    [HXSPrintModel createOrCalculatePrintOrderWithPrintCartEntity:_printCartEntity
                                                           shopId:_shopEntity.shopIDIntNum
                                                           openAd:openAdNum
                                                         complete:^(HXSErrorCode code, NSString *message, HXSPrintCartEntity *printCartEntity)
    {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if(kHXSNoError == code) {
            weakSelf.printCartEntity = printCartEntity;
            
            [weakSelf refreshActualAmoutUI];
            [weakSelf refreshHasSelectedPayType];
            
            [weakSelf checkCurrentStatusAndSetCoupcode];
            
            [weakSelf.tableView reloadData];
            
            if([printCartEntity.adPageNumIntNum isEqualToNumber:@(0)]) {
                // 福利纸已经用完
                weakSelf.ifUseWelfarePaper = NO;
                [weakSelf.printCartEntity setAdPageNumIntNum:@(0)];
                weakSelf.printCartEntity.openAdIntNum = @(0);
                [weakSelf.tableView reloadData];
                if([weakSelf.printCartEntity.docTypeNum isEqualToNumber:@(1)]
                   && isNeedToShow) {//需要弹框无福利纸提醒
                    [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                       status:@"免费资源已被抢光啦~"
                                                   afterDelay:1.5f];
                }
            }
            
        } else {
            [weakSelf checkCurrentStatusAndSetCoupcode];
            [weakSelf.tableView reloadData];
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:message
                                           afterDelay:1.5f];
        }
        if ([HXSUserAccount currentAccount].isLogin) {
            [weakSelf fetchAddressNetworking];
        }
    }];
}

/**
 *  获取地址
 */
- (void)fetchAddressNetworking
{
    [MBProgressHUD showInView:self.view];
    __weak typeof(self) weakSelf = self;
    [HXSPrintModel fetchShoppingAddressComplete:^(HXSErrorCode code, NSString *message, NSArray *shoppingAddressArr)
    {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        if(shoppingAddressArr
           && shoppingAddressArr.count > 0)
        {
            weakSelf.shoppingAddress = [shoppingAddressArr firstObject];
            [weakSelf.tableView reloadData];
        } else if(shoppingAddressArr
                  && shoppingAddressArr.count == 0){
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:@"请选择收货地址"
                                           afterDelay:1.5f];
        }
        else if(kHXSNoError != code) {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:message
                                           afterDelay:1.5f];
            
        }
    }];
}

#pragma mark - 选择优惠券

/**
 *  选择优惠券
 */
-(void)displayCouponSelectionActionSheet
{
    if([_printCartEntity.couponDiscountDoubleNum floatValue] > 0) {
        [self.couponSheet show];
    } else {
        if(_printCartEntity.couponHadNum.integerValue == 0) {
            return;
        } else {
            [self.couponSheet show];
        }
    }
}

/**
 *  跳转到选择优惠券界面
 */
- (void)jumpToCouponSelectionController
{
    HXSCouponViewController *couponController = [HXSCouponViewController controllerFromXibWithModuleName:@"Coupon"];
    couponController.delegate = self;
    couponController.couponScope = kHXSCouponScopePrint;
    [self.navigationController pushViewController:couponController animated:YES];
}


#pragma mark - refresh UI

// 刷新总价格显示
- (void)refreshActualAmoutUI
{
    //  订单合计
    _actualAmoutLabel.text = [NSString stringWithFormat:@"￥%0.2f", [_printCartEntity.totalAmountDoubleNum floatValue]];
    // 共打印页数
    if(self.printCartEntity.docTypeNum.integerValue == HXSPrintDocumentTypeOther)
        _totalPagesLabel.text = [NSString stringWithFormat:@"%d页",[_printCartEntity.printPagesIntNum intValue]];
    else if(self.printCartEntity.docTypeNum.integerValue == HXSPrintDocumentTypePicture)
        _totalPagesLabel.text = [NSString stringWithFormat:@"%d张",[_printCartEntity.printPagesIntNum intValue]];
}

// 修改福利纸状态
-(void)refreshHasSelectedPayType
{
    // 打开福利纸但后台返回的是未打开，修改本地状态和显示
    if(self.ifUseWelfarePaper
       && self.printCartEntity.openAdIntNum.intValue == 0) {
        self.ifUseWelfarePaper = NO;
        [MBProgressHUD showInViewWithoutIndicator:self.view
                                           status:@"免费资源已被抢光啦~"
                                       afterDelay:1];
    }
}


#pragma mark - HXSPrintCheckOutWelfarePaperCellDelegate

- (void)welfarePaperSwitchChange:(UISwitch *)sender
{
    self.ifUseWelfarePaper = sender.on;
    
    [self refreshPrintCarEntityIsNeedToShowNoWalfareMessage:YES];
}


#pragma mark - Target/Action

- (void)showCouponInputPopover
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"请输入优惠券券号"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textfield=[alertView textFieldAtIndex:0];
    textfield.keyboardType = UIKeyboardTypeNamePhonePad;
    alertView.tag = COUPON_POPOVER_TAG;
    [alertView show];
}

/**
 *  点击立即支付
 *
 *  @param sender
 */
- (IBAction)payButtonPressed:(id)sender
{
    [HXSUsageManager trackEvent:kUsageEventPrintConfirmCheckOut parameter:nil];
                __weak typeof(self) weakSelf = self;
    if(![HXSUserAccount currentAccount].isLogin) {
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            if (!_shoppingAddress) {
                [weakSelf refreshPrintCarEntityIsNeedToShowNoWalfareMessage:NO];
            } else {
                [weakSelf checkAddressInTheScope];
            }
        }];
    } else {
        if (!_shoppingAddress) {
            [self refreshPrintCarEntityIsNeedToShowNoWalfareMessage:NO];
        } else {
            [self checkAddressInTheScope];
        }
    }
    
}

/**
 *  创建打印订单
 */
- (void)createPrintOrder
{    
    if(nil == self.selectDeliveryEntity
       && !self.printCartEntity.sendTypeIntNum){
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"请选择配送信息" afterDelay:1.0f];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    HXSLocationManager *manager = [HXSLocationManager manager];
    [MBProgressHUD showInView:self.view];
    [HXSPrintModel fetchShopInfoWithSiteId:manager.currentSite.site_id
                                  shopType:[NSNumber numberWithInteger:kHXSShopTypePrint]
                               dormentryId:manager.buildingEntry.dormentryIDNum
                                    shopId:_shopEntity.shopIDIntNum
                                  complete:^(HXSErrorCode status, NSString *message, HXSShopEntity *shopEntity)
     {
         [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
         
         if (kHXSNoError != status) {
             [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                status:message
                                            afterDelay:1.5];
             
             return ;
         }
         
         weakSelf.shopEntity = shopEntity;
         
         [HXSShopManager shareManager].currentEntry.shopEntity = shopEntity;
         
         if ([shopEntity.statusIntNum integerValue] == kHXSShopStatusClosed) {
             [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                status:@"店铺休息中，请稍后再试"
                                            afterDelay:1.5];
             
             return ;
         }
         
         [weakSelf fetchingPrintOrderNetworking];
     }];

}

/**
 *打印订单获取网络接口
 */
- (void)fetchingPrintOrderNetworking
{
    [MBProgressHUD showInView:self.view];
    
    __weak typeof(self) weakSelf = self;
    
    [HXSPrintModel createPrintOrderWithParamModel:[self createPrintOrderParamModel]
                                         complete:^(HXSErrorCode code, NSString *message, HXSPrintOrderInfo *orderInfo)
     {
         [HXSUsageManager trackEvent:kUsageEventPrintConfirmCheckOutSuc parameter:nil];
         [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
         
         if(kHXSNoError == code){
             [[HXSSettingsManager sharedInstance] setRemarks:@""];
             
             // save type of order
             [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:kHXSOrderTypePrint]
                                                       forKey:USER_DEFAULT_LATEST_ORDER_TYPE];
             [[NSUserDefaults standardUserDefaults] synchronize];
             weakSelf.printOrderInfo = orderInfo;
             
             if(orderInfo
                && orderInfo.statusIntNum.intValue == HXSPrintOrderStatusNotPay
                && orderInfo.paytypeIntNum.intValue != kHXSOrderPayTypeCash){ // 订单未支付且支付方式不为现金支付
                 
                 [weakSelf gotoPaymentViewControllerWithPrintOrderInfo:orderInfo];
                 
             } else {
                 [weakSelf openBalanceViewController:YES];
             }
             
             // Refresh cart info
             [weakSelf updatePrintStoreCartInfo];
         } else if(kHXSNeedVerifyCodeError == code) {
             [HXSUsageManager trackEvent:kUsageEventPrintConfirmCheckOutFail parameter:nil];
             
             UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
             alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
             alertView.tag = VERIFY_CODE_POPOVER_TAG;
             UITextField *textfield=[alertView textFieldAtIndex:0];
             textfield.keyboardType = UIKeyboardTypeNumberPad;
             [alertView show];
             
         }else{
             [HXSUsageManager trackEvent:kUsageEventPrintConfirmCheckOutFail parameter:nil];
             [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                status:message
                                            afterDelay:1.0];
             
             if ((code > kHXSCouponExpiredError)
                 && (code <= kHXSCouponError)) {
                 weakSelf.coupon = nil;
             }
         }
         
     }];
    self.verifyCode = nil;
}

- (void)openBalanceViewController:(BOOL)hasPaid
{
    NSNumber *paidFlag = hasPaid ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0];
    [self performSelector:@selector(delayedShowPrintBalanceViewController:)
               withObject:paidFlag
               afterDelay:0.5];
}

- (void)delayedShowPrintBalanceViewController:(NSNumber *)paidStatus
{
    WS(weakSelf);
    if (self.printOrderInfo) {
        [MBProgressHUD showInView:self.view];
        [HXSPrintModel getPrintOrderDetialWithOrderSn:self.printOrderInfo.orderSnLongNum
                                             complete:^(HXSErrorCode code, NSString *message, HXSPrintOrderInfo *printOrder) {
                                                 [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                 if (kHXSNoError == code) {
                                                 } else {
                                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                                                     message:message
                                                                                                    delegate:nil
                                                                                           cancelButtonTitle:@"确定"
                                                                                           otherButtonTitles:nil];
                                                     [alert show];
                                                 }
        }];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

/**
 *  检测收货地址是否在可送范围
 */
- (void)checkAddressInTheScope
{
    WS(weakSelf);
    [self.validate checkAddressInScope:self.shopEntity.shopIDIntNum
                                dormId:self.shoppingAddress.dormentryIdStr
                              compelte:^(HXSErrorCode code, NSString *message, BOOL inScope) {
                                  if(kHXSNoError == code
                                     && inScope) {
                                      
                                      weakSelf.inScope = inScope;
                                      [weakSelf createPrintOrder];
                                      
                                  } else if(kHXSNoError == code
                                            && !inScope) {
                                      [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                         status:@"当前收货地址不在该店配送范围内哦"
                                                                     afterDelay:1.5f];
                                      
                                  } else {
                                      
                                      [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                         status:message
                                                                     afterDelay:1.5f];
                                  }
                              }];
}


#pragma mark - HXSCouponViewControllerDelegate

- (void)didSelectCoupon:(HXSCoupon *)coupon
{
    self.printCartEntity.couponCodeStr = coupon.couponCode;
    [self refreshPrintCarEntityIsNeedToShowNoWalfareMessage:NO];
}


#pragma mark - HXSDeliveryInfoViewControllerDelegate

- (void)selectHXSDeliveryEntity:(HXSDeliveryEntity *)selectDeliveryEntity
                   deliveryTime:(HXSDeliveryTime *)selectDeliveryTime{
    
    self.selectDeliveryEntity = selectDeliveryEntity;
    self.selectDeliveryTime = selectDeliveryTime;
    self.printCartEntity.sendTypeIntNum = selectDeliveryEntity.sendTypeIntNum;
    self.printCartEntity.deliveryTypeIntNum = selectDeliveryTime?selectDeliveryTime.typeIntNum : nil;
    self.printCartEntity.expectStartTimeLongNum = selectDeliveryTime?selectDeliveryTime.expectStartTimeLongNum : nil;
    self.printCartEntity.expectEndTimeLongNum = selectDeliveryTime?selectDeliveryTime.expectEndTimeLongNum : nil;
    self.printCartEntity.expectTimeNameStr = selectDeliveryTime?selectDeliveryTime.nameStr : selectDeliveryEntity.pickTimeStr;
    
    [self refreshPrintCarEntityIsNeedToShowNoWalfareMessage:NO];

}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == COUPON_POPOVER_TAG
        && buttonIndex == 1) { // 优惠券手动输入
        UITextField *textfield = [alertView textFieldAtIndex:0];
        
        if(textfield.text.length > 0) {
            [MBProgressHUD showInView:self.view];
            NSString * couponCode = textfield.text;
            
            __weak typeof(self) weakSelf = self;
            HXSPrintCouponValidate *validateReq = [[HXSPrintCouponValidate alloc] init];
            [validateReq validateWithToken:[HXSUserAccount currentAccount].strToken
                                couponCode: couponCode
                                      type: kHXSCouponScopePrint
                                  complete:^(HXSErrorCode code, NSString *message, HXSCoupon *coupon) {
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                      
                                      if (code == kHXSNoError) {
                                          weakSelf.printCartEntity.couponCodeStr = coupon.couponCode;
                                          [weakSelf refreshPrintCarEntityIsNeedToShowNoWalfareMessage:NO];
                                      }
                                      else {
                                          [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:1.0];
                                      }
                                  }];
        }
    } else if (buttonIndex == 1 && alertView.tag == VERIFY_CODE_POPOVER_TAG) {
        UITextField *textfield=[alertView textFieldAtIndex:0];
        if(textfield.text.length < 6) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"验证码为6位,请再次输入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            alertView.tag = VERIFY_CODE_POPOVER_TAG;
            UITextField *textfield=[alertView textFieldAtIndex:0];
            textfield.keyboardType = UIKeyboardTypeNumberPad;
            [alertView show];
        } else {
            
            self.verifyCode = textfield.text;
            [self createPrintOrder];
        }
    }
}


#pragma mark - HXSPrintShoppingAddressVCDelegate

- (void)saveAddressFinishedWithAddress:(HXSPrintShoppingAddress *)shopAddress;
{
    [self fetchAddressNetworking];
}


#pragma mark -支付页面

/**
 *  跳转支付页面
 */
- (void)gotoPaymentViewControllerWithPrintOrderInfo:(HXSPrintOrderInfo *)orderInfo
{
//    HXSPaymentOrderViewController *paymentOrderViewController = [HXSPaymentOrderViewController createPaymentOrderVCWithOrderInfo:[[HXSOrderInfo alloc] initWithOrderInfo:self.printOrderInfo] installment:NO];
    HXSPrintPaymentType type;
    if([_printCartEntity.docTypeNum isEqualToNumber:@(1)]) {//文档
        type = HXSPrintPaymentTypeDocPrint;
    } else {
        type = HXSPrintPaymentTypePicPrint;
    }
    
    HXStoreDocumentLibraryPaymentViewController *payVC = [HXStoreDocumentLibraryPaymentViewController createPrintDocumentPaymentVCWithOrderInfo:[[HXSOrderInfo alloc] initWithOrderInfo:self.printOrderInfo] installment:NO
                                                                                                                                        andType:type];
    NSMutableArray *array = [_printCartEntity.itemsArray mutableCopy];
    payVC.cartArray = _printCartEntity.itemsArray;
    [self.checkOutViewModel checkLocalAndRefreshOrderItemFromLibStatus:payVC.cartArray];
    //购物车免费张数和实际一致
    if([orderInfo.isConsistentNum boolValue]) {
        [self replaceCurrentViewControllerWith:payVC animated:YES];
    } else {
        WS(weakSelf);
        [MBProgressHUD showInViewWithoutIndicator:self.view
                                           status:@"免费资源不够，支付金额有些出入"
                                       afterDelay:1.5
                             andWithCompleteBlock:^
        {
            [weakSelf replaceCurrentViewControllerWith:payVC
                                              animated:YES];
        }];
    }
}


#pragma mark - create print order paramModel

- (HXSPrintCheckOutOrderParam *)createPrintOrderParamModel
{
    NSString *remarks = [[HXSSettingsManager sharedInstance] getRemarks];
    NSString *shoppingAddress = [self.checkOutViewModel getShoppingAddressFromShoppingAddress:_shoppingAddress];
    NSString *shoppingName    = [self.checkOutViewModel getBuyNameFromShoppingAddress:_shoppingAddress];
    
    NSString *apiStr = @"";
    if(_printCartEntity.docTypeNum.intValue == HXSPrintDocumentTypePicture) {
        apiStr = HXS_ORDERPIC_PRINT_CREATEORDER;
    } else {
        apiStr = HXS_PRINT_CREATEORDER;
    }
    
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSPrintCheckOutOrderParam *paramModel = [[HXSPrintCheckOutOrderParam alloc]init];
    paramModel.apiStr = apiStr;
    paramModel.phoneStr = _shoppingAddress.contactPhoneStr;
    paramModel.addressStr = shoppingAddress;
    paramModel.remarkStr = remarks;
    paramModel.payTypeNum = [self.printCartEntity.totalAmountDoubleNum doubleValue] < 0.01 ? @(kHXSOrderPayTypeCash):@(kHXSOrderPayTypeZhifu);
    paramModel.dormentryIdNum = locationMgr.buildingEntry.dormentryIDNum;
    paramModel.shopIdNum = _printCartEntity.shopIdIntNum;
    paramModel.openAdNum = _ifUseWelfarePaper ? @(1):@(0);
    paramModel.printCartEntity = _printCartEntity;
    paramModel.buyNameStr = shoppingName;
    paramModel.cartFreeNum = _printCartEntity.adPageNumIntNum;
    
    return paramModel;
}


#pragma mark - check current coupcode

- (void)checkCurrentStatusAndSetCoupcode
{
    if(_printCartEntity.couponHadNum.integerValue == 0) {
        _printCartEntity.couponCodeStr = nil;
        _printCartEntity.couponDiscountDoubleNum = nil;
    }
}


#pragma mark - Private Method

- (void)updatePrintStoreCartInfo
{
    if(self.clearPrintStoreCart) {
        self.clearPrintStoreCart();
    }
}


#pragma mark - Getter Setter Methods

- (HXSPrintCouponValidate *)validate
{
    if (nil == _validate) {
        _validate = [[HXSPrintCouponValidate alloc] init];
    }
    
    return _validate;
}

- (HXSDeliveryInfoViewController *)deliveryInfoVC
{
    if(!_deliveryInfoVC) {
        _deliveryInfoVC = [HXSDeliveryInfoViewController controllerFromXibWithModuleName:@"HXStorePrint"];
        _deliveryInfoVC.shopIdStr = _shopEntity.shopIDIntNum;
        _deliveryInfoVC.delegate  = self;
    }
    
    return _deliveryInfoVC;
}

- (HXSPrintCheckoutViewModel *)checkOutViewModel
{
    if(nil == _checkOutViewModel) {
        _checkOutViewModel = [[HXSPrintCheckoutViewModel alloc]init];
    }
    
    return _checkOutViewModel;
}

- (HXSActionSheet *)couponSheet
{
    if(nil == _couponSheet) {
        
        __weak typeof(self) weakSelf = self;
        _couponSheet = [HXSActionSheet actionSheetWithMessage:@"选择优惠券的方式" cancelButtonTitle:@"取消"];
        
        HXSActionSheetEntity *myConponEntity = [[HXSActionSheetEntity alloc] init];
        myConponEntity.nameStr = @"从我的优惠券选择";
        HXSAction *selectAction = [HXSAction actionWithMethods:myConponEntity handler:^(HXSAction *action) {
            [weakSelf jumpToCouponSelectionController];
        }];
        
        HXSActionSheetEntity *inputConponEntity = [[HXSActionSheetEntity alloc] init];
        inputConponEntity.nameStr = @"手动输入券号";
        HXSAction *inputAction = [HXSAction actionWithMethods:inputConponEntity handler:^(HXSAction *action) {
            [weakSelf showCouponInputPopover];
        }];
        
        [_couponSheet addAction:selectAction];
        [_couponSheet addAction:inputAction];
    }
    
    return _couponSheet;
}

@end
