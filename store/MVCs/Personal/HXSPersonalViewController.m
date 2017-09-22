//
//  HXSPersonalViewController.m
//  store
//
//  Created by chsasaw on 14-10-14.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSPersonalViewController.h"
#import "HXSPersonal.h"

// Controllers
#import "HXSSettingsViewController.h"
#import "HXSCouponViewController.h"
#import "HXSMyCommissionViewController.h"
#import "HXSMyFilesPrintViewController.h"
#import "HXSCreditWalletViewController.h"
#import "HXSLoginViewController.h"
#import "HXSBoxViewController.h"
#import "HXSWebViewController.h"
#import "HXSRecommendViewController.h"
#import "HXSComplaintViewController.h"
#import "HXSShoppingAddressVC.h"
#import "HXSMessageViewController.h"
#import "HXStoreMyDocumentLibraryViewController.h"
#import "HXSMyOrdersVC.h"
#import "HXSShopCollectViewController.h"
#import "HXSCouponMainViewController.h"
#import "HXSPersonMainViewController.h"


// Views
#import "UIBarButtonItem+HXSRedPoint.h"
#import "HXSPersonalCenterHeaderView.h"
#import "HXSPersonalMenuButton.h"
#import "HXSegmentControl.h"
#import "UINavigationBar+AlphaTransition.h"
#import "UIBarButtonItem+HXSRedPoint.h"
#import "HXSPopView.h"
#import "HXSOrderStatusTableViewCell.h"
#import "HXSOfenUseTableViewCell.h"

// Models
#import "HXSUserAccountModel.h"
#import "HXSShopManager.h"
#import "HXSWXApiManager.h"
#import "HXSShopViewModel.h"
#import "HXStoreDocumentLibraryViewModel.h"


static const CGFloat knavbarChangePoint       = 20.0f;
static const CGFloat knavbarTransparentHeight = 40.0f;

// section separated by new line
typedef NS_ENUM(NSInteger, AccountInfoType) {
    ShippingAddress,     // 收货地址
    AccountMyBill,       // 我的账单
    AccountMyBox,        // 我的盒子
    
    AccountFeedback,     // 反馈帮助
    
    AccountOpenShop,     // 开店赚钱
    AccountMyFile,        // 我的文件
    AccountMyDocmentUpload // 我的文库贡献
};

// ================================================================================

@interface HXSPersonalIndentationCell : UITableViewCell

@end

@implementation HXSPersonalIndentationCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.imageView.frame;
    rect.origin.x = 15;
    self.imageView.frame = rect;
    
    rect = self.textLabel.frame;
    rect.origin.x = self.imageView.right + 13.0;
    self.textLabel.frame = rect;
}

@end

// ================================================================================

static NSInteger const kTagNavigationTiemButton = 10000;

@interface HXSPersonalViewController ()<UITableViewDelegate,
                                        UITableViewDataSource,
                                        HXSOrderStatusTableViewCellDelegate,HXSOfenUseTableViewCellCellDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) HXSPersonalCenterHeaderView       *headView;
@property (nonatomic, weak) IBOutlet UITableView                *tableView;
@property (nonatomic, strong) HXSShopViewModel                  *shopModel;
@property (nonatomic, strong) HXSPopView                        *popView;
@property (nonatomic, strong) NSArray                           *tabBannerEntriesArr;
@property (nonatomic, assign) NSInteger                         currentUploadDocumentNums;
@property (nonatomic, strong) HXStoreDocumentLibraryViewModel   *viewModel;


@end

@implementation HXSPersonalViewController


