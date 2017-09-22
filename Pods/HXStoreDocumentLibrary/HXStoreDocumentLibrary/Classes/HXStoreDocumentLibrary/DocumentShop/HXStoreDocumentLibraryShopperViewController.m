//
//  HXStoreDocumentLibraryShopperViewController.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/26.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibraryShopperViewController.h"

//vc
#import "HXStoreDocumentLibraryReviewViewController.h"

//views
#import "HXStoreDocumentLibraryShopperTableViewCell.h"

//model
#import "HXStoreDocumentLibraryViewModel.h"

//other
#import "HXStoreDocumentLibraryImport.h"

@interface HXStoreDocumentLibraryShopperViewController ()

@property (nonatomic, strong) NSString                                  *shopIDStr;
@property (weak, nonatomic) IBOutlet UITableView                        *mainTableView;
@property (nonatomic, strong) NSMutableArray                            *dataSourceArray;
@property (nonatomic, strong) HXStoreDocumentLibraryViewModel           *viewModel;
@property (nonatomic, assign) BOOL                                      isLoading;
@property (nonatomic, strong) HXSPrintListParamModel                    *listParamModel;

@end

@implementation HXStoreDocumentLibraryShopperViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initTableView];
    
    [self fetchShopperDocumentLibraryNetworkingIsNew:YES
                                   isHeaderRefresher:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

+ (instancetype)createDocumentLibraryShopperVCWithShopID:(NSString *)shopIDStr
{
    HXStoreDocumentLibraryShopperViewController *vc = [HXStoreDocumentLibraryShopperViewController controllerFromXibWithModuleName:@"HXStoreDocumentLibrary"];
    
    vc.shopIDStr = shopIDStr;
    
    return vc;
}


#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    self.navigationItem.title = @"店长私货";
}

- (void)initTableView
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"HXStoreDocumentLibrary" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXStoreDocumentLibraryShopperTableViewCell class])
                                               bundle:bundle]
         forCellReuseIdentifier:NSStringFromClass([HXStoreDocumentLibraryShopperTableViewCell class])];
    
    WS(weakSelf);
    [_mainTableView addRefreshHeaderWithCallback:^{
        [weakSelf fetchShopperDocumentLibraryNetworkingIsNew:YES
                                           isHeaderRefresher:YES];
    }];
    
    [_mainTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf fetchShopperDocumentLibraryNetworkingIsNew:NO
                                           isHeaderRefresher:NO];
    }];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger section = 0;
    
    if(_dataSourceArray
       && _dataSourceArray.count > 0) {
        section = 1;
    }
    
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = _dataSourceArray.count;
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXStoreDocumentLibraryShopperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXStoreDocumentLibraryShopperTableViewCell class])
                                                                                  forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 68.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXStoreDocumentLibraryShopperTableViewCell *tempCell = (HXStoreDocumentLibraryShopperTableViewCell *)cell;
    HXStoreDocumentLibraryDocumentModel *docModel = [_dataSourceArray objectAtIndex:indexPath.row];
    [tempCell initDocumentLibraryShopperCellWithDocModel:docModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXStoreDocumentLibraryDocumentModel *docModel = [_dataSourceArray objectAtIndex:indexPath.row];
    HXStoreDocumentLibraryReviewViewController *reviewVC = [HXStoreDocumentLibraryReviewViewController createReviewVCWithDocId:docModel.docIdStr];
    
    [self.navigationController pushViewController:reviewVC animated:YES];
}


#pragma mark - networking

- (void)fetchShopperDocumentLibraryNetworkingIsNew:(BOOL)isNew
                                 isHeaderRefresher:(BOOL)isHeaderRefresher
{
    if(_isLoading) {
        return;
    }
    _isLoading = YES;
    
    //设置最后的id参数
    if(_dataSourceArray
       && [_dataSourceArray count] > 0
       && !isNew) {
        self.listParamModel.offset = @(_dataSourceArray.count);
    } else {
        self.listParamModel.offset = @(0);
    }
    
    WS(weakSelf);
    if(isNew
       && !isHeaderRefresher) {
        [MBProgressHUD showInView:self.view];
    }
    
    [self.viewModel fetchPrintDormShopShareDocWithShopId:_shopIDStr
                                       andParamListModel:self.listParamModel
                                                complete:^(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryDocumentModel *> *array)
    {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.isLoading = NO;
        if(kHXSNoError == code) {
            
            if(isNew) {
                weakSelf.dataSourceArray = [[NSMutableArray<HXStoreDocumentLibraryDocumentModel *> alloc]init];
                [weakSelf.dataSourceArray addObjectsFromArray:array];
            } else {
                if(!weakSelf.dataSourceArray) {
                    weakSelf.dataSourceArray = [[NSMutableArray<HXStoreDocumentLibraryDocumentModel *> alloc]init];
                }
                [weakSelf.dataSourceArray addObjectsFromArray:array];
            }
            
            [weakSelf.mainTableView reloadData];
        }
        else {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:message
                                           afterDelay:1.5];
        }
        [[weakSelf.mainTableView infiniteScrollingView] stopAnimating];
        [weakSelf.mainTableView endRefreshing];
    }];
}


#pragma mark - getter

- (HXStoreDocumentLibraryViewModel *)viewModel
{
    if(nil == _viewModel) {
        _viewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
    }
    
    return _viewModel;
}

- (HXSPrintListParamModel *)listParamModel
{
    if(nil == _listParamModel) {
        _listParamModel = [HXSPrintListParamModel createDeafultParamModel];
    }
    
    return _listParamModel;
}

@end
