//
//  HXSShopListViewController.m
//  store
//
//  Created by J.006 on 16/8/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintShopListViewController.h"

// Model
#import "HXSPrintModel.h"

// Views
#import "HXSPrintShopNameTableViewCell.h"
#import "HXSPrintShopNoticeTableViewCell.h"
#import "HXSPrintShopActivityTableViewCell.h"
#import "HXSLoadingView.h"
#import "UIRenderingButton.h"

// Others
#import "HXSShopManager.h"
#import "HXSPrintHeaderImport.h"
#import "HXSBuildingArea.h"
#import "HXSPrintSelectTheShop.h"
#import "HXSLocationManager.h"

// cell height
static NSInteger const kHeightShopNameCell     = 90;
static NSInteger const kHeightShopNoticeCell   = 36;
static NSInteger const kHeightShopActivityLine = 21;

@interface HXSPrintShopListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView                 *promptView;
@property (weak, nonatomic) IBOutlet UITableView            *shopTableView;

@property (nonatomic, strong) NSNumber                      *typeIntNum;
@property (nonatomic, strong) NSString                      *shopTypeNameStr;
@property (nonatomic, strong) NSArray                       *shopsDataSource;
@property (weak, nonatomic) IBOutlet UILabel                *addressContentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *topImageViewConstraint;
@property (weak, nonatomic) IBOutlet UIView                 *topView;

@end

@implementation HXSPrintShopListViewController


#pragma mark - Create

+ (instancetype)createPrintShopListVC
{
    HXSPrintShopListViewController *shopListVC = [HXSPrintShopListViewController controllerFromXibWithModuleName:@"HXStorePrint"];
    shopListVC.typeIntNum      = [NSNumber numberWithInteger:kHXSShopTypePrint];
    shopListVC.shopTypeNameStr = @"选择云印店";
    
    return shopListVC;
}


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initAddressContent];
    
    [self initTopView];

    [self initialTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.typeIntNum       = nil;
    self.shopTypeNameStr  = nil;
    
    self.shopTableView.delegate = nil;
    self.shopTableView.dataSource = nil;
}


#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    self.navigationItem.title = _shopTypeNameStr;
}

- (void)initAddressContent
{
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSBuildingArea *buildingArea   = locationMgr.currentBuildingArea;
    HXSSite *site                   = locationMgr.currentSite;
    HXSBuildingEntry *buildingEntry = locationMgr.buildingEntry;
    NSString *locationStr           = nil;
    
    if ((nil != site.name)
        && (0 < [site.name length])
        && (nil != buildingArea)
        && (0 < [buildingArea.name length])
        && (nil != buildingEntry)
        && (0 < [buildingEntry.buildingNameStr length])) {
        locationStr = [NSString stringWithFormat:@"%@%@%@", site.name, buildingArea.name, buildingEntry.buildingNameStr];
    } else {
        locationStr = @"";
    }
    
    [_addressContentLabel setText:locationStr];
}

- (void)initialTableView
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"HXStorePrint" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    [self.shopTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSPrintShopNameTableViewCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([HXSPrintShopNameTableViewCell class])];
    [self.shopTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSPrintShopNoticeTableViewCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([HXSPrintShopNoticeTableViewCell class])];
    [self.shopTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSPrintShopActivityTableViewCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([HXSPrintShopActivityTableViewCell class])];
    
    __weak typeof(self) weakSelf = self;
    [self.shopTableView addRefreshHeaderWithCallback:^{
        [weakSelf fetchShopList];
    }];
    
    [self fetchShopList];
}

/**
 *  初始化顶部view
 */
- (void)initTopView
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(onClickTopView:)];
    [_topView addGestureRecognizer:tapGesture];
}

- (void)onClickTopView:(UITapGestureRecognizer *)tap
{
    __weak __typeof(self)weakSelf = self;
    [[HXSLocationManager manager] resetPosition:PositionBuilding
                              andViewController:self
                                     completion:^{
                                         [weakSelf fetchShopList];
                                         [weakSelf initAddressContent];
                                     }];

}


#pragma mark - Target Methods

