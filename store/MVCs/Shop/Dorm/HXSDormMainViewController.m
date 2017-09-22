//
//  HXSDormMainViewController.m
//  store
//
//  Created by chsasaw on 15/1/23.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSDormMainViewController.h"
#import "HXSShop.h"

// Controllers
#import "HXSDormListHorizontalViewController.h"
#import "HXSShopInfoViewController.h"
#import "HXSWebViewController.h"
#import "HXSLoginViewController.h"

// Model
#import "HXSAlipayManager.h"
#import "HXSBuildingEntry.h"
#import "HXSCategoryModel.h"
#import "HXSDormItem.h"
#import "HXSFloatingCartEntity.h"
#import "HXSShopViewModel.h"
#import "HXSSite.h"
#import "HXSDormCountSelectView+HXSDormCountSelectView_Dorm5_1.h"
#import "HXSDormCartManager.h"

// Views
#import "HXSCheckoutViewController.h"
#import "HXSCoupon.h"
#import "HXSFloatingCartView.h"
#import "HXSLoadingView.h"
#import "HXSLocationCustomButton.h"
#import "HXSNoticeView.h"
#import "MIBadgeButton.h"

// Others
#import "HXSShopManager.h"

static NSInteger const kHeightScrollTabBar = 40;

@interface HXSDormMainViewController () <HXSDormListHorizontalViewControllerDelegate,
                                         HXSFloatingCartViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *listContentView;
@property (nonatomic, weak) IBOutlet JCRBlurView *blurView;
@property (nonatomic, weak) IBOutlet MIBadgeButton *cartButton;
@property (nonatomic, weak) IBOutlet UILabel *totalLabel;
@property (nonatomic, weak) IBOutlet UILabel *promotionLabel;
@property (nonatomic, weak) IBOutlet UIButton *checkoutBtn;

@property (nonatomic, weak) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet UIView *dontOpenView;
@property (weak, nonatomic) IBOutlet UIButton *openDormStoreBtn;
@property (weak, nonatomic) IBOutlet HXSNoticeView *noticeAndActivitiesView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topViewTopOffset;

@property (nonatomic, strong) NSNumber *shopIDIntNum;
@property (nonatomic, strong) HXSShopEntity *shopEntity;

@property (nonatomic, assign) BOOL autoScrolling;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) BOOL isHidden;

@property (nonatomic, strong) HXSFloatingCartView *cartView;

@property (nonatomic, strong) UIView *noticeDetailView;

// Sub VCs
@property (nonatomic, strong) HXSDormListHorizontalViewController *listHorizontalVC;
@property (nonatomic, strong) UIViewController *currentVC;

@property (nonatomic, strong) NSArray *dormEntryOpenArr;
@property (nonatomic, strong) HXSLocationCustomButton *locationButton;
@property (nonatomic, strong) HXSShopInfoViewController *shopInfoVC;

@property (nonatomic, assign) BOOL hasDisplayShopInfoView;

@property (nonatomic, strong) NSNumber *currentCategoryId; //当前分类的Id
@property (nonatomic, strong) HXSShopViewModel *shopModel;

@end

@implementation HXSDormMainViewController

#pragma mark - View Controller LifeCycle

+ (instancetype)createDromVCWithShopId:(NSNumber*)shopIdIntNum
{
    UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    HXSDormMainViewController* mainVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"HXSDormMainViewController"];
    mainVC.shopIDIntNum = shopIdIntNum;

    return mainVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.autoScrolling = NO;
    self.isHidden      = NO;
    self.isAnimating   = NO;
    
    [self initialNavigationBar];

    [self initialSubChildViewControllers];

    [self initialButtonStatus];

    [self initialEventMethods];
    
    [self initialBlurView];

    [self performSelector:@selector(fetchShopInfo) withObject:nil afterDelay:0.5]; // Must fetch shop info
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self changeNavigationBarBackgroundColor:[UIColor colorWithRGBHex:navBarWhiteBgColorValue]
                        pushBackButItemImage:[UIImage imageNamed:@"fanhui"]
                     presentBackButItemImage:[UIImage imageNamed:@"xia"]
                                  titleColor:[UIColor colorWithRGBHex:navBarWhiteTitleVolorValue]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [MobClick event:@"dorm_main"];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self changeNavigationBarNormal];

    if (self.cartView && self.cartView.superview) {
        [self.cartView hide:NO];
        self.cartView = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kUpdateDormCartComplete
                                                  object:nil];

    self.cartView         = nil;
    self.noticeDetailView = nil;
    self.listHorizontalVC = nil;
    self.currentVC        = nil;
    self.dormEntryOpenArr = nil;
}

