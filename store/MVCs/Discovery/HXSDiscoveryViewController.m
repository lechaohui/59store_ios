//
//  HXSDiscoveryViewController.m
//  store
//
//  Created by ArthurWang on 16/9/2.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDiscoveryViewController.h"

// Contrllers

// ViewModel
#import "HXSShopViewModel.h"
#import "HXSShopViewModel.h"

// View
#import "HXSAdTableViewCell.h"
#import "HXSDiscoverTableViewCell.h"
#import "HXSPopView.h"
#import "HXSDiscoverSectionTitleCell.h"


typedef NS_ENUM(NSInteger, HXDiscoverSection)
{
    kHXDiscoverSectionAd      = 0, // 广告栏
    kHXDiscoverSectionTitle   = 1, // 约团的标题
    kHXDiscoverSectionYueTuan = 2, // 约团内容
    
    kHXDiscoverSectionCount   = 3, // Section 个数
};


static NSInteger kNormalCellHeight = 44.0f;


@interface HXSDiscoveryViewController () <UITableViewDataSource,
                                          UITableViewDelegate,
                                          HXSAdTableViewCellDelegate,
                                          HXSDiscoverTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) HXSShopViewModel *shopModel;

@property (nonatomic, strong) NSArray *adDataSource;
@property (nonatomic, strong) NSArray *titleDataSource;
@property (nonatomic, strong) NSArray *yueTuanDataSource;

@property (nonatomic, strong) HXSPopView *popView;
@property (nonatomic, strong) NSArray *tabBannerEntriesArr;



@end

@implementation HXSDiscoveryViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationbar];
    
    [self initialTableView];
    
    
    [MBProgressHUD showInView:self.view];
    [self fetchBannerData];
    
    
    [self fetchTab3Entries];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self changeNavigationBarBackgroundColor:[UIColor colorWithRGBHex:navBarWhiteBgColorValue]
                        pushBackButItemImage:[UIImage imageNamed:@"fanhui"]
                     presentBackButItemImage:[UIImage imageNamed:@"xia"]
                                  titleColor:[UIColor colorWithRGBHex:navBarWhiteTitleVolorValue]];
    
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self changeNavigationBarNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


#pragma mark - Initial Methods

- (void)initialNavigationbar
{
    self.navigationItem.title = @"发现";
    
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)initialTableView
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSDiscoverTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSDiscoverTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSAdTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSAdTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSDiscoverSectionTitleCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSDiscoverSectionTitleCell class])];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshHeaderWithCallback:^{
        [weakSelf fetchBannerData];
    }];
}


#pragma mark - Fetch Data

- (void)fetchBannerData
{
    [self fetchAdData];
}

- (void)fetchAdData
{
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSSite *site = locationMgr.currentSite;
    NSNumber *siteIdIntNum = (0 < [site.site_id integerValue]) ? site.site_id : [[ApplicationSettings instance] defaultSiteID];
    
    __weak typeof(self) weakSelf = self;
    [self.shopModel fetchStoreAppEntriesWithSiteId:siteIdIntNum
                                              type:@(kHXSStoreInletDiscoverTopNew)
                                          complete:^(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr) {
                                              
                                              weakSelf.adDataSource = entriesArr;
                                              
                                              [weakSelf fetchTitleData];
                                          }];
}

- (void)fetchTitleData
{
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSSite *site = locationMgr.currentSite;
    NSNumber *siteIdIntNum = (0 < [site.site_id integerValue]) ? site.site_id : [[ApplicationSettings instance] defaultSiteID];
    
    __weak typeof(self) weakSelf = self;
    [self.shopModel fetchStoreAppEntriesWithSiteId:siteIdIntNum
                                              type:@(kHXSStoreInletDiscoverMiddleNew)
                                          complete:^(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr) {
                                              
                                              weakSelf.titleDataSource = entriesArr;
                                              
                                              [weakSelf fetchYuetuanData];
                                          }];
}