- (void)onClickCellAtIndexPath:(NSIndexPath *)indexPath
{
    HXSShopEntity *entity = [self.shopsDataSource objectAtIndex:indexPath.section];
    entity.hasExtended = !entity.hasExtended;
    
    [self.shopTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Fetch Shop List

- (void)fetchShopList
{
    __weak typeof(self) weakSelf = self;
    [HXSLoadingView showLoadingInView:self.view];
    HXSLocationManager *manager = [HXSLocationManager manager];
    
    [HXSPrintModel fetchShopListWithSiteId:manager.currentSite.site_id
                                 dormentry:manager.buildingEntry.dormentryIDNum
                                      type:self.typeIntNum
                             crossBuilding:@(1)
                                  complete:^(HXSErrorCode status, NSString *message, NSArray *shopsArr) {
                                      [HXSLoadingView closeInView:weakSelf.view];
                                      [weakSelf.shopTableView endRefreshing];
                                      
                                      if (kHXSNoError != status) {
                                          if (weakSelf.isFirstLoading) {
                                              [HXSLoadingView showLoadFailInView:weakSelf.view
                                                                           block:^{
                                                                               [weakSelf fetchShopList];
                                                                           }];
                                          } else {
                                              [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                 status:message
                                                                             afterDelay:1.5f];
                                          }
                                          
                                          return ;
                                      }
                                      
                                      weakSelf.firstLoading = NO;
                                      
                                      if (0 >= [shopsArr count]) {
                                          [self.view bringSubviewToFront:_promptView];
                                      } else {
                                          [self.view sendSubviewToBack:_promptView];
                                          
                                          weakSelf.shopsDataSource = shopsArr;
                                          
                                          [weakSelf.shopTableView reloadData];
                                      }
                                  }
     ];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.shopsDataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3; // 1 店铺信息 2 公告  3 优惠
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Shop List
    HXSShopEntity *entity = [self.shopsDataSource objectAtIndex:indexPath.section];
    
    switch (indexPath.row) {
        case 0:
            return kHeightShopNameCell; // fixed height
            break;
            
        case 1:
            if (0 < [entity.promotionsArr count]) {
                CGFloat lineHeight = [entity.promotionsArr count] * kHeightShopActivityLine;
                
                return lineHeight;
            } else{
                
                return 0.1;
            }
            
            break;
            
        case 2:
            if (entity.hasExtended) {
                int padding = 113;
                CGFloat noticeLabelHeight = [entity.noticeStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - padding, CGFLOAT_MAX)
                                                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]}
                                                                           context:nil].size.height + 26; // 26 is padding
                
                NSInteger countOfBr = [entity.noticeStr numberOfNewLine];
                
                if (0 < countOfBr) {
                    noticeLabelHeight += countOfBr * 14; // 14 is height of one line
                }
                
                return (kHeightShopNoticeCell < noticeLabelHeight) ? noticeLabelHeight: kHeightShopNoticeCell;
            } else {
                return kHeightShopNoticeCell;
            }
            
            break;
            
        default:
            break;
    }
    
    return 125;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 0.1f;
    }
    
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.row) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSPrintShopNameTableViewCell class]) forIndexPath:indexPath];
        }
            break;
            
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSPrintShopActivityTableViewCell class]) forIndexPath:indexPath];
        }
            break;
            
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSPrintShopNoticeTableViewCell class]) forIndexPath:indexPath];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSShopEntity *entity = [self.shopsDataSource objectAtIndex:indexPath.section];
    
    switch (indexPath.row) {
        case 0:
        {
            HXSPrintShopNameTableViewCell *nameCell = (HXSPrintShopNameTableViewCell *)cell;
            
            [nameCell setupCellWithEntity:entity];
            
            [nameCell.shopTypeImageView setHidden:YES];
        }
            
            break;
            
        case 1:
        {
            HXSPrintShopActivityTableViewCell *activityCell = (HXSPrintShopActivityTableViewCell *)cell;
            
            [activityCell setupCellWithEntity:entity];
        }
            
            break;
            
        case 2:
        {
            HXSPrintShopNoticeTableViewCell *noticeCell = (HXSPrintShopNoticeTableViewCell *)cell;
            
            [noticeCell setupCellWithEntity:entity];
        }
            
            break;
            
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (2 == indexPath.row) { // 公告栏
        [self onClickCellAtIndexPath:indexPath];
        
        return;
    }
    
    HXSShopEntity *entity = [self.shopsDataSource objectAtIndex:indexPath.section];
    
    if([entity.statusIntNum isEqualToNumber:[NSNumber numberWithInteger:kHXSShopStatusClosed]])
    {
        [MBProgressHUD showInViewWithoutIndicator:self.view status:@"该店铺休息中~" afterDelay:1.5];
    }
    else
    {
        [self saveShopEntityToCurrentEntry:entity]; // save entity
        if (self.delegate
            && [self.delegate respondsToSelector:@selector(selectShopEntity:)]) {
            [self.delegate selectShopEntity:entity];
        }
        [self back];
    }
}

#pragma mark - Save Shop Entity

- (void)saveShopEntityToCurrentEntry:(HXSShopEntity *)shopEntity
{
    HXSShopManager *manager = [HXSShopManager shareManager];
    HXSDormEntry *dormEntry = [[HXSDormEntry alloc] init];
    dormEntry.shopEntity = shopEntity;
    
    [manager setCurrentEntry:dormEntry];
}

#pragma mark - Setter Getter Methods



@end
