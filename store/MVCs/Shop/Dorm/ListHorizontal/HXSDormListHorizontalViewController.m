//
//  HXSDormListHorizontalViewController.m
//  store
//
//  Created by ArthurWang on 15/11/3.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSDormListHorizontalViewController.h"

// Controllers
#import "HXSWebViewController.h"

// Model
#import "HXSShop.h"
#import "HXSShopEntity.h"
#import "HXSSnacksCategoryModelSet.h"
#import "HXSSnackListViewModel.h"
#import "HXSDormCartManager.h"

// Views
#import "HXSDormItemTableViewCell.h"
#import "HXSDormItemMaskView.h"
#import "HXSDromListDetailView.h"


static NSString *DormItemTableViewCell           = @"HXSDormItemTableViewCell";
static NSString *DormItemTableViewCellIdentifier = @"HXSDormItemTableViewCell";


static NSString * const kDormCartUpdateRid   = @"rid";
static NSString * const kDormCartUpdateCount = @"count";

@interface HXSDormListHorizontalViewController () <HXSDromListMenuViewDataSource,
                                                   HXSDromListDetailViewDelagte>

@property (nonatomic, assign) CGFloat lastPosition;
@property (nonatomic, assign) NSInteger startPage;

@property (nonatomic, assign) BOOL autoScrolling;
@property (nonatomic, strong) NSMutableArray *menuArr;

@property (nonatomic, strong) NSNumber *selectedCategoryId;
@property (nonatomic, strong) NSNumber *selectedCategoryType;


@end

@implementation HXSDormListHorizontalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.listDelegate = nil;
}

#pragma mark - Initial Methods

- (void)initialTableView
{
    self.startPage = 1;
    
    WS(weakSelf);
    
    self.detailView.delegate = self;
    self.menuView.dataSource = self;
    
    [self.detailView.tableView addRefreshHeaderWithCallback:^{
        [weakSelf updateSnackListData];
    }];
    
    [self.detailView.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreSnackListData];
    }];
    
}


#pragma mark - Fetch Data

- (void)getcatergoryFromServer
{
    [MBProgressHUD showInView:self.view];
    
    WS(weakSelf);
    [HXSSnackListViewModel fechCategoryListWith:self.shopEntity.shopIDIntNum
                                    shopType:self.shopEntity.shopTypeIntNum
                                    complete:^(HXSErrorCode status, NSString *message,
                                               HXSSnacksCategoryModelSet *snacksCategoryModelSet) {
                                        
                                        if(0 < weakSelf.menuArr.count) {
                                            [weakSelf.menuArr removeAllObjects];
                                        }
                                        [weakSelf.menuArr addObjectsFromArray:snacksCategoryModelSet.categoriesArr];
                                        [weakSelf.menuArr addObjectsFromArray:snacksCategoryModelSet.recommendedCategoriesArr];
                                        
                                        [weakSelf.menuView.tableView reloadData];
                                        
                                        weakSelf.selectedCategoryId   = nil;
                                        weakSelf.selectedCategoryType = nil;
                                        [weakSelf fetchSnackListData];
                                        
                                    }];
    
}

- (void)fetchSnackListData
{
    if ((nil == self.selectedCategoryId)
        && (nil == self.selectedCategoryType)) {
        HXSSnacksCategoryModel *snacksCategoryModel = self.menuArr.firstObject;
        
        if (nil  == snacksCategoryModel) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            return;
        }
        
        self.selectedCategoryId = snacksCategoryModel.categoryId;
        self.selectedCategoryType = snacksCategoryModel.categoryType;
    }
    
    
    [self fetchSnackListWidthCategoryId:self.selectedCategoryId
                           CategoryType:self.selectedCategoryType
                               starPage:@(self.startPage)
                             isLoadMore:NO];
    
}

