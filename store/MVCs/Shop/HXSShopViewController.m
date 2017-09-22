//
//  HXSShopViewController.m
//  store
//
//  Created by ArthurWang on 15/7/21.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSShopViewController.h"

// Controllers
#import "HXSWebViewController.h"
#import "HXSDormMainViewController.h"
#import "HXSMessageViewController.h"
#import "HXSPrintMainViewController.h"
#import "HXSSearchViewController.h"
#import "HXSXiuxianFoodViewController.h"



// Model
#import "HXSSite.h"
#import "HXSShopViewModel.h"
#import "HXSPersonal.h"
#import "HXSShop.h"
#import "HXSShoppingAddressViewModel.h"
#import "HXSUserAccountModel.h"

// Views
#import "HXSBannerLinkHeaderView.h"
#import "HXSShopNameTableViewCell.h"
#import "HXSShopNoticeTableViewCell.h"
#import "HXSShopActivityTableViewCell.h"
#import "HXSStoreAppEntryTableViewCell.h"
#import "HXSShopViewFootView.h"
#import "HXSLoadingView.h"
#import "HXSAdTableViewCell.h"
#import "HXSShopListSectionHeaderView.h"
#import "HXSAddressDecorationView.h"
#import "HXSLocationTitleView.h"
#import "HXSShopButton.h"
#import "HXSPopView.h"
#import "HXSShopLocationCell.h"
#import "HXSSignInSuccessRemindView.h"
#import "HXSFocusTableViewCell.h"
#import "HXSGoodsFreePostageCell.h"
#import "HXSLocationView.h"


// Others
#import "UINavigationBar+AlphaTransition.h"
#import "UIBarButtonItem+HXSRedPoint.h"


// cell height
static CGFloat const kHeightShopNameTableViewCell = 120.0f;

static NSString * const kUserDefaultFirstLaunchKey    = @"firstLaunch";
static NSString * const kUserDefaultAppVersionKey     = @"appVersion";

static NSString * ShopNameTableViewCell               = @"HXSShopNameTableViewCell";
static NSString * ShopNameTableViewCellIdentifier     = @"HXSShopNameTableViewCell";
static NSString * ShopNoticeTableViewCell             = @"HXSShopNoticeTableViewCell";
static NSString * ShopNoticeTableViewCellIdentifier   = @"HXSShopNoticeTableViewCell";
static NSString * ShopActivityTableViewCell           = @"HXSShopActivityTableViewCell";
static NSString * ShopActivityTableViewCellIdentifier = @"HXSShopActivityTableViewCell";
static NSString * AdTableViewCell                     = @"HXSAdTableViewCell";

/**section类型*/
typedef NS_ENUM(NSInteger, HXSShopTableSectionType)
{
    HXSShopTableSectionTypeLocationAndStoreAppEntry   = 0,
    HXSShopTableSectionTypeAd                         = 1,
    HXSShopTableSectionTypeShopList                   = 2,
    HXSShopTableSectionTypeGoodsFreePostage           = 3,
    HXSShopTableSectionTypeFocus                      = 4
    
    
    
};

@interface HXSShopViewController () <UITableViewDelegate,
                                     UITableViewDataSource,
                                     HXSStoreAppEntryTableViewCellDelegate,
                                     HXSAdTableViewCellDelegate,
                                     HXSBannerLinkHeaderViewDelegate,
                                     HXSFocusTableViewCellDelegate,
                                     HXSLocationViewDelegate,
                                     UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *shopTableView;

@property (nonatomic, strong) HXSBannerLinkHeaderView *shopHeaderView;
@property (nonatomic, strong) HXSShopViewModel        *shopModel;
@property (nonatomic, strong) NSArray                 *shopsDataSource;  // 店铺列表
@property (nonatomic, strong) NSArray                 *groupsDataSource; // 约团列表
@property (nonatomic, strong) NSArray                 *focusDataSource;  // 周围同学在关注

@property (nonatomic, strong) HXSShopViewFootView     *footView;
@property (nonatomic, strong) HXSPopView *popView;

@property (nonatomic, strong) NSArray *stopAppEntriesArr;//零食，约团，积分商城
@property (nonatomic, strong) NSArray *adAppEntriesArr;//中间的3张图片
@property (nonatomic, strong) NSArray *tabBannerEntriesArr;
//@property (nonatomic, strong) HXSLocationTitleView *locationTitleView;
@property (nonatomic, strong) HXSLocationView *locationView;

/*
 显示地址上方的坐标图片
 */
@property (nonatomic, strong) UIView *locationIconView;

/*
 用来保存当前情况下要显示的首页地址
 未登录：使用HXSLocationManager中保存的地址，HXSLocationManager没有地址，使用默认地址
 已经登录：没有收货地址或者收货地址显示不全，逻辑同上，否则使用用户收货地址
 */
@property (nonatomic, strong) HXSCity *showCity;
@property (nonatomic, strong) HXSSite *showSite;
@property (nonatomic, strong) HXSBuildingArea *showArea;
@property (nonatomic, strong) HXSBuildingEntry *showEntry;
@property (nonatomic, strong) NSString *locationShowStr;

