//
//  HXSPreferredManagerController.m
//  store
//
//  Created by caixinye on 2017/9/4.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXSPreferredManagerController.h"

// Controllers
#import "HXSWebViewController.h"
#import "HXSSearchViewController.h"
#import "UdeskSearchController.h"







// Model
#import "HXSSite.h"
#import "HXSShopViewModel.h"
#import "HXSPersonal.h"
#import "HXSShop.h"
#import "HXSShoppingAddressViewModel.h"
#import "HXSUserAccountModel.h"
#import "HXSBuildingArea.h"




// Views
#import "HXSLoadingView.h"
#import "HXSPopView.h"
#import "HXSLocationTitleView.h"
#import "HXSShopsCollectionViewCell.h"
#import "HXSLocationView.h"
#import "HXSShopsLocationView.h"




// Others
#import "UINavigationBar+AlphaTransition.h"
#import "UIBarButtonItem+HXSRedPoint.h"


static NSString * const kUserDefaultFirstLaunchKey    = @"firstLaunch";
static NSString * const kUserDefaultAppVersionKey     = @"appVersion";


@interface HXSPreferredManagerController ()<UISearchBarDelegate,HXSShopsLocationViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) HXSShopViewModel        *shopModel;
@property (nonatomic, strong) NSArray                 *shopsDataSource;  // 店铺列表
//@property (nonatomic, strong) HXSLocationTitleView *locationTitleView;
@property (nonatomic, strong) HXSShopsLocationView *locationView;
/*
 显示地址上方的坐标图片
 */
@property (nonatomic, strong) UIView *locationIconView;

//bacView
@property(nonatomic,strong)UIView *bcView;

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

//collectionView
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)HXSShopsCollectionViewCell *collectionCell;

@end

@implementation HXSPreferredManagerController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initialcollectionView];
    [self initLocationShowStr];
    [self initialNavigationBar];
    //[self initLocationIconView];
    [self initialKVOMethods];
    [self initialLocalAddress];
    
    [HXSLoadingView showLoadingInView:self.view];
    
    if([HXSUserAccount currentAccount].isLogin) {
        
        //检查有没有收货地址并写下载首页数据
        [self fetchShoppingAddress];
        
    } else {
        
        //加载首页数据
        [self refreshSlideAndShop];
        
        
    }
    
    
    
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
- (void)initialcollectionView{

    WS(weakSelf);
    self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    
    
    _bcView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120+60)];
    _bcView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [self.view addSubview:_bcView];
    
    //背景
    UIView *titleBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    titleBackView.backgroundColor=[UIColor colorWithHexString:@"fde25c"];
    [_bcView addSubview:titleBackView];
    
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
    UIButton *cartBut = [Maker makeBtn:CGRectMake(SCREEN_WIDTH-35, 30, 30, 30) title:nil img:@"gouwuche" font:nil target:self action:@selector(cartAction:)];
    [titleBackView addSubview:cartBut];
    
    
    
    [self.view addSubview:self.collectionView];
    

    
    
    //xib创建的cell初始化
    //[self.collectionView registerNib:[UINib nibWithNibName:@"HXSShopsCollectionViewCell" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"ShopsCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HXSShopsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ShopsCollectionViewCell"];
    
    
    [self.collectionView addRefreshHeaderWithCallback:^{
        
        [weakSelf refreshSlideAndShop];
        
    }];
    
    
    
    
    

}
- (void)initLocationShowStr{

    NSString *locationStr           = nil;
    if ((nil != self.showSite.name)
        && (0 < [self.showSite.name length])
        && (nil != self.showArea)
        && (0 < [self.showArea.name length])
        && (nil != self.showEntry)
        && (0 < [self.showEntry.buildingNameStr length])) {
        locationStr = [NSString stringWithFormat:@"%@%@%@", self.showSite.name, self.showArea.name, self.showEntry.buildingNameStr];
    } else {
        locationStr = @"请选择地址";
    }
    self.locationShowStr = locationStr;
    
    
    //地址的图片
    self.locationIconView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 60)]; // -1000为了在位置未准确时隐藏
    self.locationIconView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-55)/2.0, -13, 55, 28)];
    [imageView setImage:[UIImage imageNamed:@"dizhilan"]];
    [self.locationIconView addSubview:imageView];
    [_bcView addSubview:self.locationIconView];
    
    //locationTitle