#pragma mark - override
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)close
{
    [super close];
    
    [HXSUsageManager trackEvent:kUsageEventGoodsSelectGoBack parameter:@{ @"business_type" : @"夜猫店" }];
}

- (void)back
{
    [HXSUsageManager trackEvent:kUsageEventGoodsSelectGoBack parameter:@{ @"business_type" : @"夜猫店" }];
    
    HXSDormCartManager *cartManager = [HXSDormCartManager sharedManager];
    if (0 >= [[cartManager cartItemsArr] count]) {
        [super back];
        
        return;
    }
    
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"清空购物车"
                                                                      message:@"您确定不要这些东西了吗？"
                                                              leftButtonTitle:@"取消"
                                                            rightButtonTitles:@"清空"];
    
    alertView.rightBtnBlock = ^{
        [[HXSDormCartManager sharedManager] clearCart];
        
        [super back];
    };
    
    [alertView show];
}


#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    if (nil == self.locationButton) {
        self.locationButton = [HXSLocationCustomButton buttonWithType:UIButtonTypeCustom];
        [self.locationButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [self.locationButton addTarget:self action:@selector(onClickTitleView:) forControlEvents:UIControlEventTouchUpInside];
        [self.locationButton setTitleColor:[UIColor colorWithRGBHex:0x303030] forState:UIControlStateNormal];
        [self.locationButton setTitleColor:[UIColor colorWithRGBHex:0x303030] forState:UIControlStateHighlighted];
        [self.locationButton setImage:[UIImage imageNamed:@"xia"] forState:UIControlStateNormal];
    }

    [self.locationButton setTitle:self.shopEntity.shopNameStr forState:UIControlStateNormal];
    
    self.navigationItem.titleView = self.locationButton;
    [self.navigationItem.titleView layoutSubviews];
    
}

- (void)initialSubChildViewControllers
{
    _listHorizontalVC = [HXSDormListHorizontalViewController controllerFromXib];
    self.listHorizontalVC.listDelegate = self;
    
    [self addChildViewController:self.listHorizontalVC];

    UIViewController* tempVC = self.listHorizontalVC;

    [self.listContentView addSubview:tempVC.view];
    [tempVC.view mas_remakeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.listContentView);
    }];

    self.currentVC = tempVC;

    [tempVC didMoveToParentViewController:self];
    
}

- (void)initialButtonStatus
{
    // check out btn
    [self.checkoutBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xFF9503)]
                                forState:UIControlStateNormal];
    [self.checkoutBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]]
                                forState:UIControlStateDisabled];
    [self.checkoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.checkoutBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateDisabled];
    [self.checkoutBtn setTitle:[NSString stringWithFormat:@"%d 元起送", self.shopEntity.minAmountFloatNum.intValue]
                      forState:UIControlStateNormal];
    [self.checkoutBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    // open store
    self.openDormStoreBtn.layer.masksToBounds = YES;
    self.openDormStoreBtn.layer.cornerRadius = 4.0f;
}

- (void)initialEventMethods
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartUpdated:) name:kUpdateDormCartComplete object:nil];
}

- (void)initialBlurView
{
    // blur view
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCart:)];
    gesture.numberOfTapsRequired = 1;
    gesture.numberOfTouchesRequired = 1;
    [self.blurView addGestureRecognizer:gesture];
    
    self.blurView.blurTintColor = UIColorFromRGB(0xF5FBFD);
}



#pragma mark - Fetch Data Methods

/**
 *  获取店铺信息
 */
