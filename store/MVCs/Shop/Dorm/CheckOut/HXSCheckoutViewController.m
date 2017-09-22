//
//  HXSCheckoutViewController.m
//  store
//
//  Created by chsasaw on 15/6/24.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSCheckoutViewController.h"

// Controllers
#import "HXSCouponViewController.h"
#import "HXSDormEditRemarksViewController.h"
#import "HXSPaymentOrderViewController.h"
#import "HXSLoginViewController.h"
#import "HXSShoppingAddressVC.h"

// Model
#import "HXSSettingsManager.h"
#import "HXSOrderRequest.h"
#import "HXSCouponValidate.h"
#import "HXSBaiHuaHuaPayModel.h"
#import "HXSShop.h"
#import "HXSDormEntry.h"
#import "HXSSite.h"
#import "HXSCreateOrderParams.h"
#import "HXSCoupon.h"
#import "HXSShoppingAddressViewModel.h"
#import "HXSDormCartManager.h"
#import "HXSShoppingAddress.h"

// Views
#import "HXSPayPasswordAlertView.h"
#import "HXSPhoneIdentificationAndLoginView.h"
#import "HXSCheckoutInputCell.h"
#import "HXSDormCheckoutFoodCell.h"
#import "HXSCustomPickerView.h"
#import "HXSDrinkCheckoutSupplementCell.h"
#import "HXSCheckOutNoticeView.h"
#import "HXSCheckoutAddrssTableViewCell.h"
#import "HXSNoneAddressTableViewCell.h"
#import "HXSShopListSectionHeaderView.h"
#import "HXSDormCheckoutShopNameView.h"

// Others
#import "HXSActionSheet.h"
#import "HXSShopManager.h"
#import "HXSBuildingArea.h"
#import "HXSMediator+OrderModule.h"


static NSString *HXSCheckoutInputCellIdentifier    = @"HXSCheckoutInputCell";
static NSString *HXSCheckoutFoodCellIdentifier     = @"HXSDormCheckoutFoodCell";

static NSString *ConsigneePrefix = @"收货人:";
static NSString *ShippingAddressPrefix = @"收货地址:";


static CGFloat addressLabelHeight = 23.0f;
static CGFloat cellNormalHeight = 80.0f;


typedef NS_ENUM(NSInteger, HXSCheckoutViewSection)
{
    kHXSCheckoutViewSectionAddress               = 0, // 收货地址
    kHXSCheckoutViewSectionProducts              = 1, // 商品
    kHXSCheckoutViewSectionPromotion             = 2, // 赠品活动
    kHXSCheckoutViewSectionCoupon                = 3, // 配送费 优惠券
    kHXSCheckoutViewSectionMessage               = 4, // 留言
    
    kHXSCheckoutViewSectionCount                 = 5, // sections number
};


@interface HXSCheckoutViewController ()<UIAlertViewDelegate,
                                        UITableViewDataSource,
                                        UITableViewDelegate,
                                        HXSCouponViewControllerDelegate,
                                        UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet UITableView * tableView;
@property (nonatomic, weak) IBOutlet UIView *blurView;

@property (nonatomic, weak) IBOutlet UILabel * totalLabel;
@property (nonatomic, weak) IBOutlet UIButton * checkoutBtn;

@property (nonatomic, strong) HXSOrderRequest * orderRequest;
@property (nonatomic, strong) HXSCouponValidate * validate;

@property (nonatomic, strong) HXSCoupon * coupon;

@property (nonatomic, strong) NSArray *cartItems;

@property (nonatomic, strong) NSArray *promotionItems;
@property (nonatomic, strong) HXSShoppingAddress *shoppingAddressModel;

@property (nonatomic, assign) double totalAmount; // the amount of order

@property (nonatomic, strong) NSString *verifyCode;

@property (nonatomic, assign) BOOL hasAddress;
@property (nonatomic, assign) BOOL inScope;

@property (nonatomic, assign) CGFloat addressCellHeight;



@end

@implementation HXSCheckoutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initialTableView];
    
    [self initialSubViews];
    
    [self initialBlurView];
    
    if ([HXSUserAccount currentAccount].isLogin) {
        // auto matching coupon
        [self autoMatchingCoupon];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self changeNavigationBarBackgroundColor:[UIColor colorWithRGBHex:navBarWhiteBgColorValue]
                        pushBackButItemImage:[UIImage imageNamed:@"fanhui"]
                     presentBackButItemImage:[UIImage imageNamed:@"xia"]
                                  titleColor:[UIColor colorWithRGBHex:navBarWhiteTitleVolorValue]];
    
    [self fetchShippingAddress];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self changeNavigationBarNormal];
}