- (void)fetchSnackListWidthCategoryId:(NSNumber *)categoryId
                         CategoryType:(NSNumber *)categoryType
                             starPage:(NSNumber *)starPage
                           isLoadMore:(BOOL)isLoadMore
{
    
    if(!isLoadMore) {
        [self.detailView.itemListArr removeAllObjects];
    }
    
    WS(weakSelf);
    [HXSSnackListViewModel fetchGoodsCategoryListWith:categoryId
                                               shopId:self.shopEntity.shopIDIntNum
                                         categoryType:categoryType
                                             starPage:starPage
                                           numPerPage:@(20)
                                             complete:^(HXSErrorCode status, NSString *message, NSArray *slideArr) {
                                                 [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                 [weakSelf.detailView.tableView endRefreshing];
                                                 [weakSelf.detailView.tableView.infiniteScrollingView stopAnimating];
                                                 
                                                 if (kHXSNoError != status) {
                                                     [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                        status:message
                                                                                    afterDelay:1.5f];
                                                     
                                                     return ;
                                                 }
                                                 
                                                 if(slideArr.count > 0) {
                                                     weakSelf.detailView.tableView.hidden = NO;
                                                     [weakSelf.detailView.itemListArr addObjectsFromArray:slideArr];
                                                     [weakSelf.detailView.tableView reloadData];
                                                     
                                                     [weakSelf.detailView.tableView setShowsInfiniteScrolling:YES];
                                                 } else {
                                                     if (!isLoadMore) {
                                                         weakSelf.detailView.tableView.hidden = YES;
                                                     }
                                                     
                                                     [weakSelf.detailView.tableView setShowsInfiniteScrolling:NO];
                                                 }
                                             }];
    
}


#pragma mark - Target Methods

// 下拉刷新
- (void)updateSnackListData
{
    [self.detailView.itemListArr removeAllObjects];
    self.startPage = 1;
    
    [self fetchSnackListData];
}

// 上拉加载更多
- (void)loadMoreSnackListData
{
    self.startPage++;
    
    [self fetchSnackListWidthCategoryId:self.selectedCategoryId
                           CategoryType:self.selectedCategoryType
                               starPage:@(self.startPage)
                             isLoadMore:YES];
}


#pragma mark - HXSDromListDetailViewDelagte

- (void)updateCountOfSnack:(NSNumber *)countNum inItem:(HXSDormItem *)item
{
    [MobClick event:@"dorm_add_cart" attributes:@{@"rid":[NSString stringWithFormat:@"%@", item.rid]}];
    
    [[HXSDormCartManager sharedManager] updateItem:item quantity:[countNum intValue]];
}

- (void)dormItemTableViewCellDidClickEvent:(HXSClickEvent *)event
{
    if(event.eventUrl && event.eventUrl.length > 0){
        [MobClick event:@"dorm_click_event" attributes:@{@"url":event.eventUrl}];
        
        HXSWebViewController * webViewController = [HXSWebViewController controllerFromXib];
        [webViewController setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",event.eventUrl]]];
        webViewController.title = event.title;
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}


#pragma mark - HXSDromListMenuViewDataSource

- (NSArray<HXSSnacksCategoryModel *> *)theCategoriesFromServer
{
    return self.menuArr;
}

- (void)menuView:(HXSDromListMenuView *)menuView didSelect:(NSIndexPath *)indexPath
{
    HXSSnacksCategoryModel *model = self.menuArr[indexPath.row];
    
    [self.detailView.itemListArr removeAllObjects];
    [self.detailView.tableView setContentOffset:CGPointZero animated:YES];
    
    self.selectedCategoryId   = model.categoryId;
    self.selectedCategoryType = model.categoryType;
    
    [self fetchSnackListWidthCategoryId:model.categoryId
                           CategoryType:model.categoryType
                               starPage:@(1)
                             isLoadMore:NO];

}


#pragma mark - Setter Getter
- (NSMutableArray *)menuArr
{
    if(!_menuArr) {
        _menuArr = [[NSMutableArray alloc] init];
    }
    return _menuArr;
}


- (void)setShopEntity:(HXSShopEntity *)shopEntity
{
    _shopEntity = shopEntity;
    [self getcatergoryFromServer];
    
    self.detailView.shopEntity = shopEntity;
    
}



@end