- (void)fetchShopInfo
{
    [HXSLoadingView showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;

    HXSLocationManager* manager = [HXSLocationManager manager];
    [self.shopModel fetchShopInfoWithSiteId:manager.currentSite.site_id
                                   shopType:@(0)
                                dormentryId:manager.buildingEntry.dormentryIDNum
                                     shopId:self.shopIDIntNum
                                   complete:^(HXSErrorCode status, NSString* message, HXSShopEntity* shopEntity) {
                                       [HXSLoadingView closeInView:weakSelf.view];

                                       if (kHXSNoError != status) {
                                           [HXSLoadingView showLoadFailInView:weakSelf.view
                                                                        block:^{
                                                                            [weakSelf fetchShopInfo];
                                                                        }];

                                           return;
                                       }

                                       weakSelf.shopEntity = shopEntity;

                                       [weakSelf initialNavigationBar];

                                       [weakSelf saveShopEntityToCurrentEntry];
                                       
                                       [weakSelf updateNoticeAndActivitiesView];
                                       
                                       [weakSelf.listHorizontalVC setShopEntity:shopEntity];
                                       
                                       [weakSelf cartUpdated:nil];
                                   }];
}


#pragma mark - View Controller Override Methods

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

    if (self.cartView && self.cartView.superview) {
        self.cartView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.blurView.frame.size.height);
    }
}

#pragma mark - Notification Methods