- (void)dealloc
{
    [[HXSSettingsManager sharedInstance] setRemarks:@""];
    
    self.coupon              = nil;
    self.orderRequest        = nil;
    self.validate            = nil;
    self.cartItems           = nil;
    self.verifyCode          = nil;


}

#pragma mark - override

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
#pragma mark - Override Methods

- (void)back
{
    [HXSUsageManager trackEvent:kUsageEventCheckOutGoBack parameter:@{@"business_type":@"夜猫店"}];
    [self.navigationController popViewControllerAnimated:YES];

}


#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    self.navigationItem.title = @"确认订单";
}

- (void)initialTableView
{
    [self.tableView setBackgroundColor:UIColorFromRGB(0xF5F6FB)];
    
    self.tableView.layer.masksToBounds = NO;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionIndexColor = UIColorFromRGB(0xffffff);
    self.tableView.separatorColor = HXS_COLOR_SEPARATION_STRONG;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HXSCheckoutInputCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:HXSCheckoutInputCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"HXSDormCheckoutFoodCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:HXSCheckoutFoodCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSCheckoutAddrssTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSCheckoutAddrssTableViewCell class])];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSNoneAddressTableViewCell class])
                                               bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HXSNoneAddressTableViewCell class])];

    
}

- (void)initialSubViews
{
    [self.checkoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.checkoutBtn setTitleColor:[UIColor colorWithARGBHex:0x66FFFFFF] forState:UIControlStateDisabled];
}

- (void)initialBlurView
{
    HXSPromotionInfoModel *promotionInfoModel = [HXSDormCartManager sharedManager].promotionInfoModel;
    
    if((nil != self.coupon)
       && (nil != promotionInfoModel.couponCodeStr)
       && (0 < [promotionInfoModel.couponCodeStr length])) {
        if ([promotionInfoModel.itemAmountDecNum compare:@(0.001)] == NSOrderedDescending) {
            [self.totalLabel setText:[promotionInfoModel.itemAmountDecNum twoDecimalPlacesString]];
        } else {
            [self.totalLabel setText:[NSString stringWithFormat:@"¥0.00"]];
        }
        
    } else {
        self.coupon = nil;
        
        [self.totalLabel setText:[promotionInfoModel.itemAmountDecNum twoDecimalPlacesString]];
    }
    
    self.totalAmount = promotionInfoModel.itemAmountDecNum.doubleValue;
}


#pragma mark - Targets Methods

- (void)fetchShippingAddress
{
    WS(weakSelf);
    [HXSShoppingAddressViewModel fetchShoppingAddressComplete:^(HXSErrorCode code, NSString *message, NSArray<HXSShoppingAddress *> *shoppingAddressArr) {
        if(kHXSNoError == code) {
            if(shoppingAddressArr.count > 0) {
                weakSelf.hasAddress = YES;
                weakSelf.shoppingAddressModel = shoppingAddressArr.firstObject;

                NSString *detailAddressStr = [NSString stringWithFormat:@"%@%@%@%@%@",
                                              ShippingAddressPrefix,
                                              self.shoppingAddressModel.siteNameStr,
                                              self.shoppingAddressModel.dormentryZoneNameStr,
                                              self.shoppingAddressModel.dormentryNameStr,
                                              self.shoppingAddressModel.detailAddressStr];
                CGFloat padding = 45;
                CGSize size = [detailAddressStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - padding, 0)
                                                             options:NSStringDrawingTruncatesLastVisibleLine
                                                                    |NSStringDrawingUsesLineFragmentOrigin
                                                                    |NSStringDrawingUsesFontLeading
                                                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                             context:nil].size;
                
                weakSelf.addressCellHeight = ceilf(size.height);

                [weakSelf checkAddressInTheScope];
            } else {
                weakSelf.hasAddress = NO;
                [weakSelf updateCheckButtonStatus:NO];
            }
        } else {
            [MBProgressHUD showInView:weakSelf.view customView:nil status:message afterDelay:3];
            
            [weakSelf updateCheckButtonStatus:NO];
        }
    }];
}