//    self.locationTitleView = [[HXSLocationTitleView alloc] init];
//    self.locationTitleView.delegate = self;
//    self.locationTitleView.locationStr = self.locationShowStr;
//    [self.locationIconView addSubview:self.locationTitleView];
   
    self.locationView = [[HXSShopsLocationView alloc] init];
    self.locationView.delegate = self;
    self.locationView.layer.cornerRadius = 5;
    self.locationView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    self.locationView.locationStr = self.locationShowStr;
    [_bcView addSubview:self.locationView];
    

}
- (void)initLocationIconView
{
    self.locationIconView = [[UIView alloc]initWithFrame:CGRectMake(0, -1000, 62, 30)]; // -1000为了在位置未准确时隐藏
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.locationIconView.bounds];
    [imageView setImage:[UIImage imageNamed:@"dizhilan"]];
    [self.locationIconView addSubview:imageView];
    //[self.shopTableView addSubview:self.locationIconView];
    self.locationIconView.hidden = YES;
    
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
- (void)initialNavigationBar
{
    self.navigationItem.leftBarButtonItem = nil;
    
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
#pragma mark - override

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

#pragma mark - Target Methods
- (void)cartAction:(UIButton *)sender{






}

#pragma mark - UISearchBar
//不允许编辑
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{

    //跳转搜索界面
    HXSSearchViewController *search=[[HXSSearchViewController alloc]init];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:search animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    return NO;

}

#pragma mark - HXSLocationViewDelegate
- (void)doUpdateLocation
{
    [HXSUsageManager trackEvent:kChangeLocation parameter:@{}];
    [self resetPosition];
    
}
- (void)resetPosition
{
    WS(weakSelf);
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    [locationMgr resetPosition:PositionBuilding completion:^{
        [weakSelf locationChanged];
    }];
}
- (void)locationChanged
{
    [self initLocationShowStr];
    
    [HXSLoadingView showLoadingInView:self.view];
    
    [self refreshSlideAndShop];
}

#pragma mark - Fetch Data
//查询附近店铺列表
- (void)refreshSlideAndShop{

    __weak typeof(self) weakSelf = self;
    HXSLocationManager *manager = [HXSLocationManager manager];
    NSNumber *dormentiryIDNum = (0 < [manager.buildingEntry.dormentryIDNum integerValue]) ? manager.buildingEntry.dormentryIDNum : [[ApplicationSettings instance] defaultDormentryID];
    [self.shopModel fetchShopListWithSiteId:self.siteIdIntNum
                                  dormentry:dormentiryIDNum
                                       type:[NSNumber numberWithInteger:kHXSShopTypeAll]
                              crossBuilding:@(1)
                                   complete:^(HXSErrorCode status, NSString *message, NSArray *shopsArr) {
                                       
                                       [weakSelf.collectionView endRefreshing];
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
                                       
                                       [weakSelf.collectionView reloadData];
                                       
                                       
                                   }
     
     ];
    
    



}
- (UICollectionView *)collectionView{

    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 60);
        layout.minimumInteritemSpacing = 5;// 垂直方向的间距
        layout.minimumLineSpacing = 5; // 水平方向的间距
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 120+60+10, SCREEN_WIDTH-20, SCREEN_HEIGHT-120-60-10-44) collectionViewLayout:layout];
        
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        
    }
    
    return _collectionView;


}
#pragma mark -- UICollectionViewDataSource
/** 每组cell的个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    //店铺个数
    return [self.shopsDataSource count];
   // return 20;
    
}
/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
        
        HXSShopsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShopsCollectionViewCell" forIndexPath:indexPath];
//        if (cell==nil) {
//            
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"HXSShopsCollectionViewCell" owner:self options:nil] lastObject];
//            
//        }
        cell.layer.cornerRadius = 5;
        cell.backgroundColor = [UIColor whiteColor];
        HXSShopEntity *model = self.shopsDataSource[indexPath.row];
        [cell setupCellWithEntity:model];
        
        
        
        return cell;
        
    
    
        
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (SCREEN_WIDTH-30)/2.0;
    CGFloat height = 150;
    
    return CGSizeMake(width, height);
    
}
/*
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identi = @"header";
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identi forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor clearColor];
        
        
        
        reusableview = headerView;
        

        
    }
    
    return reusableview;

}*/


#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"点击了第 %zd组 第%zd个",indexPath.section, indexPath.row);
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    HXSShopEntity *entity = [self.shopsDataSource objectAtIndex:indexPath.row];
    [self.shopModel loadDromViewControllerWithShopEntity:entity from:self];
    
}
#pragma mark - Get Set Methods

- (HXSShopViewModel *)shopModel
{
    if (nil == _shopModel) {
        _shopModel = [[HXSShopViewModel alloc] init];
    }
    
    return _shopModel;
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
    
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collectionView reloadData];
    
    
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
@end