@property (nonatomic, strong) HXSShoppingAddress *shoppingAddress; // 用户收货地址
@property (nonatomic, strong) NSNumber *siteIdIntNum;


@end

@implementation HXSShopViewController


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
            
    [self initialTableView];
    
    [self initLocationShowStr];
    
    [self initialNavigationBar];
    
    //[self initLocationIconView];
    
    [self initialKVOMethods];
    
    [self initialLocalAddress];
    
    [HXSLoadingView showLoadingInView:self.view];
    
    //加载banner
    [self fetchTab1Entries];
    
    if([HXSUserAccount currentAccount].isLogin) {
       
        //检查有没有收货地址并写下载首页数据
        [self fetchShoppingAddress];
        
        
    } else {
        
        //加载首页数据
        [self refreshSlideAndShop];
        
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    
    //[self checkTheScrollViewOffsetAndSetTheNavigationBarWithScrollView:self.shopTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    //[self.navigationController.navigationBar at_resetBackgroundColor:HXS_COLOR_MASTER translucent:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

- (void)dealloc
{
    
    [[NSUserDefaults standardUserDefaults] removeObserver:self
                                               forKeyPath:USER_DEFAULT_LOCATION_MANAGER
                                                  context:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLoginCompleted
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLogoutCompleted
                                                  object:nil];
}

#pragma mark - override

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


#pragma mark - Intial Methods

- (void)initLocationIconView
{
    self.locationIconView = [[UIView alloc]initWithFrame:CGRectMake(0, -1000, 62, 30)]; // -1000为了在位置未准确时隐藏
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.locationIconView.bounds];
    [imageView setImage:[UIImage imageNamed:@"dizhilan"]];
    [self.locationIconView addSubview:imageView];
    [self.shopTableView addSubview:self.locationIconView];
    self.locationIconView.hidden = YES;
    
}

- (void)initLocationShowStr
{
    NSString *locationStr           = nil;
    if ((nil != self.showSite.name)
        && (0 < [self.showSite.name length])
        && (nil != self.showArea)
        && (0 < [self.showArea.name length])
        && (nil != self.showEntry)
        && (0 < [self.showEntry.buildingNameStr length])) {
        locationStr = [NSString stringWithFormat:@" %@%@%@", self.showSite.name, self.showArea.name, self.showEntry.buildingNameStr];
    } else {
        locationStr = @"请选择地址";
    }
    self.locationShowStr = locationStr;
    
    
    self.locationView = [[HXSLocationView alloc] init];
    self.locationView.delegate = self;
    self.locationView.layer.cornerRadius = 10;
    self.locationView.backgroundColor = [UIColor lightGrayColor];
    self.locationView.locationStr = self.locationShowStr;
    [self.view addSubview:self.locationView];
    
//    self.locationTitleView = [[HXSLocationTitleView alloc] init];
//    self.locationTitleView.delegate = self;
//    self.locationTitleView.locationStr = self.locationShowStr;
    
}

- (void)initialNavigationBar
{
    self.navigationItem.leftBarButtonItem = nil;
    
}


- (void)initialTableView
{
    WS(weakSelf);
    
    //背景
    UIView *titleBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    titleBackView.backgroundColor=[UIColor colorWithHexString:@"fde25c"];
    [self.view addSubview:titleBackView];
    
    //搜索框
    UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(30, 20, SCREEN_WIDTH-68, 44)];
    searchBar.barStyle=UISearchBarStyleDefault;
    searchBar.placeholder=@"搜索商品:请输入关键字";
    searchBar.barTintColor=[UIColor colorWithHexString:@"ffffff"];
    searchBar.delegate=self;
    //去掉UISearchBar的背景视图
    UIView *sub=[[[searchBar.subviews firstObject] subviews] firstObject];
    [sub removeFromSuperview];
    //改变输入框颜色
    UITextField *searchTextField =(UITextField *)[[[searchBar.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor=[UIColor colorWithHexString:@"0xe4e5e6"];
    searchTextField.font=[UIFont systemFontOfSize:13];
    searchTextField.textColor=[UIColor colorWithHexString:@"0x999999"];
    [titleBackView addSubview:searchBar];
    
    //购物车图标
    UIButton *cartBut = [Maker makeBtn:CGRectMake(SCREEN_WIDTH-30, 30, 30, 30) title:nil img:@"gouwuche" font:nil target:self action:@selector(cartAction:)];
    [titleBackView addSubview:cartBut];
    
    
    
    self.shopTableView.tableFooterView = [[UIView alloc] init];
    self.shopTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.shopTableView registerNib:[UINib nibWithNibName:ShopNameTableViewCell bundle:nil]
             forCellReuseIdentifier:ShopNameTableViewCellIdentifier];
    [self.shopTableView registerNib:[UINib nibWithNibName:ShopNoticeTableViewCell bundle:nil]
             forCellReuseIdentifier:ShopNoticeTableViewCellIdentifier];
    [self.shopTableView registerNib:[UINib nibWithNibName:ShopActivityTableViewCell bundle:nil]
             forCellReuseIdentifier:ShopActivityTableViewCellIdentifier];
    [self.shopTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSStoreAppEntryTableViewCell class]) bundle:nil]
             forCellReuseIdentifier:NSStringFromClass([HXSStoreAppEntryTableViewCell class])];
    
    //中间的四张图片cell
    [self.shopTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSAdTableViewCell class]) bundle:nil]
             forCellReuseIdentifier:AdTableViewCell];
    //位置cell
    [self.shopTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSShopLocationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSShopLocationCell class])];
    
    //附近关注cell
    [self.shopTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSFocusTableViewCell class]) bundle:nil]
             forCellReuseIdentifier:NSStringFromClass([HXSFocusTableViewCell class])];
    
    [self.shopTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSGoodsFreePostageCell class]) bundle:nil]
             forCellReuseIdentifier:NSStringFromClass([HXSGoodsFreePostageCell class])];
    
    UIView *tView = [[NSBundle mainBundle]loadNibNamed:@"HXSShopTableFootView" owner:nil options:nil].lastObject;
    UIView *tableFootView = [[UIView alloc]init];
    tableFootView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 52);
    [tableFootView addSubview:tView];
    [tView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tableFootView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.shopTableView setTableFooterView:tableFootView];
    
    [self.shopTableView addRefreshHeaderWithCallback:^{
        [weakSelf userSignIn];
        [weakSelf refreshSlideAndShop];
    }];
    
}