- (void)checkAddressInTheScope
{
    WS(weakSelf);
    [self.validate checkAddressInScope:self.shopEntity.shopIDIntNum
                                dormId:self.shoppingAddressModel.dormentryIdStr
                              compelte:^(HXSErrorCode code, NSString *message, BOOL inScope) {
                                  if(kHXSNoError == code) {
                                      
                                      weakSelf.inScope = inScope;
                                      
                                      [weakSelf updateCheckButtonStatus:inScope];
                                      
                                      [weakSelf.tableView reloadData];
                                      
                                  } else {
                                      
                                      [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                         status:message
                                                                     afterDelay:3.0f];
                                  }
                              }];
}

- (void)updateCheckButtonStatus:(BOOL)enabled
{
    self.checkoutBtn.userInteractionEnabled = enabled;
    self.checkoutBtn.enabled = enabled;
}


- (IBAction)onClickCheckout:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    [button setEnabled:NO];
    
    [HXSUsageManager trackEvent:kUsageEventCheckoutPay parameter:@{@"business_type":@"夜猫店"}];
    
    [self checkout:nil];
    
    [button setEnabled:YES];
}

- (void)checkout:(NSString *)verification_code
{
    self.verifyCode = verification_code;
    
    [self payOrder];
}

/**
 *  创建订单
 */
- (void)payOrder
{
    WS(weakSelf);
    NSString * phone = [[HXSSettingsManager sharedInstance] getPhoneNum];
    NSString * room = [[HXSSettingsManager sharedInstance] getRoomNum];
    
    NSString * remarks = [[HXSSettingsManager sharedInstance] getRemarks];
    
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSShopManager *shopManager = [HXSShopManager shareManager];
    
    HXSCreateOrderParams *createOrderParams = [[HXSCreateOrderParams alloc] init];
    createOrderParams.dormentryIDIntNum     = locationMgr.buildingEntry.dormentryIDNum;
    createOrderParams.shopIDIntNum          = shopManager.currentEntry.shopEntity.shopIDIntNum;
    createOrderParams.dormitoryStr          = room;
    createOrderParams.phoneStr              = phone;
    createOrderParams.couponCodeStr         = self.coupon ? self.coupon.couponCode : nil;
    createOrderParams.verificationCodeStr   = self.verifyCode;
    createOrderParams.remarkStr             = remarks;
    createOrderParams.addressIdStr          = self.shoppingAddressModel.idStr;
    createOrderParams.itemsArr              = self.cartItems;
    
    [HXSLoadingView showLoadingInView:self.view];
    [self.orderRequest newDormOrderWithCreateOrderParams:createOrderParams
                                                compelte:^(HXSErrorCode code, NSString *message, HXSOrderInfo *orderInfo)
     {
         [HXSLoadingView closeInView:weakSelf.view];
         
         if(code == kHXSNoError) {
             [MobClick event:@"dorm_check_out_suc" attributes:@{@"msg1":message}];
             
             [[HXSSettingsManager sharedInstance] setRemarks:@""];
             
             // save type of order
             [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:kHXSOrderTypeDorm] forKey:USER_DEFAULT_LATEST_ORDER_TYPE];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             if(0.001 < [orderInfo.order_amount doubleValue]) {
                 //在线支付未支付
                 HXSPaymentOrderViewController *paymentOrderViewController = [HXSPaymentOrderViewController createPaymentOrderVCWithOrderInfo:orderInfo installment:NO];
                 
                 [weakSelf replaceCurrentViewControllerWith:paymentOrderViewController animated:YES];
             } else {
                 
                 if (nil != orderInfo) {
                     NSDictionary *dic = @{@"order_sn":orderInfo.order_sn};
                     UIViewController *vc = [[HXSMediator sharedInstance] HXSMediator_orderDetailViewControllerWithParams:dic];
                     
                     [weakSelf replaceCurrentViewControllerWith:vc animated:YES];
                 } else {
                     [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                 }
             }
             
             [[HXSDormCartManager sharedManager] clearCart];
         }else if(code == kHXSNeedVerifyCodeError) {
             
             UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
             alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
             alertView.tag = 101;
             UITextField *textfield=[alertView textFieldAtIndex:0];
             textfield.keyboardType = UIKeyboardTypeNumberPad;
             [alertView show];
         }else {
             [MobClick event:@"dorm_check_out_fail" attributes:@{@"msg1":message}];
             
             [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.0];
             
             if ((code > kHXSCouponExpiredError)
                 && (code <= kHXSCouponError)) {
                 weakSelf.coupon = nil;
                 
                 // refresh cart info, after refreshing will update the bottom view
                 [[HXSDormCartManager sharedManager] clearCart];
             }
         }
     }];
    
    self.verifyCode = nil;
}

