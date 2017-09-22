//
//  HXSDocumentLibraryDiscoverViewController.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/10.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXSDocumentLibraryDiscoverViewController.h"
#import "HXSLoginViewController.h"
#import "HXStoreDocumentLibraryReviewViewController.h"

//views
#import "HXStoreDocumentLibraryPageTableViewCell.h"
#import "HXSDocumentLibraryDiscoverHeaderView.h"

//model
#import "HXStoreDocumentLibraryPersistencyManger.h"
#import "HXStoreDocumentLibraryViewModel.h"

//other
#import "HXStoreDocumentLibraryImport.h"
#import "UIButton+AdditionParam.h"
#import "UITableView+RowsSectionsTools.h"

typedef NS_ENUM(NSInteger, HXSLibraryDocumentFindingSection) {
    kHXSLibraryDocumentFindingSectionSuppose = 0,
    kHXSLibraryDocumentFindingSectionRecommend = 1,
    kHXSLibraryDocumentFindingSectionNearby = 2
};

@interface HXSDocumentLibraryDiscoverViewController ()<HXSDocumentLibraryDiscoverHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView                                     *mainTableView;
@property (nonatomic, assign) NSInteger                                              index;
@property (nonatomic, assign) CGFloat                                                beginningOffsetY;
@property (nonatomic, strong) HXStoreDocumentLibraryViewModel                        *documentViewModel;
@property (nonatomic, assign) BOOL                                                   isLoading;
@property (nonatomic, strong) NSMutableDictionary                                    *dataSourceDic;
@property (nonatomic, strong) NSArray<NSString *>                                    *findingHeaderStrArray;//发现界面的条目名称集合
@property (nonatomic, strong) NSMutableArray<NSNumber *>                             *offsetArray;
@property (nonatomic, strong) NSMutableArray<HXSDocumentLibraryDiscoverHeaderView *> *headerViewArray;
@property (nonatomic, strong) HXStoreDocumentLibraryPersistencyManger                *persistencyManager;

@end

@implementation HXSDocumentLibraryDiscoverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableView];
    
    [self initialNotification];
    
    [self fetchFindingNetworkingIsHeaderRefresher:NO];
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
    self.scrollviewScrolled   = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - create

+ (instancetype)createDocumentDiscoverVCWithIndex:(NSInteger)index;
{
    HXSDocumentLibraryDiscoverViewController *vc = [HXSDocumentLibraryDiscoverViewController controllerFromXibWithModuleName:@"HXStoreDocumentLibrary"];
    
    vc.index = index;
    
    return vc;
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
        [weakSelf fetchFindingNetworkingIsHeaderRefresher:YES];
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
    [self fetchFindingNetworkingIsHeaderRefresher:NO];
}

- (void)updateDocModel:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    HXStoreDocumentLibraryDocumentModel *model = [dic objectForKey:@"DocModel"];
    [self reloadDocModelStatusWithDoc:model];
}


#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger section = 0;
    
    if(_dataSourceDic
       && _dataSourceDic.count > 0){
        section = _dataSourceDic.count;
    }
    
    return section;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    NSArray *array = [self getDataSourceArrayWithSection:section];
    if(array) {
        rows = array.count;
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
    NSArray *dataSourceArray = [self getDataSourceArrayWithSection:indexPath.section];
    [tempCell initPageTableViewCellWithMode:[dataSourceArray objectAtIndex:indexPath.row]];
    [tempCell.starButton addTarget:self
                            action:@selector(starButtonClick:)
                  forControlEvents:UIControlEventTouchUpInside];
    [tempCell.starButton setTag:indexPath.row];
    [tempCell.starButton setSectionIndex:indexPath.section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self.headerViewArray objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *dataSourceArray = [self getDataSourceArrayWithSection:indexPath.section];
    HXStoreDocumentLibraryDocumentModel *model = [dataSourceArray objectAtIndex:indexPath.row];
    
    HXStoreDocumentLibraryReviewViewController *reviewVC = [HXStoreDocumentLibraryReviewViewController createReviewVCWithDocId:model.docIdStr];
    
    [self.navigationController pushViewController:reviewVC animated:YES];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.beginningOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (0 < scrollView.contentSize.height) {
        if (nil != self.scrollviewScrolled) {
            self.scrollviewScrolled(CGPointMake(0, scrollView.contentOffset.y - self.beginningOffsetY));
        }
    }
}


#pragma mark - HXSDocumentLibraryDiscoverHeaderViewDelegate

- (void)reloadFindingWithSection:(NSInteger)section
                      andDocList:(NSArray<HXStoreDocumentLibraryDocumentModel *> *)docList
{
    if(docList.count == 0) {
        return;
    }
    
    NSString *keyStr = [_findingHeaderStrArray objectAtIndex:section];
    NSNumber *currentOffsetNum = [_offsetArray objectAtIndex:section];
    
    [_dataSourceDic setObject:docList
                       forKey:keyStr];
    
    [_offsetArray replaceObjectAtIndex:section
                            withObject:[NSNumber numberWithInteger:[currentOffsetNum integerValue] + docList.count]];
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
    [_mainTableView reloadSections:indexSet
                  withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - HXStoreDocumentLibraryReviewViewControllerDelegate

- (void)reloadDocModelStatusWithDoc:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    for (NSArray<HXStoreDocumentLibraryDocumentModel *> *dataSourceArray in _dataSourceDic.allValues) {
        for (HXStoreDocumentLibraryDocumentModel *model in dataSourceArray) {
            if([docModel.docIdStr isEqualToString:model.docIdStr]) {
                model.isFavorNum = docModel.isFavorNum;
                model.hasRightsNum = docModel.hasRightsNum;
            }
        }
    }
    
    [_mainTableView reloadData];
}


#pragma mark - Star Button Click Action

/**
 *  收藏操作
 */
- (void)starButtonClick:(UIButton *)button
{
    NSArray *dataSourceArray = [self getDataSourceArrayWithSection:button.sectionIndex];
    WS(weakSelf);
    if([HXSUserAccount currentAccount].isLogin) {
        HXStoreDocumentLibraryDocumentModel *docModel = [dataSourceArray objectAtIndex:button.tag];
        
        [self.documentViewModel updateDocmentStarWithDocModelAndSaveLocal:docModel
                                                                    andVC:self
                                                              andComplete:^(HXStoreDocumentLibraryDocumentModel *docModel)
        {
            [_mainTableView reloadSingleRowWithRowIndex:button.tag
                                        andSectionIndex:button.sectionIndex
                                           andAnimation:UITableViewRowAnimationNone];
        }];
    } else {
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            [weakSelf fetchFindingNetworkingIsHeaderRefresher:NO];
        }];
    }
}


