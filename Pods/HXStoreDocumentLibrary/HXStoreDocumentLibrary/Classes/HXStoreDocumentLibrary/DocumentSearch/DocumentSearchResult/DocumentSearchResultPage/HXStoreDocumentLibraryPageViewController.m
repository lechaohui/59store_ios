//
//  HXStoreDocumentLibraryPageViewController.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/7.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibraryPageViewController.h"
#import "HXSLoginViewController.h"
#import "HXStoreDocumentLibraryReviewViewController.h"

//views
#import "HXSStoreDocumentLibraryViewCell.h"
#import "HXStoreDocumentLibraryPageTableViewCell.h"
#import "HXSCustomAlertView.h"

//model
#import "HXStoreDocumentLibraryPersistencyManger.h"
#import "HXStoreDocumentLibraryViewModel.h"

//other
#import "HXStoreDocumentLibraryImport.h"
#import "AFNetworkReachabilityManager.h"


@interface HXStoreDocumentLibraryPageViewController ()

@property (weak, nonatomic) IBOutlet UITableView                        *mainTableView;
@property (nonatomic, assign) NSInteger                                 index;
@property (nonatomic, strong) NSMutableArray<HXStoreDocumentLibraryDocumentModel *> *dataSourceArray;
@property (nonatomic, strong) HXStoreDocumentLibraryDocListParamModel   *paramModel;
@property (nonatomic, assign) BOOL                                      isLoading;
@property (nonatomic, strong) HXStoreDocumentLibraryViewModel           *documentViewModel;
@property (nonatomic, assign) BOOL                                      isSearchModel;
@property (nonatomic, strong) HXStoreDocumentLibraryPersistencyManger   *persistencyManager;

@end

@implementation HXStoreDocumentLibraryPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableView];
    
    [self initialNotification];
    
    [self fetchDocumentListNetworkingIsNew:YES
                         isHeaderRefresher:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.updateSelectionTitle(self.index);
}

- (void)dealloc
{
    self.updateSelectionTitle = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - init

- (void)initTableView
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"HXStoreDocumentLibrary" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXStoreDocumentLibraryPageTableViewCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([HXStoreDocumentLibraryPageTableViewCell class])];
    
    WS(weakSelf);
    [_mainTableView addRefreshHeaderWithCallback:^{
        [weakSelf fetchDocumentListNetworkingIsNew:YES
                                 isHeaderRefresher:YES];
    }];
    
    [_mainTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf fetchDocumentListNetworkingIsNew:NO
                                 isHeaderRefresher:NO];
    }];
}

- (void)initialNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onLoginComplete:)
                                                 name:kLoginCompleted
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateDocModel:)
                                                 name:kDocumentModelUpdated
                                               object:nil];
}


#pragma mark - Notification Methods

- (void)onLoginComplete:(NSNotification *)notification
{
    [self fetchDocumentListNetworkingIsNew:YES
                         isHeaderRefresher:NO];
}

- (void)updateDocModel:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    HXStoreDocumentLibraryDocumentModel *model = [dic objectForKey:@"DocModel"];
    
    for (HXStoreDocumentLibraryDocumentModel *docModel in _dataSourceArray) {
        if([docModel.docIdStr isEqualToString:model.docIdStr]) {
            NSInteger index = [_dataSourceArray indexOfObject:docModel];
            [_dataSourceArray replaceObjectAtIndex:index withObject:model];
            [self reloadRowsWithIndex:index];
            break;
        }
    }
}


#pragma mark - create

+ (instancetype)createDocumentLibraryPageVCWithIndex:(NSInteger)index
                                       andParamModel:(HXStoreDocumentLibraryDocListParamModel *)paramModel
{
    HXStoreDocumentLibraryPageViewController *vc = [HXStoreDocumentLibraryPageViewController controllerFromXibWithModuleName:@"HXStoreDocumentLibrary"];
    
    vc.index = index;
    vc.paramModel = paramModel;
    
    return vc;
}

+ (instancetype)createDocumentLibraryPageVCWithIndex:(NSInteger)index
                                 andSearchParamModel:(HXStoreDocumentLibraryDocListParamModel *)paramModel
{
    HXStoreDocumentLibraryPageViewController *vc = [HXStoreDocumentLibraryPageViewController controllerFromXibWithModuleName:@"HXStoreDocumentLibrary"];
    
    vc.index = index;
    vc.paramModel = paramModel;
    vc.isSearchModel = YES;
    
    return vc;
}