- (void)onClickBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Coupon Methods

- (void)autoMatchingCoupon
{
    [self didSelectCoupon:nil];
}


#pragma mark - Check Out Coupon Methods

- (void)onClickSelectCouponBtn
{
    HXSCouponViewController * couponController = [HXSCouponViewController controllerFromXibWithModuleName:@"Coupon"];
    couponController.delegate = self;
    couponController.couponScope = kHXSCouponScopeDorm;
    [self.navigationController pushViewController:couponController animated:YES];
}

- (void)onClickInputCouponBtn
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入优惠券券号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textfield=[alertView textFieldAtIndex:0];
    textfield.keyboardType = UIKeyboardTypeNamePhonePad;
    alertView.tag = 103;
    [alertView show];
}

- (void)displayCheckOutView
{
    [HXSUsageManager trackEvent:kUsageEventChooseCouponFromMylist parameter:@{@"business_type":@"夜猫店"}];
    [self onClickSelectCouponBtn];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kHXSCheckoutViewSectionCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case kHXSCheckoutViewSectionAddress:
        {
            if(!self.hasAddress){
                return 0.1f;
            }
            
            if(!self.inScope) {
                return 40.0f;
            } else {
                return 0.1f;
            }
        }
            break;
            
        case kHXSCheckoutViewSectionProducts:
        {
            return 44.0f;
        }
            break;
            
        case kHXSCheckoutViewSectionPromotion:
        {
            if (0 < [self.promotionItems count]) {
                return 34;
            } else {
                return 0.1f;
            }
        }
            break;
            
        default:
        {
            return 0.1f;
        }
            break;
    }
    
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == kHXSCheckoutViewSectionAddress
       && indexPath.row == 0) {
        if(0 != self.addressCellHeight) {
            return self.addressCellHeight - addressLabelHeight + cellNormalHeight;
        }
        return cellNormalHeight;
    } else if (indexPath.section == kHXSCheckoutViewSectionProducts
               && indexPath.row < self.cartItems.count) {
        return cellNormalHeight;
    } else if (indexPath.section == kHXSCheckoutViewSectionPromotion
               && indexPath.row < self.promotionItems.count) {
        return cellNormalHeight;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ((section == kHXSCheckoutViewSectionPromotion)
        && (0 >= [self.promotionItems count])) {
        return 0.1f;
    }
    
    return 10.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == kHXSCheckoutViewSectionAddress) {
        return 1;
    } else if(section == kHXSCheckoutViewSectionProducts) {
        return [self.cartItems count];
    } else if(section == kHXSCheckoutViewSectionPromotion) {
        return [self.promotionItems count];
    } else if (section == kHXSCheckoutViewSectionCoupon) {
        return 2; // 配送费 优惠券
    } else {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == kHXSCheckoutViewSectionAddress)
    {
        if(self.inScope || !self.hasAddress) {
            return nil;
        } else {
            return [HXSCheckOutNoticeView checkOutNoticeView];
        }
    }
    
    if(section == kHXSCheckoutViewSectionProducts) {
        HXSDormCheckoutShopNameView *headerView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([HXSDormCheckoutShopNameView class]) owner:nil options:nil].firstObject;
        headerView.shopNameLabel.text = self.shopEntity.shopNameStr;
        return headerView;
    }
    
    if (section == kHXSCheckoutViewSectionPromotion) {
        if (0 < [self.promotionItems count]) {
            UIView *view = [[NSBundle mainBundle] loadNibNamed:@"HXSPromotionItemsTitleView" owner:nil options:nil][0];
            
            return view;
        }
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    UIImageView *indicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_direction_right_black"]];
    cell.accessoryView = indicatorImageView;
    cell.textLabel.textColor = [UIColor colorWithRGBHex:0x333333];
    cell.detailTextLabel.textColor = UIColorFromRGB(0x999999);
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
    
    if(indexPath.section == kHXSCheckoutViewSectionAddress) {
        
        if(self.hasAddress) {
            HXSCheckoutAddrssTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSCheckoutAddrssTableViewCell class]) forIndexPath:indexPath];
            
            cell.titleLabel.text = [ConsigneePrefix stringByAppendingString:self.shoppingAddressModel.contactNameStr];
            cell.phoneNumLabel.text = self.shoppingAddressModel.contactPhoneStr;
            cell.shippingAddressLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@",
                                             ShippingAddressPrefix,
                                             self.shoppingAddressModel.siteNameStr,
                                             self.shoppingAddressModel.dormentryZoneNameStr,
                                             self.shoppingAddressModel.dormentryNameStr,
                                             self.shoppingAddressModel.detailAddressStr];

            

            cell.addressHeightConstraint.constant = self.addressCellHeight;
            
            return cell;
        } else {
            
            HXSNoneAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSNoneAddressTableViewCell class])
                                                                                forIndexPath:indexPath];
            
            return cell;
        }
        
    } else if(indexPath.section == kHXSCheckoutViewSectionProducts) {
        if (indexPath.row < self.cartItems.count) {
            HXSDormCheckoutFoodCell * itemCell = [tableView dequeueReusableCellWithIdentifier:HXSCheckoutFoodCellIdentifier];
            itemCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(indexPath.row < self.cartItems.count) {
                HXSDormItem * item = [self.cartItems objectAtIndex:indexPath.row];
                itemCell.item = item;
            }
        
            if (indexPath.row == (self.cartItems.count - 1)) {
                itemCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            } else {
                itemCell.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
            }
            
            return itemCell;
        }
    } else if(indexPath.section == kHXSCheckoutViewSectionPromotion) {   //赠品活动
        HXSDormCheckoutFoodCell * itemCell = [tableView dequeueReusableCellWithIdentifier:HXSCheckoutFoodCellIdentifier];
        itemCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        HXSPromotionItemModel *item = [self.promotionItems objectAtIndex:indexPath.row];
        [itemCell setPromotionItems:item];
        
        if (indexPath.row == (self.promotionItems.count - 1)) {
            itemCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } else {
            itemCell.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
        }
        
        return itemCell;
    } else if(indexPath.section == kHXSCheckoutViewSectionCoupon) {
        [self setupSectionCouponCell:cell indexPath:indexPath];
    } else {//留言
        [cell.textLabel setText:@"留言"];
        NSString * remarks = [[HXSSettingsManager sharedInstance] getRemarks];
        if(remarks.length > 0) {
            [cell.detailTextLabel setText:remarks];
            cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0x666666];
        } else {
            cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0xCCCCCC];
            [cell.detailTextLabel setText:@"给店主留言(选填)"];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section != 0) {
        [self.view endEditing:YES];
    }
    
    if(indexPath.section == kHXSCheckoutViewSectionAddress) {
        
        HXSShoppingAddressVC *shippingAddressVC = [HXSShoppingAddressVC controllerFromXib];
        [self.navigationController pushViewController:shippingAddressVC animated:YES];

    } else if(indexPath.section == kHXSCheckoutViewSectionCoupon) {
        
        if (0 == indexPath.row) {
            // 配送费 不做处理
            return;
        }
        
        [HXSUsageManager trackEvent:kUsageEventChooseCoupon parameter:@{@"business_type":@"夜猫店"}];
        if (![HXSUserAccount currentAccount].isLogin) {
            [HXSLoginViewController showLoginController:self loginCompletion:^{
                [self autoMatchingCoupon];
            }];
        } else {
            [self displayCheckOutView];
        }
    } else if (indexPath.section == kHXSCheckoutViewSectionMessage) {
        
        [HXSUsageManager trackEvent:kUsageEventLeaveMessage parameter:@{@"business_type":@"夜猫店"}];
        
        HXSDormEditRemarksViewController *remarksController = [HXSDormEditRemarksViewController controllerFromXibWithModuleName:@"HXStoreBase"];
        
        [self.navigationController pushViewController:remarksController animated:YES];
    }
}