- (void)fetchYuetuanData
{
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSSite *site = locationMgr.currentSite;
    NSNumber *siteIdIntNum = (0 < [site.site_id integerValue]) ? site.site_id : [[ApplicationSettings instance] defaultSiteID];
    
    __weak typeof(self) weakSelf = self;
    [self.shopModel fetchStoreAppEntriesWithSiteId:siteIdIntNum
                                              type:@(kHXSStoreInletDiscoverDownNew)
                                          complete:^(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr) {
                                              [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                              [weakSelf.tableView endRefreshing];
                                              
                                              if (kHXSNoError != status) {
                                                  [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                     status:message
                                                                                 afterDelay:1.5f];
                                                  
                                                  return ;
                                              }
                                              
                                              weakSelf.yueTuanDataSource = entriesArr;
                                              
                                              [weakSelf.tableView reloadData];
                                          }];
}

- (void)fetchTab3Entries
{
    WS(weakSelf);
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSSite *site = locationMgr.currentSite;
    NSNumber *siteIdIntNum = (0 < [site.site_id integerValue]) ? site.site_id : [[ApplicationSettings instance] defaultSiteID];
    
    [self.shopModel fetchStoreAppEntriesWithSiteId:siteIdIntNum
                                              type:@(kHXSStoreInletTabBarThird)
                                          complete:^(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr) {
                                              if (0 >= [entriesArr count]) {
                                                  return ;
                                              }
                                              
                                              weakSelf.tabBannerEntriesArr = entriesArr;
                                              
                                              [weakSelf displayTabBannerWithEntries];
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


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kHXDiscoverSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case kHXDiscoverSectionAd:
        {
            return (0 < [self.adDataSource count] ? 1 : 0);
        }
            break;
            
        case kHXDiscoverSectionTitle:
        {
            return (0 < [self.titleDataSource count]) ? 1 : 0;
        }
            break;
            
        case kHXDiscoverSectionYueTuan:
        {
            NSInteger remainder = [self.yueTuanDataSource count] % 2;
            return ([self.yueTuanDataSource count] / 2) + remainder; // Display two item in one line
        }
            break;
            
        default:
            break;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case kHXDiscoverSectionAd:
        {
            HXSStoreAppEntryEntity *entryEntity = [self.adDataSource firstObject];
            
            return [HXSAdTableViewCell getCellHeightWithObject:entryEntity];
        }
            break;
            
        case kHXDiscoverSectionTitle:
        {
            if (0 >= [self.titleDataSource count]) {
                return 0.1f;
            }
            
            return kNormalCellHeight;
        }
            break;
            
        case kHXDiscoverSectionYueTuan:
        {
            HXSStoreAppEntryEntity *entryEntity = [self.yueTuanDataSource firstObject];
            
            return [HXSDiscoverTableViewCell heightOfCellWithEntity:entryEntity];
        }
            break;
            
        default:
            break;
    }
    
    return kNormalCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case kHXDiscoverSectionAd:
        {
            HXSAdTableViewCell *adCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSAdTableViewCell class]) forIndexPath:indexPath];
            
            [adCell setupItemImages:self.adDataSource];
            adCell.delegate = self;
            
            cell = adCell;
        }
            break;
            
        case kHXDiscoverSectionTitle:
        {
            HXSStoreAppEntryEntity *entryEntity = [self.titleDataSource objectAtIndex:indexPath.row];
            HXSDiscoverSectionTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSDiscoverSectionTitleCell class]) forIndexPath:indexPath];
            cell.discoverSectionTitleLabel.text = entryEntity.titleStr;
            
            return cell;
        }
            break;
            
        case kHXDiscoverSectionYueTuan:
        {
            HXSDiscoverTableViewCell *yueTuanCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSDiscoverTableViewCell class]) forIndexPath:indexPath];
            
            HXSStoreAppEntryEntity *leftEntity = [self.yueTuanDataSource objectAtIndex:(indexPath.row * 2)];
            HXSStoreAppEntryEntity *rightEntity = [self.yueTuanDataSource objectAtIndex:(indexPath.row * 2 + 1)];
            
            [yueTuanCell setupCellWithLeftBanner:leftEntity
                                     rightBanner:rightEntity
                                        delegate:self];
            
            cell = yueTuanCell;
        }
            break;
            
        default:
            break;
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == kHXDiscoverSectionTitle) {
        HXSStoreAppEntryEntity *entryEntity = [self.titleDataSource objectAtIndex:indexPath.row];
        
        [self pushToVCWithLink:entryEntity.linkURLStr];
    }
}


#pragma mark - HXSAdTableViewCellDelegate

- (void)AdTableViewCellImageTaped:(NSString *)linkStr
{
    [self pushToVCWithLink:linkStr];
}

#pragma mark - HXSDiscoverTableViewCellDelegate

- (void)didSelectedLink:(NSString *)linkStr
{
    [self pushToVCWithLink:linkStr];
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


#pragma mark - Setter Methods

- (HXSShopViewModel *)shopModel
{
    if (nil == _shopModel) {
        _shopModel = [[HXSShopViewModel alloc] init];
    }
    
    return _shopModel;
}


@end