- (void)initialKVOMethods
{
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:USER_DEFAULT_LOCATION_MANAGER
                                               options:NSKeyValueObservingOptionNew
                                               context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeLoginStatus)
                                                 name:kLoginCompleted
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeLoginStatus)
                                                 name:kLogoutCompleted
                                               object:nil];
    
}

- (void)initialLocalAddress
{
    BOOL shouldDisplayAddressVC = NO;
    
    NSString *appVersionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    BOOL isFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultFirstLaunchKey];
    if (isFirstLaunch) {
        NSString *localVersionStr = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultAppVersionKey];
        
        if (![localVersionStr isEqualToString:appVersionStr]) {
            shouldDisplayAddressVC = YES;
            
            [[NSUserDefaults standardUserDefaults] setObject:appVersionStr forKey:kUserDefaultAppVersionKey];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    } else {
        shouldDisplayAddressVC = YES;
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultFirstLaunchKey];
        
        [[NSUserDefaults standardUserDefaults] setObject:appVersionStr forKey:kUserDefaultAppVersionKey];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (shouldDisplayAddressVC) {
        HXSLocationManager *locationMgr = [HXSLocationManager manager];
        HXSBuildingEntry *building = locationMgr.buildingEntry;
        
        if (0 >= [building.dormentryIDNum integerValue]) {
            [self resetPosition];
        }
    }
}


#pragma mark - Target Methods
- (void)cartAction:(UIButton *)sender{






}
- (void)resetPosition
{
    WS(weakSelf);
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    [locationMgr resetPosition:PositionBuilding completion:^{
        [weakSelf locationChanged];
    }];
}

- (void)clickMessageBtn:(UIButton *)button
{
    NSString *title = (self.title.length > 0) ? self.title : @"";
    [HXSUsageManager trackEvent:kUsageEventMessageCenter parameter:@{@"title":title}];
    
    BOOL hasExistedMessageVC = NO;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[HXSMessageViewController class]]) {
            hasExistedMessageVC = YES;
            break;
        }
    }
    
    if (hasExistedMessageVC) {
        NSArray *controllers = self.navigationController.viewControllers;
        NSArray *result = [controllers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject isKindOfClass:[HXSMessageViewController class]];
        }]];
        
        if (result.count > 0) {
            [self.navigationController popToViewController:result[0] animated:YES];
        }
    } else {
        HXSMessageViewController *messageCenterVC = [HXSMessageViewController controllerFromXib];
        messageCenterVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:messageCenterVC animated:YES];
    }
}

- (void)openShopButtonClicked
{
    NSString *baseURL = [[ApplicationSettings instance] registerStoreManagerBaseURL];
    NSString *urlStr = [NSString stringWithFormat:@"%@?site_id=%d", baseURL, [[HXSLocationManager manager].currentSite.site_id intValue]];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self.shopModel loadWebViewControllerWith:url from:self];
    
}


#pragma mark - KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:USER_DEFAULT_LOCATION_MANAGER]) {
        [self initLocationShowStr];
    }
}


#pragma mark - Location Methods

- (void)changeLoginStatus
{
    [self initLocationShowStr];
    
    [self refreshSlideAndShop];
}

- (void)locationChanged
{
    [self initLocationShowStr];
    
    [HXSLoadingView showLoadingInView:self.view];
    
    [self refreshSlideAndShop];
}

/*
 判断是否有收货地址并且收货地址是否是完整的（从城市到楼栋的信息都有叫完整）
 完整的收货地址，将收货地址赋值为首页地址
 */