- (void)cartUpdated:(NSNotification*)noti
{
    // show message
    if (nil != noti) {
        NSNumber* reslut = (NSNumber*)noti.object;
        if ((nil != reslut)
            && (![reslut boolValue])) {
            NSString* message = [noti.userInfo objectForKey:@"msg"];

            [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:1.5f];
        }
    }

    HXSPromotionInfoModel *promotionInfoModel = [HXSDormCartManager sharedManager].promotionInfoModel;

    // update cart view's items
    [self setupCartViewItems];

    self.cartButton.roundLabel = YES;
    [self.cartButton setBadgeEdgeInsets:UIEdgeInsetsMake(20, 10, 0, 28)];
    [self.cartButton setLabelFont:[UIFont systemFontOfSize:10.0f]];
    [self.cartButton setLabelTextColor:[UIColor whiteColor]];
    [self.cartButton setLabelBackGroundColor:[UIColor colorWithRed:0.961 green:0.275 blue:0.259 alpha:1.000]];

    if (NSOrderedDescending == [promotionInfoModel.itemAmountDecNum compare:@(0.001)]) {
        [self.totalLabel setTextColor:[UIColor colorWithRGBHex:0xF54642]];
    } else {
        [self.totalLabel setTextColor:[UIColor colorWithRGBHex:0x999999]];
    }
    
    if (nil != promotionInfoModel.itemAmountDecNum) {
        [self.totalLabel setText:[promotionInfoModel.itemAmountDecNum twoDecimalPlacesString]];
    }

    if (0 < [promotionInfoModel.itemNumberIntNum intValue]) {
        self.cartButton.badgeString = [NSString stringWithFormat:@"%zd", [promotionInfoModel.itemNumberIntNum integerValue]];
    } else {
        self.cartButton.badgeString = nil;
    }

    if (0 < [promotionInfoModel.promotionTipAmountStr length]) {
        self.promotionLabel.text = promotionInfoModel.promotionTipAmountStr;
    } else {
        self.promotionLabel.text = @"";
    }

    if ((MAX(promotionInfoModel.itemAmountDecNum.doubleValue, promotionInfoModel.originAmountDecNum.doubleValue) >= self.shopEntity.minAmountFloatNum.floatValue)
        && promotionInfoModel.itemNumberIntNum.intValue > 0) {
        [self.checkoutBtn setBackgroundColor:UIColorFromRGB(0xFF9503)];
        self.checkoutBtn.enabled = YES;
        [self.checkoutBtn setTitle:@"结算" forState:UIControlStateNormal];
        [self.checkoutBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    }
    else {
        [self.checkoutBtn setBackgroundColor:[UIColor clearColor]];
        self.checkoutBtn.enabled = YES;

        if (MAX(promotionInfoModel.itemAmountDecNum.doubleValue, promotionInfoModel.originAmountDecNum.doubleValue) <= 0.00) {
            [self.checkoutBtn setTitle:[NSString stringWithFormat:@"%d 元起送", self.shopEntity.minAmountFloatNum.intValue] forState:UIControlStateDisabled];
        } else {
            [self.checkoutBtn setTitle:[NSString stringWithFormat:@"还差 %0.2f 元起送", self.shopEntity.minAmountFloatNum.floatValue - MAX(promotionInfoModel.itemAmountDecNum.doubleValue, promotionInfoModel.originAmountDecNum.doubleValue)] forState:UIControlStateDisabled];
        }
        [self.checkoutBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

        self.checkoutBtn.enabled = NO;
    }
    
    if (0 >= [[HXSDormCartManager sharedManager].cartItemsArr count]) {
        [self.listHorizontalVC.detailView.tableView reloadData];
    }
}


#pragma mark - Action Methods

- (IBAction)onClickCart:(id)sender
{
    [HXSUsageManager trackEvent:kUsageEventDormBalanceCartButton parameter:nil];

    [self tapCart:nil];
}

- (IBAction)onClickCheckOut:(id)sender
{
    [HXSUsageManager trackEvent:kUsageEventCheckout parameter:@{ @"business_type" : @"夜猫店" }];

    __weak typeof(self) weakSelf = self;
    [HXSLoginViewController showLoginController:self
                                loginCompletion:^{
                                    HXSCheckoutViewController *checkout = [HXSCheckoutViewController controllerFromXib];
                                    checkout.shopEntity = weakSelf.shopEntity;
                                    [weakSelf.navigationController pushViewController:checkout animated:YES];
                                }];
}

- (void)tapCart:(UITapGestureRecognizer*)tap
{
    if ((self.cartView && self.cartView.isAnimating)
        || (0 >= [[[HXSDormCartManager sharedManager] cartItemsArr] count])) {
        return;
    }

    if (!self.cartView || !self.cartView.superview) {

        [HXSUsageManager trackEvent:kUsageEventShoppingCartClick parameter:@{ @"business_type" : @"夜猫店" }];
        self.cartView = [HXSFloatingCartView viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.blurView.height)];

        self.cartView.cartViewDelegate = self;

        [self setupCartViewItems];

        [self.cartView show];
    }
    else {
        [self.cartView hide:YES];
    }

    [self cartUpdated:nil];
}

/**
 *  店铺名称点击
 *
 *  @param button
 */
- (void)onClickTitleView:(UIButton*)button
{
    [HXSUsageManager trackEvent:kUsageEventNavShopnameClikc parameter:@{ @"business_type" : @"夜猫店" }];

    if (self.hasDisplayShopInfoView) {
        [self.shopInfoVC dismissView];
    }
    else {
        __weak typeof(self) weakSelf = self;

        self.shopInfoVC.shopEntity = self.shopEntity;
        self.shopInfoVC.dismissShopInfoView = ^(void) {
            [weakSelf.shopInfoVC.view removeFromSuperview];
            [weakSelf.shopInfoVC removeFromParentViewController];

            [weakSelf.locationButton setImage:[UIImage imageNamed:@"xia"] forState:UIControlStateNormal];

            weakSelf.hasDisplayShopInfoView = NO;
        };
        [self addChildViewController:self.shopInfoVC];

        [self.view addSubview:self.shopInfoVC.view];

        [self.shopInfoVC.view mas_remakeConstraints:^(MASConstraintMaker* make) {
            make.edges.equalTo(self.view);
        }];

        [self.shopInfoVC didMoveToParentViewController:self];

        self.hasDisplayShopInfoView = YES;

        [self.locationButton setImage:[UIImage imageNamed:@"shang"] forState:UIControlStateNormal];
    }
}

- (IBAction)onClickOpenDormStroeBtn:(id)sender
{
    HXSLocationManager* locationMgr = [HXSLocationManager manager];
    NSString* baseURL = [[ApplicationSettings instance] registerStoreManagerBaseURL];
    NSString* url = [NSString stringWithFormat:@"%@?dormentry_id=%d", baseURL, [locationMgr.buildingEntry.dormentryIDNum intValue]];

    HXSWebViewController* webVc = [HXSWebViewController controllerFromXib];
    webVc.url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    RootViewController* tabRootCtrl = [AppDelegate sharedDelegate].rootViewController;
    UINavigationController* nav = tabRootCtrl.currentNavigationController;

    [nav pushViewController:webVc animated:YES];
}

#pragma mark - HXSFloatingCartViewDelegate

- (void)updateItem:(NSNumber*)itemIDNum quantity:(NSNumber*)quantityNum
{
    [HXSUsageManager trackEvent:kUsageEventCartChangeQuantity parameter:@{ @"business_type" : @"夜猫店" }];
    
    NSArray *itemListArr = self.listHorizontalVC.detailView.itemListArr;
    
    for (HXSDormItem *item in itemListArr) {
        if ([item.rid integerValue] == [itemIDNum integerValue]) {
            [[HXSDormCartManager sharedManager] updateItem:item quantity:[quantityNum intValue]];
            
            [self.listHorizontalVC.detailView.tableView reloadData];
            break;
        }
    }
}

- (void)clearCart
{
    [HXSUsageManager trackEvent:kUsageEventCartClearCart parameter:@{ @"business_type" : @"夜猫店" }];

    [[HXSDormCartManager sharedManager] clearCart];
}

- (void)updateProduct:(NSString*)productIDStr
             quantity:(NSNumber*)quantityNum
{
    // Do nothing.  This method is for the box.
}

#pragma mark - 下拉、隐藏效果 HXSDormListHorizontalViewControllerDelegate

- (void)showView
{
    if (self.isAnimating || !self.isHidden) {

        return;
    }

    self.isHidden = NO;

    self.isAnimating = YES;

    [self performSelector:@selector(endAnimation:) withObject:nil afterDelay:0.5];

    __weak typeof(self) weakSelf = self;

    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         weakSelf.topViewTopOffset.constant = 0;
                         [weakSelf.view layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)hideView
{
    if (self.isAnimating) {
        return;
    }

    self.isHidden = YES;

    self.isAnimating = YES;

    [self performSelector:@selector(endAnimation:) withObject:nil afterDelay:0.5];

    __weak typeof(self) weakSelf = self;

    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         weakSelf.topViewTopOffset.constant = kHeightScrollTabBar - weakSelf.noticeView.frame.size.height;
                         [weakSelf.view layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)endAnimation:(id)sender
{
    @synchronized(self)
    {

        self.isAnimating = NO;
    }
}

- (void)reloadItemList
{
    [self fetchEntryInfo];
}


#pragma mark - Fetch Dorm Entry Methods

- (void)fetchEntryInfo
{
    if (self.categoryModel) {

        if (nil == self.shopEntity) {
            [self.dontOpenView setHidden:NO];
            [self.view bringSubviewToFront:self.dontOpenView];
        }
        else {
            [self.dontOpenView setHidden:YES];
            [self.view sendSubviewToBack:self.dontOpenView];
        }
    }
}

#pragma mark - Private Methods

- (void)setupCartViewItems
{
    NSMutableArray* floatingItemsMArr = [[NSMutableArray alloc] initWithCapacity:5];

    for (HXSDormItem* item in [[HXSDormCartManager sharedManager] cartItemsArr]) {
        HXSFloatingCartEntity* entity = [[HXSFloatingCartEntity alloc] initWithCartItem:item];

        [floatingItemsMArr addObject:entity];
    }

    self.cartView.itemsArray = floatingItemsMArr;
}

- (void)saveShopEntityToCurrentEntry
{
    HXSShopManager* manager = [HXSShopManager shareManager];
    HXSDormEntry* dormEntry = [[HXSDormEntry alloc] init];
    dormEntry.shopEntity = self.shopEntity;
    
    [manager setCurrentEntry:dormEntry];
}

- (void)updateNoticeAndActivitiesView
{
    __weak typeof(self) weakSelf = self;
    [self.noticeAndActivitiesView createWithShopEntity:self.shopEntity targetMethod:^{
        [weakSelf onClickTitleView:nil];
    }];
}

#pragma mark - Setter Getter Methods

- (HXSShopInfoViewController*)shopInfoVC
{
    if (nil == _shopInfoVC) {
        _shopInfoVC = [HXSShopInfoViewController controllerFromXibWithModuleName:@"HXStoreBase"];
    }

    return _shopInfoVC;
}

- (HXSShopViewModel*)shopModel
{
    if (nil == _shopModel) {
        _shopModel = [[HXSShopViewModel alloc] init];
    }

    return _shopModel;
}


@end