#pragma mark - Setup Cell

- (void)setupSectionCouponCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        [cell.textLabel setText:@"配送费"];
        
        [cell.detailTextLabel setText:@"￥0.00"];
        cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0x666666];
        
        cell.accessoryView = nil;
    } else {
        [cell.textLabel setText:@"优惠券"];
        
        if (![HXSUserAccount currentAccount].isLogin) {
            [cell.detailTextLabel setText:@"登录后显示"];
            cell.detailTextLabel.textColor = HXS_PROMPT_TEXT_COLOR;
        } else {
            HXSPromotionInfoModel *promotionInfoModel = [HXSDormCartManager sharedManager].promotionInfoModel;
            if([promotionInfoModel.couponDiscountDecNum compare:@(0.001)] == NSOrderedDescending) {
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"-%@", [promotionInfoModel.couponDiscountDecNum twoDecimalPlacesString]]];
                cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0xF9A502];
            } else {
                [cell.detailTextLabel setText:@"无可用优惠券"];
                cell.detailTextLabel.textColor = HXS_PROMPT_TEXT_COLOR;
            }
        }
    }
    
    
}

#pragma mark - Scroll View Delegate

//去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 44;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


#pragma mark - HXSCouponViewControllerDelegate

- (void)didSelectCoupon:(HXSCoupon *)coupon
{
    __weak typeof(self) weakSelf = self;
    
    [HXSLoadingView showLoadingInView:self.view];
    HXSDormCartManager *dormCartManager = [HXSDormCartManager sharedManager];
    [dormCartManager fetchPromtionCountInfoWithCouponCode:coupon.couponCode
                                                    items:dormCartManager.cartItemsArr
                                                 complete:^(HXSErrorCode code, NSString *message, HXSPromotionInfoModel *promotionInfoModel) {
                                                     [HXSLoadingView closeInView:weakSelf.view];
                                                     
                                                     if (kHXSNoError != code) {
                                                         [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                            status:message
                                                                                        afterDelay:1.5f];
                                                         
                                                         return ;
                                                     }
                                                     
                                                     weakSelf.promotionItems = promotionInfoModel.promotionItemsArr;
                                                     
                                                     
                                                     if (nil == coupon) {
                                                         
                                                         
                                                         if (0 < [promotionInfoModel.couponCodeStr length])
                                                         {
                                                             HXSCoupon *autoCoupon = [[HXSCoupon alloc] init];
                                                             autoCoupon.couponCode = promotionInfoModel.couponCodeStr;
                                                             autoCoupon.discount = promotionInfoModel.couponDiscountDecNum;
                                                             weakSelf.coupon = autoCoupon;
                                                         } else {
                                                             weakSelf.coupon = nil;
                                                         }
                                                     } else {
                                                         weakSelf.coupon = coupon;
                                                     }
                                                     
                                                     [weakSelf initialBlurView]; // update the totalLabel
                                                     
                                                     [weakSelf.tableView reloadData];
                                                 }];

}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1 && alertView.tag == 101) {
        UITextField *textfield=[alertView textFieldAtIndex:0];
        if(textfield.text.length < 6) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"验证码为6位,请再次输入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            alertView.tag = 101;
            UITextField *textfield=[alertView textFieldAtIndex:0];
            textfield.keyboardType = UIKeyboardTypeNumberPad;
            [alertView show];
        } else {
            
            self.verifyCode = textfield.text;
            [self payOrder];
        }
    } else if (alertView.tag == 103 && buttonIndex == 1) {
        UITextField *textfield=[alertView textFieldAtIndex:0];
        if(textfield.text.length > 0) {
            [HXSLoadingView showLoadingInView:self.view];
            
            __weak typeof(self) weakSelf = self;
            NSString * couponCode = textfield.text;
            [self.validate validateWithToken:[HXSUserAccount currentAccount].strToken
                                  couponCode:couponCode
                                        type: kHXSCouponScopeDorm
                                    complete:^(HXSErrorCode code, NSString *message, HXSCoupon *coupon) {
                [HXSLoadingView closeInView:weakSelf.view];
                                        
                if (code == kHXSNoError)
                {
                    [weakSelf didSelectCoupon:coupon];
                }
                else
                {
                    [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.0];
                }
            }];
        }
    }
}


#pragma mark - Setter Getter Methods

- (NSArray *)cartItems
{
    _cartItems = [[HXSDormCartManager sharedManager] cartItemsArr];
    
    return _cartItems;
}

- (HXSCouponValidate *)validate
{
    if (nil == _validate) {
        _validate = [[HXSCouponValidate alloc] init];
    }
    
    return _validate;
}

- (HXSOrderRequest *)orderRequest
{
    if (nil == _orderRequest) {
        _orderRequest = [[HXSOrderRequest alloc] init];
    }
    
    return _orderRequest;
}


@end