#pragma mark - get Datasource array

- (NSArray<HXStoreDocumentLibraryDocumentModel *> *) getDataSourceArrayWithSection:(HXSLibraryDocumentFindingSection)index
{
    NSString *keyStr = [self.findingHeaderStrArray objectAtIndex:index];
    NSArray<HXStoreDocumentLibraryDocumentModel *> *dataSourceArray = [_dataSourceDic objectForKey:keyStr];
    
    if(dataSourceArray) {
        return dataSourceArray;
    } else {
        return nil;
    }
}


#pragma mark - networking

/**
 *  获取发现的文档列表
 *
 *  @param isHeaderRefresher
 */
- (void)fetchFindingNetworkingIsHeaderRefresher:(BOOL)isHeaderRefresher
{
    if(_isLoading) {
        return;
    }
    _isLoading = YES;
    
    WS(weakSelf);
    if(!isHeaderRefresher) {
        [MBProgressHUD showInView:self.view];
    }
    
    [self.documentViewModel fetchFindingDocumentListComplete:^(HXSErrorCode code, NSString *message, NSMutableDictionary *modelList, NSMutableArray<NSString *> *tagStrArray, NSMutableArray<NSNumber *> *offsetNumsArray)
    {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.isLoading = NO;
        if(kHXSNoError == code) {
            
            weakSelf.dataSourceDic = modelList;
            weakSelf.findingHeaderStrArray = tagStrArray;
            weakSelf.offsetArray = offsetNumsArray;
            [weakSelf.mainTableView reloadData];
        }
        else {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:message
                                           afterDelay:1.5];
        }
        [weakSelf.mainTableView endRefreshing];
    }];
}


#pragma mark - Get Set Methods

- (HXStoreDocumentLibraryViewModel *)documentViewModel
{
    if(nil == _documentViewModel) {
        _documentViewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
    }
    
    return _documentViewModel;
}

- (NSMutableArray<NSNumber *> *)offsetArray
{
    if(nil == _offsetArray) {
        NSMutableArray<NSNumber *> *array = [NSMutableArray new];
        
        for (NSArray *dataSorceArray in _dataSourceDic.allValues) {
            [array addObject:@(dataSorceArray.count)];
        }
        
        _offsetArray = array;
    }
    
    return _offsetArray;
}

- (NSMutableArray<HXSDocumentLibraryDiscoverHeaderView *> *)headerViewArray
{
    if(nil == _headerViewArray) {
       _headerViewArray = [NSMutableArray new];
        
        for (NSString *title in self.findingHeaderStrArray) {
            
            NSInteger index = [_findingHeaderStrArray indexOfObject:title];
            
            NSInteger type;
            switch (index) {
                case kHXSLibraryDocumentFindingSectionSuppose:
                    
                    type = HXSDocumentLibraryDiscoverHeaderTypeSuppose;
                    
                    break;
                    
                case kHXSLibraryDocumentFindingSectionRecommend:
                    
                    type = HXSDocumentLibraryDiscoverHeaderTypeRecommend;
                    
                    break;
                    
                case kHXSLibraryDocumentFindingSectionNearby:
                    
                    type = HXSDocumentLibraryDiscoverHeaderTypeNearby;
                    
                    break;
            }
            
            HXSDocumentLibraryDiscoverHeaderView *headerView = [HXSDocumentLibraryDiscoverHeaderView initWithType:@(type)
                                                                                                        andOffset:self.offsetArray[index]
                                                                                                         andLimit:@(5)
                                                                                                         andTitle:title];
            
            headerView.delegate = self;
            
            [_headerViewArray addObject:headerView];
        }
    }
    
    return _headerViewArray;
}

- (HXStoreDocumentLibraryPersistencyManger *)persistencyManager
{
    if(nil == _persistencyManager) {
        _persistencyManager = [[HXStoreDocumentLibraryPersistencyManger alloc]init];
    }
    
    return _persistencyManager;
}

@end