#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if(_dataSourceArray
       && _dataSourceArray.count > 0){
        rows = _dataSourceArray.count;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXStoreDocumentLibraryPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXStoreDocumentLibraryPageTableViewCell class])
                                                                            forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 90.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXStoreDocumentLibraryPageTableViewCell *tempCell = (HXStoreDocumentLibraryPageTableViewCell *)cell;
    [tempCell initPageTableViewCellWithMode:[_dataSourceArray objectAtIndex:indexPath.row]];
    [tempCell.starButton addTarget:self
                            action:@selector(starButtonClick:)
                  forControlEvents:UIControlEventTouchUpInside];
    [tempCell.starButton setTag:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXStoreDocumentLibraryDocumentModel *model = [_dataSourceArray objectAtIndex:indexPath.row];
    
    HXStoreDocumentLibraryReviewViewController *reviewVC = [HXStoreDocumentLibraryReviewViewController createReviewVCWithDocId:model.docIdStr];
    [self.navigationController pushViewController:reviewVC animated:YES];
}


#pragma mark - networking

/**
 *  获取文档列表
 *
 *  @param isNew             是否是重新刷新
 *  @param isHeaderRefresher 是否需要顶部刷新动画
 */
- (void)fetchDocumentListNetworkingIsNew:(BOOL)isNew
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
        _paramModel.offsetNum = @(_dataSourceArray.count);
    } else {
        _paramModel.offsetNum = @(0);
    }
    
    WS(weakSelf);
    if(isNew
       && !isHeaderRefresher) {
        [MBProgressHUD showInView:self.view];
    }
    
    if(_isSearchModel) {
 
        [self.documentViewModel fetchSearchDocumentListWithParamModel:_paramModel
                                                             Complete:^(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryDocumentModel *> *modelList) {
                                                                 [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                                 weakSelf.isLoading = NO;
                                                                 if(kHXSNoError == code) {
                                                                     
                                                                     if(isNew) {
                                                                         weakSelf.dataSourceArray = [[NSMutableArray<HXStoreDocumentLibraryDocumentModel *> alloc]init];
                                                                         [weakSelf.dataSourceArray addObjectsFromArray:modelList];
                                                                     } else {
                                                                         if(!weakSelf.dataSourceArray) {
                                                                             weakSelf.dataSourceArray = [[NSMutableArray<HXStoreDocumentLibraryDocumentModel *> alloc]init];
                                                                         }
                                                                         [weakSelf.dataSourceArray addObjectsFromArray:modelList];
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

    } else {
        
        [self.documentViewModel fetchDocumentListWithParamModel:_paramModel
                                                       Complete:^(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryDocumentModel *> *modelList) {
                                                           [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                           weakSelf.isLoading = NO;
                                                           if(kHXSNoError == code) {
                                                               
                                                               if(isNew) {
                                                                   weakSelf.dataSourceArray = [[NSMutableArray<HXStoreDocumentLibraryDocumentModel *> alloc]init];
                                                                   [weakSelf.dataSourceArray addObjectsFromArray:modelList];
                                                               } else {
                                                                   if(!weakSelf.dataSourceArray) {
                                                                       weakSelf.dataSourceArray = [[NSMutableArray<HXStoreDocumentLibraryDocumentModel *> alloc]init];
                                                                   }
                                                                   [weakSelf.dataSourceArray addObjectsFromArray:modelList];
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
}


#pragma mark - Star Button Click Action

/**
 *  收藏操作
 */
- (void)starButtonClick:(UIButton *)button
{
    WS(weakSelf);
    if([HXSUserAccount currentAccount].isLogin) {
        HXStoreDocumentLibraryDocumentModel *docModel = [_dataSourceArray objectAtIndex:button.tag];
        [self.documentViewModel updateDocmentStarWithDocModelAndSaveLocal:docModel
                                                                    andVC:self
                                                              andComplete:^(HXStoreDocumentLibraryDocumentModel *docModel)
        {
            [weakSelf reloadRowsWithIndex:button.tag];
        }];
    } else {
        [HXSLoginViewController showLoginController:self
                                    loginCompletion:^{
            [weakSelf fetchDocumentListNetworkingIsNew:YES
                                     isHeaderRefresher:NO];
        }];
    }
}


#pragma mark - reload rows

- (void)reloadRowsWithIndex:(NSInteger)index
{
    NSMutableArray<NSIndexPath *> * indexPathArray = [[NSMutableArray alloc]init];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [indexPathArray addObject:indexPath];
    
    [_mainTableView beginUpdates];
    [_mainTableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    [_mainTableView endUpdates];
}


#pragma mark - Get Set Methods

- (NSMutableArray<HXStoreDocumentLibraryDocumentModel *> *)dataSourceArray
{
    if(!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray<HXStoreDocumentLibraryDocumentModel *> alloc] init];
    }
    
    return _dataSourceArray;
}

- (HXStoreDocumentLibraryViewModel *)documentViewModel
{
    if(nil == _documentViewModel) {
        _documentViewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
    }
    
    return _documentViewModel;
}

- (HXStoreDocumentLibraryPersistencyManger *)persistencyManager
{
    if(nil == _persistencyManager) {
        _persistencyManager = [[HXStoreDocumentLibraryPersistencyManger alloc]init];
    }
    
    return _persistencyManager;
}

@end
