//
//  HXStoreDocumentLibraryBuyedViewController.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/26.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibraryBuyedViewController.h"

//vc
#import "HXStoreDocumentLibraryReviewViewController.h"

//views
#import "HXStoreDocumentLibraryBuyedTableViewCell.h"

//model
#import "HXStoreDocumentLibraryViewModel.h"

//other
#import "HXStoreDocumentLibraryImport.h"

@interface HXStoreDocumentLibraryBuyedViewController ()

@property (weak, nonatomic) IBOutlet UITableView                                    *mainTableView;
@property (weak, nonatomic) IBOutlet UIImageView                                    *noDateImageView;
@property (weak, nonatomic) IBOutlet UILabel                                        *noDateLabel;
@property (nonatomic, strong) NSMutableArray<HXStoreDocumentLibraryDocumentBuyedModel *> *dataSourceArray;
@property (nonatomic, strong) HXStoreDocumentLibraryViewModel                       *viewModel;
@property (nonatomic, assign) BOOL                                                  isLoading;
@property (nonatomic, strong) HXSPrintListParamModel                                *listParamModel;

@end

@implementation HXStoreDocumentLibraryBuyedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationBar];
    
    [self initTableView];
    
    [self fetchBuyedDocumentLibraryListNetworkingIsNew:YES
                                     isHeaderRefresher:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - create

+ (instancetype)createDocumentLibraryBuyedVC
{
    HXStoreDocumentLibraryBuyedViewController *vc = [HXStoreDocumentLibraryBuyedViewController controllerFromXibWithModuleName:@"HXStoreDocumentLibrary"];
    
    return vc;
}

#pragma mark - init

- (void)initNavigationBar
{
    [self.navigationItem setTitle:@"已购文档"];
}

- (void)initTableView
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"HXStoreDocumentLibrary" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXStoreDocumentLibraryBuyedTableViewCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([HXStoreDocumentLibraryBuyedTableViewCell class])];
    
    WS(weakSelf);
    [_mainTableView addRefreshHeaderWithCallback:^{
        [self fetchBuyedDocumentLibraryListNetworkingIsNew:YES
                                         isHeaderRefresher:YES];
    }];
    
    [_mainTableView addInfiniteScrollingWithActionHandler:^{
        [self fetchBuyedDocumentLibraryListNetworkingIsNew:NO
                                         isHeaderRefresher:NO];
    }];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_dataSourceArray
       && _dataSourceArray.count >0) {
        return 1;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXStoreDocumentLibraryBuyedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXStoreDocumentLibraryBuyedTableViewCell class])
                                                                                  forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 56.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXStoreDocumentLibraryBuyedTableViewCell *tempCell = (HXStoreDocumentLibraryBuyedTableViewCell *)cell;
    HXStoreDocumentLibraryDocumentBuyedModel *docModel = [_dataSourceArray objectAtIndex:indexPath.row];
    [tempCell initDocumentLibraryBuyedCellWithDocModel:docModel];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXStoreDocumentLibraryDocumentBuyedModel *docModel = [_dataSourceArray objectAtIndex:indexPath.row];
    HXStoreDocumentLibraryReviewViewController *reviewVC = [HXStoreDocumentLibraryReviewViewController createReviewVCWithDocId:docModel.docIdStr];
    
    [self.navigationController pushViewController:reviewVC animated:YES];
}


#pragma mark - networking

- (void)fetchBuyedDocumentLibraryListNetworkingIsNew:(BOOL)isNew
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
    
    [self.viewModel fetchPrintBuyedDocsListWithParamListModel:self.listParamModel
                                                     Complete:^(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryDocumentBuyedModel *> *array)
    {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.isLoading = NO;
        if(kHXSNoError == code) {
            
            if(isNew) {
                weakSelf.dataSourceArray = [[NSMutableArray<HXStoreDocumentLibraryDocumentBuyedModel *> alloc]init];
                [weakSelf.dataSourceArray addObjectsFromArray:array];
            } else {
                if(!weakSelf.dataSourceArray) {
                    weakSelf.dataSourceArray = [[NSMutableArray<HXStoreDocumentLibraryDocumentBuyedModel *> alloc] init];
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
        
        [weakSelf setNoDataStatus];
    }];
}


#pragma mark - set No data show

- (void)setNoDataStatus
{
    if(!_dataSourceArray
       || _dataSourceArray.count == 0) {
        [_noDateLabel       setHidden:NO];
        [_noDateImageView   setHidden:NO];
        [_mainTableView     setHidden:YES];
    } else {
        [_noDateLabel       setHidden:YES];
        [_noDateImageView   setHidden:YES];
        [_mainTableView     setHidden:NO];
    }
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