#pragma mark - UIViewController Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        self.title = @"我的";
        self.navigationItem.title = @"我的";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.navigationItem.leftBarButtonItem = nil;
    
    [self initNavigationBarButtonItems];
    
    self.view.layer.masksToBounds = NO;
    self.view.clipsToBounds = NO;
    [self initialTableViewHeaderView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePersonalCenterView:) name:kLoginCompleted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePersonalCenterView:) name:kLogoutCompleted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUnreadMessageNumber)
                                                 name:kUnreadMessagehasUpdated
                                               object:nil];
    
    [self fetchTab4Entries];
    
    [self initDocumentLibraryObserver];
    _currentUploadDocumentNums = 0;
    [self fetchMyDocmentUploadNetworking];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // update head view
    [self.headView refreshInfo];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (0 == self.tableView.contentOffset.y) { // Just at the top
        [self.navigationController.navigationBar at_setBackgroundColor:[UIColor clearColor]];
    }
    
    self.view.backgroundColor = [UIColor colorWithRGBHex:0xF5F6FB];
    
    // 点击积分/优惠券按钮的时候同时按住一个Cell,之前的[tableView deselectRowAtIndexPath:indexPath animated:NO];没起作用
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    [self.tableView endRefreshing];
    [self.navigationController.navigationBar at_resetBackgroundColor:HXS_MAIN_COLOR translucent:YES];
//    [self changeNavigationBarBackgroundColor:[UIColor colorWithHexString:@"fde25c"]
//                        pushBackButItemImage:[UIImage imageNamed:@"btn_back_normal"]
//                     presentBackButItemImage:[UIImage imageNamed:@"xia"]
//                                  titleColor:[UIColor blackColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Initial Methods

- (void)initNavigationBarButtonItems
{
    // Add right bar button
    UIImage *messageImage = [UIImage imageNamed:@"nav-xiaoxiao"];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, messageImage.size.width, messageImage.size.height)];
    [rightBtn setImage:messageImage forState:UIControlStateNormal];
    [rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightBtn addTarget:self
                 action:@selector(clickMessageBtn:)
       forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTag:kTagNavigationTiemButton];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    NSNumber *unreadMessageNum = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_UNREAD_MESSGE_NUMBER];
    NSString *unreadMessageStr = nil;
    if ([HXSUserAccount currentAccount].isLogin) {
        unreadMessageStr = [NSString stringWithFormat:@"%@", unreadMessageNum ? unreadMessageNum : @0];
    }
    rightBarButton.redPointBadgeValue     = unreadMessageStr;
    
    // Right two buttons
    UIBarButtonItem *messageItem = rightBarButton;
    
    UIButton *settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [settingBtn setImage:[UIImage imageNamed:@"nav-shezhi"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(settingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    self.navigationItem.leftBarButtonItem = settingItem;
    
    if (messageItem != nil) {
        UIBarButtonItem* fixedSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpaceItem.width = 20;
        
        self.navigationItem.rightBarButtonItems = @[messageItem,fixedSpaceItem];
    }
//    else {
//        self.navigationItem.rightBarButtonItems = @[settingItem];
//    }
}

- (void)settingButtonPressed:(id)sender
{
    [HXSUsageManager trackEvent:kUsageEventPersonalSetting parameter:nil];
    
    HXSSettingsViewController *controller = [[HXSSettingsViewController alloc] initWithNibName:@"HXSSettingsViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)initialTableViewHeaderView
{
    __weak typeof (self) weakSelf = self;
    
    [self.tableView addRefreshHeaderWithCallback:^{
        [weakSelf reload];
    }];
    
    _headView = [HXSPersonalCenterHeaderView headerView];
    self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 234);
    self.tableView.tableHeaderView = _headView;
    
    _headView.backgroundColor = [UIColor colorWithHexString:@"fde25c"];
    self.view.backgroundColor = [UIColor colorWithRGBHex:0x68B7FC];
    _tableView.backgroundColor = [UIColor colorWithRGBHex:0xF5F6FB];
    
    [self.headView.centsBtn addTarget:self
                               action:@selector(onClickCentsBtn:)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.headView.couponsBtn addTarget:self
                                 action:@selector(onClickCouponsBtn:)
                       forControlEvents:UIControlEventTouchUpInside];
    [self.headView.creditBtn addTarget:self
                                action:@selector(onClickCreditBtn:)
                      forControlEvents:UIControlEventTouchUpInside];
    [self.headView.personInfoBtn addTarget:self
                                    action:@selector(onClickPersonInfoBtn:)
                          forControlEvents:UIControlEventTouchUpInside];
    [self.headView.commissionBtn addTarget:self
                                    action:@selector(onClickCommissionBtn:)
                          forControlEvents:UIControlEventTouchUpInside];
    [self.headView.signButton addTarget:self
                                 action:@selector(signButtonClicked:)
                       forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)initDocumentLibraryObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onLoginComplete:)
                                                 name:kLoginCompleted
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshUploadDocmentNums:)
                                                 name:kDocumentLibUploaded
                                               object:nil];
}


