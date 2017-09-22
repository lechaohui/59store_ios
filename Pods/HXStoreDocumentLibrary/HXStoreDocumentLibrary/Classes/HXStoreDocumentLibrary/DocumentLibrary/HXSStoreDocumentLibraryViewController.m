//
//  HXSStoreDocumentLibraryViewController.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/6.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXSStoreDocumentLibraryViewController.h"
#import "HXSStoreDocumentLibraryCategoryViewController.h"
#import "HXSStoreDocumentLibraryChildCategoryViewController.h"

//views
#import "HXSStoreDocumentLibraryViewCell.h"
#import "HXSStoreDocumentLibraryCategoryView.h"
#import "HXSStoreDocumentLibraryHeaderView.h"

//model
#import "HXStoreDocumentLibraryViewModel.h"

//other
#import "HXStoreDocumentLibraryImport.h"

@interface HXSStoreDocumentLibraryViewController ()<HXSStoreDocumentLibraryCategoryViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView                *mainTableView;
@property (nonatomic, assign) NSInteger                         index;
@property (nonatomic, assign) CGFloat                           beginningOffsetY;
@property (nonatomic, strong) HXStoreDocumentLibraryViewModel   *documentViewModel;
@property (nonatomic, strong) NSMutableArray<HXStoreDocumentLibraryCategoryListModel *> *categoryArr;
@property (nonatomic, assign) BOOL                              isLoading;
@property (nonatomic, strong) NSNumber                          *currentLastIdStr;

@end

@implementation HXSStoreDocumentLibraryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableView];
    
    [self fetchCategoryListNetworkingIsNew:YES isHeaderRefresher:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
}


#pragma mark - create

+ (instancetype)createDocumentLibraryVCWithIndex:(NSInteger)index;
{
    HXSStoreDocumentLibraryViewController *vc = [HXSStoreDocumentLibraryViewController controllerFromXibWithModuleName:@"HXStoreDocumentLibrary"];
    
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
    
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSStoreDocumentLibraryViewCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([HXSStoreDocumentLibraryViewCell class])];
    WS(weakSelf);
    [_mainTableView addRefreshHeaderWithCallback:^{
        [weakSelf fetchCategoryListNetworkingIsNew:YES
                                 isHeaderRefresher:YES];
    }];
    
    [_mainTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf fetchCategoryListNetworkingIsNew:NO
                                 isHeaderRefresher:NO];
    }];
}


#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger section = 0;
    
    if(_categoryArr
       && _categoryArr.count > 0) {
        
        section = [_categoryArr count];
    }
    
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSStoreDocumentLibraryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSStoreDocumentLibraryViewCell class])
                                                                                   forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    HXStoreDocumentLibraryCategoryListModel *listModel = [_categoryArr objectAtIndex:indexPath.section];
    
    CGFloat height = [self.documentViewModel getCategoryCellHeight:listModel andIsShowAll:NO];
    
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSStoreDocumentLibraryViewCell *tempCell = (HXSStoreDocumentLibraryViewCell *)cell;
    if(tempCell.catgoryView) {
        [tempCell.catgoryView removeFromSuperview];
    }
    HXSStoreDocumentLibraryCategoryView *view = [HXSStoreDocumentLibraryCategoryView initLibraryCategoryViewWithCategoryList:[_categoryArr objectAtIndex:indexPath.section]
                                                                                                                andIsShowAll:NO];
    tempCell.catgoryView = view;
    view.delegate = self;
    
    [tempCell addSubview:view];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HXStoreDocumentLibraryCategoryListModel *modelList = [_categoryArr objectAtIndex:section];
    
    HXSStoreDocumentLibraryHeaderView *view = [HXSStoreDocumentLibraryHeaderView initDocumentLibraryHeaderViewWithTitle:modelList.categoryNameStr];

    return view;
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


#pragma mark - HXSStoreDocumentLibraryCategoryViewDelegate

- (void)categoryButtonClick:(HXStoreDocumentLibraryCategoryListModel *)listModel
                andCategory:(HXStoreDocumentLibraryCategoryModel *)model;

{
    HXSStoreDocumentLibraryChildCategoryViewController *childCategoryVC = [HXSStoreDocumentLibraryChildCategoryViewController createDocumentLibraryChiledCategorVCWithCategoryId:model.categoryIdNum
                                                                                                                                                                    andTitleName:model.categoryNameStr];
    
    [self.navigationController pushViewController:childCategoryVC animated:YES];
}


- (void)categoryMoreButtonClick:(HXStoreDocumentLibraryCategoryListModel *)listModel
{
    HXSStoreDocumentLibraryCategoryViewController *categoryVC = [HXSStoreDocumentLibraryCategoryViewController createDocumentLibraryCategorVCWithListModel:listModel];
    
    [self.navigationController pushViewController:categoryVC animated:YES];
}


#pragma mark - networking

/**
 *  获取动态分类
 *
 *  @param isNew             是否是重新刷新
 *  @param isHeaderRefresher 是否需要顶部刷新动画
 */
- (void)fetchCategoryListNetworkingIsNew:(BOOL)isNew
                       isHeaderRefresher:(BOOL)isHeaderRefresher
{
    if(_isLoading) {
        return;
    }
    _isLoading = YES;
    
    //设置最后的id参数
    NSNumber *tempCurrentLastID;
    if(_categoryArr
       && [_categoryArr count] > 0
       && !isNew) {
        tempCurrentLastID = @(_categoryArr.count);
    } else {
        tempCurrentLastID = @(0);
    }
    
    WS(weakSelf);
    if(isNew
       && !isHeaderRefresher) {
        [MBProgressHUD showInView:self.view];
    }
    [self.documentViewModel fetchDocumentCategoryListWithOffset:tempCurrentLastID
                                                       andLimit:@(DEFAULT_PAGESIZENUM)
                                                       Complete:^(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryCategoryListModel *> *modelList) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.isLoading = NO;
        if(kHXSNoError == code) {
            
            if(isNew) {
                weakSelf.categoryArr = [[NSMutableArray<HXStoreDocumentLibraryCategoryListModel *> alloc]init];
                [weakSelf.categoryArr addObjectsFromArray:modelList];
            } else {
                if(!weakSelf.categoryArr) {
                    weakSelf.categoryArr = [[NSMutableArray<HXStoreDocumentLibraryCategoryListModel *> alloc]init];
                }
                [weakSelf.categoryArr addObjectsFromArray:modelList];
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


#pragma mark - Get Set Methods

- (HXStoreDocumentLibraryViewModel *)documentViewModel
{
    if(nil == _documentViewModel) {
        _documentViewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
    }
    
    return _documentViewModel;
}

- (NSMutableArray<HXStoreDocumentLibraryCategoryListModel *> *)categoryArr
{
    if(nil == _categoryArr) {
        _categoryArr = [[NSMutableArray<HXStoreDocumentLibraryCategoryListModel *> alloc]init];
    }
    
    return _categoryArr;
}

@end