- (BOOL)shouldDealWithShoppingAddress
{
    BOOL shouldUpdateAddress = NO;
    
    if (nil == self.shoppingAddress) {
        return shouldUpdateAddress;
    }
    
    if ([self isShoppingAddressEqualToLocationAddress]) {
        return shouldUpdateAddress;
    }
    
    if(self.shoppingAddress.cityIdStr
       && self.shoppingAddress.dormentryZoneNameStr
       && self.shoppingAddress.siteIdStr
       && self.shoppingAddress.dormentryIdStr) {
        
        HXSCity *city = [[HXSCity alloc] init];
        city.city_id  = @(self.shoppingAddress.cityIdStr.integerValue);
        city.name     = self.shoppingAddress.cityNameStr;
        [HXSLocationManager manager].currentCity = city;
        
        HXSSite *site = [[HXSSite alloc] init];
        site.site_id  = @(self.shoppingAddress.siteIdStr.integerValue);
        site.name     = self.shoppingAddress.siteNameStr;
        [HXSLocationManager manager].currentSite = site;
        
        HXSBuildingArea *area = [[HXSBuildingArea alloc] init];
        area.name  = self.shoppingAddress.dormentryZoneNameStr;
        [HXSLocationManager manager].currentBuildingArea = area;
        
        HXSBuildingEntry *entry = [[HXSBuildingEntry alloc]init];
        entry.buildingNameStr   = self.shoppingAddress.dormentryNameStr;
        entry.dormentryIDNum    = @(self.shoppingAddress.dormentryIdStr.integerValue);
        [HXSLocationManager manager].buildingEntry = entry;
        
        shouldUpdateAddress = YES;
    }

    return shouldUpdateAddress;
}

- (BOOL)isShoppingAddressEqualToLocationAddress
{
    HXSCity *city = [HXSLocationManager manager].currentCity;
    HXSSite *site = [HXSLocationManager manager].currentSite;
    HXSBuildingArea *area = [HXSLocationManager manager].currentBuildingArea;
    HXSBuildingEntry *entry = [HXSLocationManager manager].buildingEntry;
    
    BOOL equal = YES;
    
    if ([city.city_id integerValue] != [self.shoppingAddress.cityIdStr integerValue]) {
        equal = NO;
    }
    
    if ([site.site_id integerValue] != [self.shoppingAddress.siteIdStr integerValue]) {
        equal = NO;
    }
    
    if (![area.name isEqualToString:self.shoppingAddress.dormentryZoneNameStr]) {
        equal = NO;
    }
    
    if ([entry.dormentryIDNum integerValue] != [self.shoppingAddress.dormentryIdStr integerValue]) {
        equal = NO;
    }
    
    return equal;
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case HXSShopTableSectionTypeLocationAndStoreAppEntry:
            //return 2;
            return 1;
            break;
        case HXSShopTableSectionTypeAd:
           
            //中间的三张图片
            return self.adAppEntriesArr.count == 0 ? 0 : 1;
            
            break;
        case HXSShopTableSectionTypeShopList:
           
            //店铺个数
            return [self.shopsDataSource count];
            
            break;
        case HXSShopTableSectionTypeGoodsFreePostage:
           
            return [self.groupsDataSource count];
            break;
        case HXSShopTableSectionTypeFocus:
            if ([self.focusDataSource count] % 2 > 0)
                return [self.focusDataSource count] / 2 + 1;
            return [self.focusDataSource count] / 2;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (HXSShopTableSectionTypeLocationAndStoreAppEntry == indexPath.section) {
        
        //banner和零食 约团等
        HXSStoreAppEntryTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSStoreAppEntryTableViewCell class])
                                                                               forIndexPath:indexPath];
        [cell setupCellWithStoreAppEntriesArr:self.stopAppEntriesArr delegate:self];
        
        return cell;
//        if (1 == indexPath.row) {
//            //banner
//            HXSStoreAppEntryTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSStoreAppEntryTableViewCell class])
//                                                                                   forIndexPath:indexPath];
//            [cell setupCellWithStoreAppEntriesArr:self.stopAppEntriesArr delegate:self];
//            return cell;
//        }
//        else {
//
        