#pragma mark - Target Methods

- (void)updatePersonalCenterView:(NSNotification *)noti
{
    if(self.headView) {
        
        [self.headView refreshInfo];
    }
    
    [self.tableView reloadData];
    
    [self updateUnreadMessageNumber];
}

- (IBAction)onClickSettingsButton:(id)sender
{
    HXSSettingsViewController * controller = [[HXSSettingsViewController alloc] initWithNibName:@"HXSSettingsViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

//优惠券
- (void)onClickCentsBtn:(HXSPersonalMenuButton *)button
{

    [HXSUsageManager trackEvent:kUsageEventPersonalMyCoupon parameter:nil];
    
    if ([[AppDelegate sharedDelegate].rootViewController checkIsLoggedin]) {
    

        HXSCouponMainViewController *mainVc = [[HXSCouponMainViewController alloc] init];
        [self.navigationController pushViewController:mainVc animated:YES];
        /*
        HXSCouponViewController * couponViewController = [HXSCouponViewController controllerFromXibWithModuleName:@"Coupon"];
        couponViewController.couponScope = kHXSCouponScopeNone;
        couponViewController.fromPersonalVC = YES;
        [self.navigationController pushViewController:couponViewController animated:YES];*/
        
        
    }
    /*
    [HXSUsageManager trackEvent:kUsageEventPersonalMyPoint parameter:nil];
    
    [HXSLoginViewController showLoginController:self loginCompletion:^{
        HXSWebViewController *webViewController = [HXSWebViewController controllerFromXib];
        NSString *url = [[ApplicationSettings instance] creditCentsURL];
        [webViewController setUrl:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        webViewController.title = @"积分商城";
        [self.navigationController pushViewController:webViewController animated:YES];
    }];*/
}

//购物车
- (void)onClickCouponsBtn:(HXSPersonalMenuButton *)button
{
   
    /*
    [HXSUsageManager trackEvent:kUsageEventPersonalMyCoupon parameter:nil];
    
    if ([[AppDelegate sharedDelegate].rootViewController checkIsLoggedin]) {
        HXSCouponViewController * couponViewController = [HXSCouponViewController controllerFromXibWithModuleName:@"Coupon"];
        couponViewController.couponScope = kHXSCouponScopeNone;
        couponViewController.fromPersonalVC = YES;
        [self.navigationController pushViewController:couponViewController animated:YES];
    }*/
}

- (void)onClickCreditBtn:(HXSPersonalMenuButton *)button
{
    [HXSUsageManager trackEvent:kUsageEventPersonalCreditPurse parameter:nil];
    
    if ([[AppDelegate sharedDelegate].rootViewController checkIsLoggedin]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:nil];
        HXSCreditWalletViewController *creditWalletVC = [storyboard instantiateViewControllerWithIdentifier:@"HXSCreditWalletViewController"];
        
        [self.navigationController pushViewController:creditWalletVC animated:YES];
        
    }
}

- (void)onClickPersonInfoBtn:(HXSPersonalMenuButton *)button
{
    [HXSUsageManager trackEvent:kUsageEventPersonalClickPortrait parameter:nil];
    
    if (![HXSUserAccount currentAccount].isLogin) {
        [[AppDelegate sharedDelegate].rootViewController checkIsLoggedin];
    } else {
        
        [self pushPersonalInfoVC];
    }
}

- (void)clickMessageBtn:(UIButton *)button
{
    WS(weakSelf);
    [HXSLoginViewController showLoginController:self loginCompletion:^{
        
        NSString *title = (weakSelf.title.length > 0) ? weakSelf.title : @"";
        [HXSUsageManager trackEvent:kUsageEventMessageCenter parameter:@{@"title":title}];
        
        BOOL hasExistedMessageVC = NO;
        for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
            if ([vc isKindOfClass:[HXSMessageViewController class]]) {
                hasExistedMessageVC = YES;
                break;
            }
        }

        if (hasExistedMessageVC) {
            
            NSArray *controllers = weakSelf.navigationController.viewControllers;
            NSArray *result = [controllers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                return [evaluatedObject isKindOfClass:NSClassFromString(@"HXSMessageViewController")];
            }]];
        
            if (result.count > 0) {
                [weakSelf.navigationController popToViewController:result[0] animated:YES];
            }
        } else {
            
            HXSMessageViewController *messageCenterVC = [[HXSMessageViewController alloc]initWithNibName:nil bundle:nil];
            messageCenterVC.hidesBottomBarWhenPushed = YES;
            
            [weakSelf.navigationController pushViewController:messageCenterVC animated:YES];
        
        }
        
    }];
}

// 点击积分
- (void)onClickCommissionBtn:(UIButton *)button
{
    
    [HXSUsageManager trackEvent:kUsageEventPersonalMyPoint parameter:nil];
    
    [HXSLoginViewController showLoginController:self loginCompletion:^{
        
        HXSWebViewController *webViewController = [HXSWebViewController controllerFromXib];
        NSString *url = [[ApplicationSettings instance] creditCentsURL];
        [webViewController setUrl:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        webViewController.title = @"积分商城";
        [self.navigationController pushViewController:webViewController animated:YES];
        
    }];
    /*
    __weak typeof(self) weakSelf = self;
    if (![HXSUserAccount currentAccount].isLogin) {
        
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            [weakSelf pushCommissionVC];
        }];
        
    } else {
        [weakSelf pushCommissionVC];
    }*/
    
}
- (void)signButtonClicked:(UIButton *)sender
{
    if (![HXSUserAccount currentAccount].isLogin) {
        
        [HXSLoginViewController showLoginController:self loginCompletion:nil];
        
    } else {
        
        [MBProgressHUD showInView:self.view];
        __weak typeof(self) weakSelf = self;
        [HXSUserAccountModel userSignIn:^(HXSErrorCode code, NSString *message, NSDictionary *info) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(kHXSNoError == code){
                UIImageView *imageView  =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_collarintegral"]];
                HXSUserBasicInfo *basicInfo = [HXSUserAccount currentAccount].userInfo.basicInfo;

                [MBProgressHUD showInView:weakSelf.view customView:imageView status:[NSString stringWithFormat:@"签到成功\n恭喜获得%d积分",basicInfo.signInCreditIntNum.intValue] afterDelay:1.5];
                
                [weakSelf reload];
                } else {
                [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
            }
            
        }];
    }
}


#pragma mark - Fecth Data

- (void)fetchTab4Entries
{
    WS(weakSelf);
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSSite *site = locationMgr.currentSite;
    NSNumber *siteIdIntNum = (0 < [site.site_id integerValue]) ? site.site_id : [[ApplicationSettings instance] defaultSiteID];
    
    [self.shopModel fetchStoreAppEntriesWithSiteId:siteIdIntNum
                                              type:@(kHXSStoreInletTabBarForth)
                                          complete:^(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr) {
                                              if (0 >= [entriesArr count]) {
                                                  return ;
                                              }
                                              
                                              weakSelf.tabBannerEntriesArr = entriesArr;
                                              
                                              [weakSelf displayTabBannerWithEntries];
                                          }];
}

/**
 *获取我上传的文档页数
 **/
- (void)fetchMyDocmentUploadNetworking
{
    if(![HXSUserAccount currentAccount].isLogin) {
        return;
    }
    [MBProgressHUD showInView:self.view];
    WS(weakSelf);
    [self.viewModel fetchPrintDormShopShareDocTotalNumsWithShopId:nil
                                                         Complete:^(HXSErrorCode code, NSString *message, NSNumber *totalNums)
    {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if(kHXSNoError == code
           && totalNums) {
            weakSelf.currentUploadDocumentNums = [totalNums integerValue];
        } else {
            weakSelf.currentUploadDocumentNums = 0;
        }
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - Tab Banner Methods

- (void)displayTabBannerWithEntries
{
    HXSStoreAppEntryEntity *entity = [self.tabBannerEntriesArr firstObject];
    
    if (0 >= [entity.linkURLStr length]) {
        return;
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView sd_setImageWithURL:[NSURL URLWithString:entity.imageURLStr] placeholderImage:[UIImage imageNamed:@"img_kp_banner_cat"]];
    
    [imageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(onClickTabBanner)];
    
    [imageView addGestureRecognizer:tap];
    
    // tab banner view
    HXSPopView *popView = [[HXSPopView alloc] initWithView:imageView];
    
    [popView show];
    
    self.popView = popView;
}

- (void)onClickTabBanner
{
    HXSStoreAppEntryEntity *entity = [self.tabBannerEntriesArr firstObject];
    
    __weak typeof(self) weakSelf = self;
    [self.popView closeWithCompleteBlock:^{
        [weakSelf pushToVCWithLink:entity.linkURLStr];
    }];
}

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


#pragma mark - private method

- (void)setupNavigationBar
{
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)reload
{
    // If didn't login, don't refresh
    if (![HXSUserAccount currentAccount].isLogin) {
        [self.tableView endRefreshing];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserInfo)
                                                 name:kUserInfoUpdated
                                               object:nil];
    
    // update user info in basic info class.
    [[[HXSUserAccount currentAccount] userInfo] updateUserInfo];
    
}

- (void)updateUserInfo
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kUserInfoUpdated
                                                  object:nil];
    
    [self.tableView endRefreshing];
    
    [self.headView refreshInfo];
    
    [self updateUnreadMessageNumber];
}


#pragma mark - Notification Methods

- (void)updateUnreadMessageNumber
{
    // Don't display the red point on the message button when did not login
    if (![HXSUserAccount currentAccount].isLogin) {
        self.navigationItem.rightBarButtonItem.redPointBadgeValue = nil;
        
        return;
    }
    
    NSNumber *unreadMessageNum = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_UNREAD_MESSGE_NUMBER];
    
    if ((nil != unreadMessageNum)
        && [unreadMessageNum isKindOfClass:[NSNumber class]]) {
        if ([self.navigationItem.rightBarButtonItem.customView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
            if (kTagNavigationTiemButton == button.tag) {
                self.navigationItem.rightBarButtonItem.redPointBadgeValue = [NSString stringWithFormat:@"%@", unreadMessageNum];
            }
        }
    } else {
        self.navigationItem.rightBarButtonItem.redPointBadgeValue = nil;
    }
}

- (void)onLoginComplete:(NSNotification *)notification
{
    [self fetchMyDocmentUploadNetworking];
}

- (void)refreshUploadDocmentNums:(NSNotification *)notification
{
    [self fetchMyDocmentUploadNetworking];
}


#pragma mark - UITableViewDelegate && UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1||indexPath.section ==2) {
       
        return 100;
        
    }
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
    
        return 15;
        
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1) { // 我的订单
        //return 5;
         return 1;
    } else if (section == 2) { // 常用设置
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier     =  @"HXSPersonalCell";
    
    if (indexPath.section==1) {
        
        HXSOrderStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        if (!cell) {
            cell = [[HXSOrderStatusTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.delegate = self;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        return cell;
    }else if (indexPath.section ==2){
    
        //HXSOfenUseTableViewCell
        HXSOfenUseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        if (!cell) {
            cell = [[HXSOfenUseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.delegate = self;
            cell.backgroundColor = [UIColor clearColor];
        }
        return cell;
    
    
    }

    //AccountInfoType cellType = [self infoTypeForIndexPath:indexPath];
    UITableViewCell *cell;

    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[HXSPersonalIndentationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    /*
    HXSUserCreditcardInfoEntity *creditCardInfo = [HXSUserAccount currentAccount].userInfo.creditCardInfo;
    
    if (cellType == AccountMyBill) {
        if (0 < [creditCardInfo.recentBillAmountDoubleNum doubleValue]) {
            NSString *recentBillAmountStr = [NSString stringWithFormat:@"¥%@", creditCardInfo.recentBillAmountDoubleNum];
            NSString *foreBodyStr = @"近期有";
            NSString *wholeStr = [NSString stringWithFormat:@"%@%@待还", foreBodyStr, recentBillAmountStr];
            NSMutableAttributedString *AttributeMStr = [[NSMutableAttributedString alloc] initWithString:wholeStr];
            [AttributeMStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGBHex:0xF9A502] range:NSMakeRange(foreBodyStr.length, recentBillAmountStr.length)];
            cell.detailTextLabel.attributedText = AttributeMStr;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        } else  {
            cell.detailTextLabel.text = nil;
        }
    } else if(cellType == AccountMyDocmentUpload
                  && [[HXSUserAccount currentAccount] isLogin]) {
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%zd篇文档",_currentUploadDocumentNums]];
        cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0x999999];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    } else {
        cell.detailTextLabel.text = nil;
    }
    
    cell.textLabel.text = [self titleForAccountInfoType:cellType];
    cell.imageView.image = [UIImage imageNamed:[self imageForAccountInfoType:cellType]];
    cell.textLabel.textColor = [UIColor colorWithRGBHex:0x333333];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];*/
    
    return cell;
}
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    AccountInfoType cellType = [self infoTypeForIndexPath:indexPath];
    
    switch (cellType) {
        case AccountFeedback:
        {
            HXSComplaintViewController *feedbackVC = [[HXSComplaintViewController alloc] initWithNibName:@"HXSComplaintViewController" bundle:nil];
            
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
//        case AccountMyBox:
//        {
//            WS(weakSelf);
//            [HXSLoginViewController showLoginController:self loginCompletion:^{
//                [weakSelf jumpToMyBoxController];
//            }];
//        }
//            break;

        case AccountMyBill:
        {
            [HXSUsageManager trackEvent:kUsageEventWalletMyBill parameter:nil];
            WS(weakSelf);
            [HXSLoginViewController showLoginController:self loginCompletion:^{
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:[NSBundle mainBundle]];
                UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"HXSMyBillViewController"];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
        }
            break;
        case AccountOpenShop:
        {
            __weak typeof(self) weakSelf = self;
            if (![HXSUserAccount currentAccount].isLogin) {
                [HXSLoginViewController showLoginController:self loginCompletion:^{
                    [weakSelf openShop];
                }];
            } else {
                [weakSelf openShop];
            }
        }
            break;
//        case AccountMyFile: // 我的文件
//        {
//            [self jumpToMyFilesViewController];
//        }
//            break;
//        case AccountMyDocmentUpload: // 我的文库贡献
//        {
//            __weak typeof(self) weakSelf = self;
//            if (![HXSUserAccount currentAccount].isLogin){
//                [HXSLoginViewController showLoginController:self loginCompletion:^{
//                    [weakSelf jumpToMyDocumentUploadViewController];
//                }];
//            }else{
//                [weakSelf jumpToMyDocumentUploadViewController];
//            }
//        }
            break;
        case ShippingAddress: // 收货地址
        {
            __weak typeof(self) weakSelf = self;
            if (![HXSUserAccount currentAccount].isLogin){
                [HXSLoginViewController showLoginController:self loginCompletion:^{
                    [weakSelf pushShopingAddressVC];
                }];
            }else{
                [weakSelf pushShopingAddressVC];
            }
        }
            break;
        default:
            break;
    }
}*/

#pragma mark - HXSOrderStatusTableViewCellDelegate

- (void)clickHXDOrderStatusButtonTypeButtonType:(HXDOrderStatusButtonType)type;{


    UIStoryboard *stroyB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HXSMyOrdersVC *order = [stroyB instantiateViewControllerWithIdentifier:@"HXSMyOrdersVC"];
    
    order.hasBackBut = YES;
            
   
    switch (type) {
                    
            case HXDOrderStatusButtonTypeAll:{
                    
                    //全部订单HXSMyOrdersVC
                    order.page = 0;
                    
                    break;
                }
            case HXDOrderStatusButtonTypeWaitingBuy:{
                    
                    //待付款
                    
                    order.page = 1;
                    
                    break;
                }
            case HXDOrderStatusButtonTypeWaitingFahuo:{
                    
                    //待发货
                    order.page = 2;
                    
                    break;
                }
            case HXDOrderStatusButtonTypeWaitingshouhuo:{
                    
                    //待收货
                    order.page = 2;
                    break;
                }
            case HXDOrderStatusButtonTypeWaitingComment:{
                    
                    //待评价
                    order.page = 3;
                    break;
                }
            case HXDOrderStatusButtonTypeTuikuan:{
                    
                    //退款
                    order.page = 4;
                    break;
                }
                    
            default:
                    break;
            }
            
            
    
      
        
    if (![HXSUserAccount currentAccount].isLogin) {
        
        [HXSLoginViewController showLoginController:self loginCompletion:^{
         
            
        }];
        
    }else{
    
      [self.navigationController pushViewController:order animated:YES];
    
    }
    
    
   


}
#pragma mark - HXSOfenUseTableViewCellCellDelegate
- (void)clickHXDOfenUseButtonType:(HXDOfenUseButtonType)type;{

    

    switch (type) {
            
        case HXDOfenUseButtonTypeShopCollect:{
            
          HXSShopCollectViewController *shop = [[HXSShopCollectViewController alloc] init];
            if (![HXSUserAccount currentAccount].isLogin) {
                
                [HXSLoginViewController showLoginController:self loginCompletion:^{
                  
                    //店铺收藏
                    
                    [self.navigationController pushViewController:shop animated:YES];
                    
                }];
            }else{
            
            [self.navigationController pushViewController:shop animated:YES];
            
            }
            
            
            break;
        }
        case HXDOfenUseButtonTypePlaceManage:{
            
            //地址管理
            __weak typeof(self) weakSelf = self;
            if (![HXSUserAccount currentAccount].isLogin){
                [HXSLoginViewController showLoginController:self loginCompletion:^{
                    [weakSelf pushShopingAddressVC];
                }];
            }else{
                [weakSelf pushShopingAddressVC];
            }
            
            break;
        }
        case HXDOfenUseButtonTypeKefu:{
            
            //客服中心 直接跳转到电话页面
            HXSCustomAlertView *alert = [[HXSCustomAlertView alloc]initWithTitle:@"拨打客服电话"
                                                                         message:@"13918180114"
                                                                 leftButtonTitle:@"取消"
                                                               rightButtonTitles:@"拨号"];
            alert.rightBtnBlock = ^{
                
                NSString *phoneNumber = [@"tel://" stringByAppendingString:@"13918180114"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
              
            };
            
            [alert show];
            
            
            break;
        }
        case HXDOfenUseButtonTypeFeedback:{
            
            
            //意见反馈
            HXSComplaintViewController *feedbackVC = [[HXSComplaintViewController alloc] initWithNibName:@"HXSComplaintViewController" bundle:nil];
            
            __weak typeof(self) weakSelf = self;
            if (![HXSUserAccount currentAccount].isLogin){
                [HXSLoginViewController showLoginController:self loginCompletion:^{
                    [weakSelf.navigationController pushViewController:feedbackVC animated:YES];
                }];
            }else{
                
                [weakSelf.navigationController pushViewController:feedbackVC animated:YES];
            }
            
            
            
            break;
        }
       
            
        default:
            break;
    }

}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // This Line Fix a Bug
    if (self.navigationController.topViewController != self) {
        return;
    }
    
    [self checkTheScrollViewOffsetAndSetTheNavigationBarWithScrollView:scrollView];
}


#pragma mark - Privater Methods

- (void)checkTheScrollViewOffsetAndSetTheNavigationBarWithScrollView:(UIScrollView *)scrollView
{
    UIColor * color = HXS_MAIN_COLOR;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > knavbarChangePoint) {
        CGFloat alpha = MIN(1, 1 - ((knavbarChangePoint + 64 - offsetY) / 64));
        [self.navigationController.navigationBar at_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar at_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
    
    if (scrollView.contentOffset.y < 0) {
        if (scrollView.contentOffset.y < -knavbarTransparentHeight) {
            [self.navigationController.navigationBar at_setElementsAlpha:0];
        } else {
            CGFloat alpha = -scrollView.contentOffset.y/knavbarTransparentHeight;
            [self.navigationController.navigationBar at_setElementsAlpha:1 - alpha];
        }
    } else {
        [self.navigationController.navigationBar at_setElementsAlpha:1];
    }
}


#pragma mark - Go to my box

- (void)jumpToMyBoxController
{
    HXSBoxViewController *boxVC = [HXSBoxViewController controllerFromXib];
    
    [self.navigationController pushViewController:boxVC animated:YES];
}


- (void)updateMyBoxInfoToLocationInfo
{
    HXSLocationManager *boxLoMgr = [HXSLocationManager manager];
    HXSUserMyBoxInfo *myBoxInfo  = [HXSUserAccount currentAccount].userInfo.myBoxInfo;
    
    boxLoMgr.currentCity     = myBoxInfo.cityEntry;
    boxLoMgr.currentSite     = myBoxInfo.siteEntry;
    boxLoMgr.buildingEntry   = myBoxInfo.buildingEntry;
    
    HXSShopManager *shopManager = [HXSShopManager shareManager];
    shopManager.currentEntry    = myBoxInfo.dormEntry;
}


#pragma mark - Push Methods

- (void)pushPersonalInfoVC
{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PersonalInfo" bundle:nil];
//    UIViewController *personalInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"HXSPersonalInfoTableViewController"];
    
    HXSPersonMainViewController *mainVc = [[HXSPersonMainViewController alloc] init];
    
    [self.navigationController pushViewController:mainVc animated:YES];
    
}

- (void)pushCommissionVC
{
    HXSMyCommissionViewController *myCommissionViewController = [[HXSMyCommissionViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:myCommissionViewController animated:YES];
}

- (void)openShop
{
    NSString *baseURL = [[ApplicationSettings instance] registerStoreManagerBaseURL];
    NSString *url = [NSString stringWithFormat:@"%@?site_id=%d", baseURL, [[HXSLocationManager manager].currentSite.site_id intValue]];
    
    HXSWebViewController *webVc = [HXSWebViewController controllerFromXib];
    webVc.url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [self.navigationController pushViewController:webVc animated:YES];
}

- (void)jumpToMyFilesViewController
{
    HXSMyFilesPrintViewController *myFilesPrintVC = [HXSMyFilesPrintViewController createFilesPrintVCWithEntity:nil];
    
    [self.navigationController pushViewController:myFilesPrintVC animated:YES];
}

- (void)jumpToMyDocumentUploadViewController
{
    HXStoreMyDocumentLibraryViewController *myDocVC = [HXStoreMyDocumentLibraryViewController createMyDocumentLibraryVC];
    
    [self.navigationController pushViewController:myDocVC animated:YES];
}

- (void)pushShopingAddressVC
{
    HXSShoppingAddressVC *shippingAddressVC = [[HXSShoppingAddressVC alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:shippingAddressVC animated:YES];
    
}


#pragma mark - Get Set Methods

- (AccountInfoType)infoTypeForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:     return ShippingAddress;
            case 1:     return AccountMyBill;
            case 2:     return AccountMyFile;
            case 3:     return AccountMyDocmentUpload;
            case 4:     return AccountMyBox;
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:     return AccountOpenShop;
        }
    } else if (indexPath.section == 3) {
        return AccountFeedback;
    }
    return ShippingAddress;
}

- (NSString *)titleForAccountInfoType:(AccountInfoType)type
{
    switch (type) {
        case ShippingAddress:       return @"收货地址";
        case AccountMyBill:         return @"我的账单";
        case AccountMyFile:         return @"我的文件";
        case AccountMyBox:          return @"我的盒子";
        case AccountFeedback:       return @"反馈帮助";
        case AccountOpenShop:       return @"开店挣钱";
        case AccountMyDocmentUpload:return @"我的文库贡献";
        default:
            return @"";
    }
}

- (NSString *)imageForAccountInfoType:(AccountInfoType)type
{
    switch (type) {
        case ShippingAddress:       return @"ic_Receipt address";
        case AccountMyBill:         return @"ic_personal_bill";
        case AccountMyFile:         return @"ic_woddewenjian";
        case AccountMyBox:          return @"ic_personal_box";
        case AccountFeedback:       return @"ic_personal_help";
        case AccountOpenShop:       return @"ic_openshop";
        case AccountMyDocmentUpload:return @"ic_my_wenkugongxian";
        default:
            return @"";
    }
}

- (HXSShopViewModel *)shopModel
{
    if (nil == _shopModel) {
        _shopModel = [[HXSShopViewModel alloc] init];
    }
    
    return _shopModel;
}

- (HXStoreDocumentLibraryViewModel *)viewModel
{
    if(nil == _viewModel) {
        _viewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
    }
    
    return _viewModel;
}

@end