//            HXSShopLocationCell *cell =  [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSShopLocationCell class]) forIndexPath:indexPath];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.locationShowLabel.text = self.locationShowStr;
//            
//            CGRect locationViewFrame = [cell convertRect:cell.locationIconView.frame toView:tableView];
//            
//            if(locationViewFrame.size.width <= 62) {
//                self.locationIconView.frame = locationViewFrame;
//                self.locationIconView.hidden = NO;
//                [tableView bringSubviewToFront:self.locationIconView];
//                
//            }
//            return cell;
//        }
     
      

  }
    else if (HXSShopTableSectionTypeAd == indexPath.section) {
        
        HXSAdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSAdTableViewCell class])
                                                                   forIndexPath:indexPath];
        cell.delegate = self;
        [cell setupItemImages:self.adAppEntriesArr];
        
        return cell;
        
    }
    else if (HXSShopTableSectionTypeShopList == indexPath.section) {
        
        HXSShopEntity *entity = [self.shopsDataSource objectAtIndex:indexPath.row];
        HXSShopNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShopNameTableViewCellIdentifier
                                                                         forIndexPath:indexPath];
        [cell setupCellWithEntity:entity];
        
        return cell;
        
    } else if (HXSShopTableSectionTypeGoodsFreePostage == indexPath.section) {
        
        HXSGoodsFreePostageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSGoodsFreePostageCell class]) forIndexPath:indexPath];
        
        cell.appEntryEntity = [self.groupsDataSource objectAtIndex:indexPath.row];
        
        return cell;
        
    } else if (HXSShopTableSectionTypeFocus == indexPath.section) {
        
        HXSFocusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSFocusTableViewCell class])];
        cell.delegate = self;
        
        HXSStoreAppEntryEntity *entity1 = [self.focusDataSource objectAtIndex:indexPath.row * 2];
        [cell setFouceEntity1:entity1];
        
        if (indexPath.row * 2 + 1 > self.focusDataSource.count - 1) {
            [cell setFouceEntity2:nil];
        } else {
            HXSStoreAppEntryEntity *entity2 = [self.focusDataSource objectAtIndex:indexPath.row * 2 + 1];
            [cell setFouceEntity2:entity2];
        }
        
        return cell;
    
    } else {
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCellStyleValue1"];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (HXSShopTableSectionTypeLocationAndStoreAppEntry == indexPath.section) {
        
        
      
//        if (1 == indexPath.row){
//           
//            if (0 < [self.stopAppEntriesArr count]) {
//                return kHeightEntryCell;
//            } else {
//                return 0.1f;
//            }
//        }
//        
//        return 60;
        
        if (0 < [self.stopAppEntriesArr count])
            return kHeightEntryCell;
        else
            return 0.1f;
        

    } else if (HXSShopTableSectionTypeAd == indexPath.section) {
        
       //return 80;
        return [HXSAdTableViewCell getCellHeightWithObject:self.adAppEntriesArr.firstObject];
        
        
    } else if (HXSShopTableSectionTypeShopList == indexPath.section) {
        return kHeightShopNameTableViewCell;
    } else if (HXSShopTableSectionTypeGoodsFreePostage == indexPath.section) {
        
        HXSStoreAppEntryEntity *entryEntity = [self.groupsDataSource objectAtIndex:indexPath.row];
        return (entryEntity.imageHeightIntNum.floatValue * SCREEN_WIDTH)/entryEntity.imageWidthIntNum.floatValue + 10; // 10为距离cell上下的位置
        
    } else {
        
        return 30;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
   
    if (HXSShopTableSectionTypeAd == section && self.adAppEntriesArr.count > 0) {
        
        return 40.0f;
        
    }
    if (HXSShopTableSectionTypeShopList == section && self.shopsDataSource.count > 0) {
        
        return 40.0f;
        
    } else if (HXSShopTableSectionTypeGoodsFreePostage == section && self.groupsDataSource.count > 0) {
        
        return 40.0f;
        
    } else if (HXSShopTableSectionTypeFocus == section && self.focusDataSource.count > 0) {
        
        return 40.0f;
        
    } else  {
        
        return 0.1f;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (HXSShopTableSectionTypeShopList == section) {
        return self.shopsDataSource.count > 0 ? 0.1 : 216.0f;
    }else {
        return 0.1f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    
    if (HXSShopTableSectionTypeAd == section && self.adAppEntriesArr.count > 0) {
        
        HXSShopListSectionHeaderView *shopListSectionHeaderView = [HXSShopListSectionHeaderView shopListSectionHeaderViewWithImageName:@"fujinhaodian"];
        return shopListSectionHeaderView;
        
    }
    if (HXSShopTableSectionTypeShopList == section && self.shopsDataSource.count > 0) {
        
        HXSShopListSectionHeaderView *shopListSectionHeaderView = [HXSShopListSectionHeaderView shopListSectionHeaderViewWithImageName:@"fujinhaodian"];
        return shopListSectionHeaderView;
        
    } else if (HXSShopTableSectionTypeGoodsFreePostage == section && self.groupsDataSource.count > 0) {
        
        HXSShopListSectionHeaderView *shopListSectionHeaderView = [HXSShopListSectionHeaderView shopListSectionHeaderViewWithImageName:@"baoyouhaohuo"];
        return shopListSectionHeaderView;
        
    } else if (HXSShopTableSectionTypeFocus == section && self.focusDataSource.count > 0) {
        
        HXSShopListSectionHeaderView *shopListSectionHeaderView = [HXSShopListSectionHeaderView shopListSectionHeaderViewWithImageName:@"fujintongxue"];
        return shopListSectionHeaderView;
        
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(HXSShopTableSectionTypeShopList == section) {
        
        return self.shopsDataSource.count > 0 ? nil : self.footView;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (HXSShopTableSectionTypeGoodsFreePostage == indexPath.section) {
        
        HXSStoreAppEntryEntity *entryEntity = [self.groupsDataSource objectAtIndex:indexPath.row];
        [self pushToVCWithLink:entryEntity.linkURLStr];
        
        return;
    }
    
    // Must have selected the address
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSBuildingEntry *building = locationMgr.buildingEntry;
    
    if (0 >= [building.dormentryIDNum integerValue]) {
        [self resetPosition];
        return;
    }
    
//    if (0 == indexPath.section && 0 == indexPath.row) {
//        [self changeLocation];
//        return;
//    }
    
    // Entry
    if (HXSShopTableSectionTypeAd == indexPath.section) {
        return;
    }
    
    if (HXSShopTableSectionTypeFocus == indexPath.section){
        return;
    }
    
    HXSShopEntity *entity = [self.shopsDataSource objectAtIndex:indexPath.row];
    
    switch ([entity.shopTypeIntNum integerValue]) {
        case kHXSShopTypeDorm:
        {
            [self.shopModel loadDromViewControllerWithShopEntity:entity from:self];
            
        }
            break;
            
        case kHXSShopTypeDrink:
        {
            // Do nothing
            [self.shopModel loadDrinkViewControllerWithShopEntity:entity from:self];
        }
            break;
            
        case kHXSShopTypePrint:
        {
            [self.shopModel loadPrintViewControllerWithShopEntity:entity from:self];
        }
            break;
            
        case kHXSShopTypeStore:
        {
            // Do nothing
        }
            break;
            
        default:
        {
            // Do nothing
        }
            break;
    }
}

#pragma mark - UISearchBar
//不允许编辑
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //跳转搜索界面
    HXSSearchViewController *search=[[HXSSearchViewController alloc]init];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:search animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    return NO;
    
    //HXSXiuxianFoodViewController
//    HXSXiuxianFoodViewController *search=[[HXSXiuxianFoodViewController alloc]init];
//    self.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:search animated:YES];
//    self.hidesBottomBarWhenPushed=NO;
//    return NO;
    

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

- (void)checkTheScrollViewOffsetAndSetTheNavigationBarWithScrollView:(UIScrollView *)scrollView
{
    
    
    
//    UIColor * color = [UIColor colorWithRGBHex:0xFAFBFD];
//    CGFloat offsetY = scrollView.contentOffset.y;
//    CGFloat navChangePoint = self.shopHeaderView == nil ? 0 : self.shopHeaderView.frame.size.height;
//    if (offsetY > navChangePoint) {
//        CGFloat alpha =  1 ;//MIN(1, 1 - ((navChangePoint + 64 - offsetY) / 64)); // 需要背景透明度渐变的时候使用
//        [self.navigationController.navigationBar at_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
//        self.navigationItem.titleView = self.locationTitleView;
//        
//    } else {
//        
//        [self.navigationController.navigationBar at_setBackgroundColor:[color colorWithAlphaComponent:0]];
//
//        self.navigationItem.titleView = nil;
//    }
    
}


//#pragma mark - HXSLocationTitleViewDelegate
//
//- (void)changeLocation
//{
//    [HXSUsageManager trackEvent:kChangeLocation parameter:@{}];
//    [self resetPosition];
//}

#pragma mark - HXSLocationViewDelegate
- (void)updateLocation
{
    [HXSUsageManager trackEvent:kChangeLocation parameter:@{}];
    [self resetPosition];
    
}


#pragma mark - HXSBannerLinkHeaderViewDelegate

- (void)didSelectedLink:(NSString *)linkStr
{
    BOOL shouldSelectAddress = [self shouldSelectedAddress];
    
    if (shouldSelectAddress) {
        return;
    }
    
    [self pushToVCWithLink:linkStr];
}


#pragma mark - HXSAdTableViewCellDelegate

- (void)AdTableViewCellImageTaped:(NSString *)linkStr
{
    [self pushToVCWithLink:linkStr];
}


#pragma mark - HXSStoreAppEntryTableViewCellDelegate
// 中间的零食，约团等标签
- (void)storeAppEntryTableViewCell:(HXSStoreAppEntryTableViewCell *)cell didSelectedLink:(NSString *)linkStr
{
    BOOL shouldSelectAddress = [self shouldSelectedAddress];
    
    if (shouldSelectAddress) {
        return;
    }
    
    [self pushToVCWithLink:linkStr];
    
}


#pragma mark - HXSFocusTableViewCellDelegate

- (void)foucsItemClicked:(HXSStoreAppEntryEntity *)foucsItem;
{
    BOOL shouldSelectAddress = [self shouldSelectedAddress];
    
    if (shouldSelectAddress) {
        return;
    }
    
    [self pushToVCWithLink:foucsItem.linkURLStr];
}

#pragma mark - Fetch Data

- (void)refreshSlideAndShop
{
    // 店铺首页轮播
    [self fetchDormentrySlide];
    
    // 店铺类型
    [self fetchShopList];
    // 首页的店铺入口列表
    [self fetchStoreAppEntires];
    
    //首页活动推广
    [self fetchShopAdEntires];
    
    //首页包邮好货
    [self fatchGoodsFreePostage];
    
    // 首页下方周围同学在关注
    [self fetchFocusEntires];
    
}

- (void)fetchDormentrySlide
{
    __weak typeof(self) weakSelf = self;
    
    [self.shopModel fetchStoreAppEntriesWithSiteId:self.siteIdIntNum
                                              type:@(kHXSStoreInletBanner)
                                          complete:^(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr) {
                                              if (0 < [entriesArr count]) {
                                                  HXSStoreAppEntryEntity *item = [entriesArr objectAtIndex:0];
                                                  CGSize size = CGSizeMake(item.imageWidthIntNum.floatValue, item.imageHeightIntNum.floatValue);
                                                  CGFloat scaleOfSize = size.height/size.width;
                                                  if (isnan(scaleOfSize)
                                                      || isinf(scaleOfSize)) {
                                                      scaleOfSize = 1.0;
                                                  }
                                                  
                                                  weakSelf.shopHeaderView.frame = CGRectMake(0,
                                                                                            0,
                                                                                             weakSelf.shopTableView.width,
                                                                                             200);//scaleOfSize * weakSelf.shopTableView.width
                                                  
                                                  
                                                  weakSelf.shopTableView.tableHeaderView = weakSelf.shopHeaderView;
                                                  [weakSelf.shopHeaderView setSlideItemsArray:entriesArr];
                                                  
                                                  
                                              } else {
                                                  
                                                  weakSelf.shopTableView.tableHeaderView = nil;
                                              }
                                          }];

}


- (void)fatchGoodsFreePostage
{
    __weak typeof(self) weakSelf = self;
    
    [self.shopModel fetchStoreAppEntriesWithSiteId:self.siteIdIntNum
                                              type:@(kHXSStoreInletGoodsFreePostage)
                                          complete:^(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr) {
                                              if (0 < [entriesArr count]) {
                                                  
                                                  weakSelf.groupsDataSource = entriesArr;
                                                  
                                                  NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:HXSShopTableSectionTypeGoodsFreePostage];
                                                  
                                                  [self.shopTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                                              }
                                          }];
}
//查询附近店铺列表
- (void)fetchShopList
{
    __weak typeof(self) weakSelf = self;
    
    HXSLocationManager *manager = [HXSLocationManager manager];
    NSNumber *dormentiryIDNum = (0 < [manager.buildingEntry.dormentryIDNum integerValue]) ? manager.buildingEntry.dormentryIDNum : [[ApplicationSettings instance] defaultDormentryID];
    
    [self.shopModel fetchShopListWithSiteId:self.siteIdIntNum
                                  dormentry:dormentiryIDNum
                                       type:[NSNumber numberWithInteger:kHXSShopTypeAll]
                              crossBuilding:@(1)
                                   complete:^(HXSErrorCode status, NSString *message, NSArray *shopsArr) {
                                      
                                       [weakSelf.shopTableView endRefreshing];
                                       [HXSLoadingView closeInView:weakSelf.view];
                                       
                                       if (kHXSNoError != status) {
                                           if (weakSelf.isFirstLoading) {
                                               [HXSLoadingView showLoadFailInView:weakSelf.view
                                                                            block:^{
                                                                                [weakSelf locationChanged];
                                                                            }];
                                           } else {
                                               
                                               [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                  status:message
                                                                              afterDelay:2.0f];
                                           }
                                           
                                           return ;
                                       }
                                       
                                       weakSelf.firstLoading = NO;
                                       
                                       weakSelf.shopsDataSource = shopsArr;
                      
                                       [weakSelf.shopTableView reloadData];
                                       
                                       
                                   }
     ];
    
}

//美食类型（零食，饮料，咖啡等）
- (void)fetchStoreAppEntires
{
    __weak typeof(self) weakSelf = self;
    
    [self.shopModel fetchStoreAppEntriesWithSiteId:self.siteIdIntNum
                                              type:@(kHXSStoreInletEntry)
                                          complete:^(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr) {
                                              if (kHXSNoError != status) {
                                                  [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                     status:message
                                                                                 afterDelay:1.5f];
                                                  
                                                  return ;
                                              }
                                              
                                              weakSelf.stopAppEntriesArr = entriesArr;
                                              [weakSelf.shopTableView reloadSections:[NSIndexSet indexSetWithIndex:HXSShopTableSectionTypeLocationAndStoreAppEntry]
                                                                    withRowAnimation:UITableViewRowAnimationAutomatic];
                                          }];
    
}
//中间的图画（寝室必备，吃货力推，新品必买，环球精选）
- (void)fetchShopAdEntires
{
    WS(weakSelf);

    [self.shopModel fetchStoreAppEntriesWithSiteId:self.siteIdIntNum
                                              type:@(kHXSStoreInletActivity)
                                          complete:^(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr) {
                                              if (kHXSNoError != status) {
                                                  [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                     status:message
                                                                                 afterDelay:1.5f];
                                                  
                                                  return ;
                                              }
                                              weakSelf.adAppEntriesArr = entriesArr;
                                             // DLog(@"count=%ld",entriesArr.count);
                                              
                                              [weakSelf.shopTableView reloadData];
                                              
                                          }];
    
}
//附近同学都在看的
- (void)fetchFocusEntires
{
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSSite *site = locationMgr.currentSite;
    
    if (0 >= [site.site_id integerValue]) {
        return;
    }
    
    
    WS(weakSelf);
    
    [self.shopModel fetchStoreAppEntriesWithSiteId:self.siteIdIntNum
                                              type:@(kHXSStoreInletFocus)
                                          complete:^(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr) {
                                              if (kHXSNoError != status) {
                                                  [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                     status:message
                                                                                 afterDelay:1.5f];
                                                  
                                                  return ;
                                              }
                                              weakSelf.focusDataSource = entriesArr;
                                              
                                              NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:4];
                                              [weakSelf.shopTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                                          }];
}

//banner
- (void)fetchTab1Entries
{
    WS(weakSelf);
    
    [self.shopModel fetchStoreAppEntriesWithSiteId:self.siteIdIntNum
                                              type:@(kHXSStoreInletTabBarFirst)
                                          complete:^(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr) {
                                              if (0 >= [entriesArr count]) {
                                                  return ;
                                              }
                                              
                                              weakSelf.tabBannerEntriesArr = entriesArr;
                                              
                                              [weakSelf displayTabBannerWithEntries];
                                          }];
}


- (void)fetchShoppingAddress
{
    WS(weakSelf);
    
    [HXSShoppingAddressViewModel fetchShoppingAddressComplete:^(HXSErrorCode code, NSString *message, NSArray *shoppingAddressArr) {
        
        if (kHXSNoError == code) {
            
            if (shoppingAddressArr.count > 0) {
                weakSelf.shoppingAddress = shoppingAddressArr.firstObject;
                
                if ([weakSelf shouldDealWithShoppingAddress]) {
                    [weakSelf initLocationShowStr];
                }
            }
        } else {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:message
                                           afterDelay:1.5f];
        }
        
        [weakSelf refreshSlideAndShop];
        
    }];
}

- (void)userSignIn
{
    // 用户如果登录并且没有签到，那就签到
    if([HXSUserAccount currentAccount].isLogin) {
       HXSUserBasicInfo *basicInfo = [HXSUserAccount currentAccount].userInfo.basicInfo;
        if (kHXPersonSignStatusNotSign != basicInfo.signInFlag){
            return;
        }
        WS(weakSelf);
        [HXSUserAccountModel userSignIn:^(HXSErrorCode code, NSString *message, NSDictionary *info) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(kHXSNoError == code){
            
                HXSUserBasicInfo *basicInfo = [HXSUserAccount currentAccount].userInfo.basicInfo;
                
                HXSSignInSuccessRemindView *remindView = [HXSSignInSuccessRemindView viewFromXib];
                [remindView showInView:weakSelf.view score:basicInfo.signInCreditIntNum delay:1.5];
                
                [[HXSUserAccount currentAccount].userInfo updateUserInfo];
            }
        }];
    }

}

#pragma mark - Puch To LinkStr VCs
- (BOOL)shouldSelectedAddress
{
    // Must have selected the address
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSBuildingEntry *building      = locationMgr.buildingEntry;
    
    if (0 >= [building.dormentryIDNum integerValue]) {
        [self resetPosition];
        
        return YES;
    }
    
    return NO;
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
        [weakSelf didSelectedLink:entity.linkURLStr];
    }];
}


#pragma mark - Get Set Methods

- (HXSShopViewModel *)shopModel
{
    if (nil == _shopModel) {
        _shopModel = [[HXSShopViewModel alloc] init];
    }
    
    return _shopModel;
}

- (HXSBannerLinkHeaderView *)shopHeaderView
{
    if (nil == _shopHeaderView) {
        _shopHeaderView = [[HXSBannerLinkHeaderView alloc] initHeaderViewWithDelegate:self];
    }
    
    return _shopHeaderView;
}

- (HXSShopViewFootView *)footView
{
    if(nil == _footView) {
        _footView = [HXSShopViewFootView footerView];
        [_footView.openShopButton addTarget:self action:@selector(openShopButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _footView;
}

- (NSArray *)adAppEntriesArr
{
    if (!_adAppEntriesArr)
    {
        _adAppEntriesArr = [[NSArray alloc] init];
    }
    return _adAppEntriesArr;
}

- (HXSCity *)showCity
{
    return [HXSLocationManager manager].currentCity;
}

- (HXSSite *)showSite
{
    return [HXSLocationManager manager].currentSite;
}

- (HXSBuildingArea *)showArea
{
    return [HXSLocationManager manager].currentBuildingArea;
}

- (HXSBuildingEntry *)showEntry
{
    return [HXSLocationManager manager].buildingEntry;
}

- (NSNumber *)siteIdIntNum
{
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSSite *site = locationMgr.currentSite;
    NSNumber *siteIdIntNum = (0 < [site.site_id integerValue]) ? site.site_id : [[ApplicationSettings instance] defaultSiteID];
    
    return siteIdIntNum;
}

- (void)setLocationShowStr:(NSString *)locationShowStr
{
    _locationShowStr = locationShowStr;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.shopTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
