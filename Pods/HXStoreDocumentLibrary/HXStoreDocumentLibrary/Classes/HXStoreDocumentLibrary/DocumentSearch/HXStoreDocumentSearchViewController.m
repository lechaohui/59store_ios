//
//  HXStoreDocumentSearchViewController.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/6.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentSearchViewController.h"
#import "HXStoreDocumentLibraryReviewViewController.h"

//views
#import "HXSStoreDocumentLibraryViewCell.h"
#import "HXStoreDocumentLibrarySearchHeaderView.h"
#import "HXStoreDocumentLibrarySearchResultTableViewCell.h"
#import "HXStoreDocumentLibrarySearchInforView.h"
#import "HXStoreDocumentSearchResultViewController.h"

//model
#import "HXStoreDocumentSearchViewModel.h"
#import "HXStoreDocumentLibraryViewModel.h"

//other
#import "HXStoreDocumentLibraryImport.h"
#import "NSString+Verification.h"


typedef NS_ENUM(NSInteger, kDocumentSearchSection) {
    kDocumentSearchSectionHistory   = 0,//搜索历史
    kDocumentSearchSectionRecommend = 1//热门推荐
};

NSInteger const noSearchSectionNums = 2;

@interface HXStoreDocumentSearchViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint             *searchBarTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView                         *mainView;

@property (nonatomic, assign) BOOL                                  searchDisplayControllerActive;
@property (nonatomic, assign) BOOL                                  loading;
@property (nonatomic, strong) HXStoreDocumentSearchViewModel        *searchViewModel;
@property (nonatomic, strong) NSArray<NSString *>                   *recommendListArray;//热门推荐
@property (nonatomic, strong) NSMutableArray<HXStoreDocumentLibraryDocumentModel *>  *searchListArray;//搜索结果
@property (nonatomic, strong) HXStoreDocumentLibrarySearchInforView *searchInforNoDataView;
@property (nonatomic, strong) HXStoreDocumentLibraryViewModel       *documentViewModel;
@property (nonatomic, assign) BOOL                                  isNoNeedToSearchCurrent;//不需要即时搜索

@end

@implementation HXStoreDocumentSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fetchHotwordsNetworking];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - create

+ (instancetype)createDocumentSearchVC
{
    HXStoreDocumentSearchViewController *vc = [HXStoreDocumentSearchViewController controllerFromXibWithModuleName:@"HXStoreDocumentLibrary"];
    
    return vc;
}


#pragma mark - initial

- (void)initialSearchBar
{
    UIColor *barColor = [UIColor colorWithRGBHex:0x08A9FA];
    self.navigationController.navigationBar.barTintColor = barColor;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:barColor] forBarMetrics:UIBarMetricsDefault];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"HXStoreDocumentLibrary" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXStoreDocumentLibrarySearchResultTableViewCell class]) bundle:bundle] forCellReuseIdentifier:NSStringFromClass([HXStoreDocumentLibrarySearchResultTableViewCell class])];
    
    [self.searchDisplayController.searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.searchDisplayController.searchResultsTableView setBackgroundColor:HXS_VIEWCONTROLLER_BG_COLOR];
    
    [self.searchDisplayController.searchBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGBHex:0xE1E2E3]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.searchDisplayController.searchBar.placeholder = @"搜索你想要的文档";
    UITextField *searchField = [self.searchDisplayController.searchBar valueForKey:@"_searchField"];
    [searchField setValue:[UIColor colorWithRGBHex:0xD2D2D2] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.searchDisplayControllerActive = YES;
}


#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger section = 0;
    
    if ([self.searchDisplayController.searchBar.text trim].length > 0
        && self.searchListArray.count > 0) {
        
        section = 1;
    } else {
        if([self.recommendListArray count] > 0) {
            section ++ ;
        }
        
        if([self.searchViewModel documentSearchHistoryList]
           && [self.searchViewModel documentSearchHistoryList].count > 0) {
            section ++ ;
        }
    }
    
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if ([self.searchDisplayController.searchBar.text trim].length > 0
        && self.searchListArray.count > 0) {
        rows = [self.searchListArray count];
    } else {
        
        if([tableView numberOfSections] == noSearchSectionNums) {
            if(section == kDocumentSearchSectionHistory) {
                rows = [self.searchViewModel documentSearchHistoryList].count;
            } else if (section == kDocumentSearchSectionRecommend) {
                rows = [self.recommendListArray count];
            }
        } else if([tableView numberOfSections] == 1) {
            if(self.recommendListArray.count > 0) {
                rows = [self.recommendListArray count];
            } else if ([self.searchViewModel documentSearchHistoryList]
                       && [self.searchViewModel documentSearchHistoryList].count > 0) {
                rows = [self.recommendListArray count];
            }
            
        }
        
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXStoreDocumentLibrarySearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXStoreDocumentLibrarySearchResultTableViewCell class])
                                                                            forIndexPath:indexPath];
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0;
    if ([self.searchDisplayController.searchBar.text trim].length > 0
        && self.searchListArray.count > 0) {
        height = 0;
    } else {
        height = 44.0;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.searchDisplayController.searchBar.text trim].length > 0
        && self.searchListArray.count > 0) {
        return nil;
    } else {
        
        if([tableView numberOfSections] == noSearchSectionNums) {
            if(section == kDocumentSearchSectionHistory) {
                HXStoreDocumentLibrarySearchHeaderView *view = [HXStoreDocumentLibrarySearchHeaderView initDocumentLibrarySearchHeaderViewWithTitle:@"搜索历史"];
                
                return view;
            } else if (section == kDocumentSearchSectionRecommend) {
                HXStoreDocumentLibrarySearchHeaderView *view = [HXStoreDocumentLibrarySearchHeaderView initDocumentLibrarySearchHeaderViewWithTitle:@"热门推荐"];
                
                return view;
            }
        } else if([tableView numberOfSections] == 1) {
            if(self.recommendListArray.count > 0) {
                HXStoreDocumentLibrarySearchHeaderView *view = [HXStoreDocumentLibrarySearchHeaderView initDocumentLibrarySearchHeaderViewWithTitle:@"热门推荐"];
                
                return view;
            } else if ([self.searchViewModel documentSearchHistoryList]
                       && [self.searchViewModel documentSearchHistoryList].count > 0) {
                HXStoreDocumentLibrarySearchHeaderView *view = [HXStoreDocumentLibrarySearchHeaderView initDocumentLibrarySearchHeaderViewWithTitle:@"搜索历史"];
                
                return view;
            }
        }
    }
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXStoreDocumentLibrarySearchResultTableViewCell *tempCell = (HXStoreDocumentLibrarySearchResultTableViewCell *)cell;
    if ([self.searchDisplayController.searchBar.text trim].length > 0
        && self.searchListArray.count > 0) {
        
        [tempCell initDocumentLibrarySearchResultTableViewCellWithType:kDocumentSearchResultCellTypeMain andTitle:[[self.searchListArray objectAtIndex:indexPath.row] docTitleStr]];
        
    } else {
        if([tableView numberOfSections] == noSearchSectionNums) {
            if(indexPath.section == kDocumentSearchSectionHistory) {
                
                [tempCell initDocumentLibrarySearchResultTableViewCellWithType:kDocumentSearchResultCellTypeHistory andTitle:[self.searchViewModel documentSearchHistoryList][indexPath.row]];
                
            } else if (indexPath.section == kDocumentSearchSectionRecommend) {
                [tempCell initDocumentLibrarySearchResultTableViewCellWithType:kDocumentSearchResultCellTypeRecommend andTitle:self.recommendListArray[indexPath.row]];
            }
        } else if([tableView numberOfSections] == 1) {
            if(self.recommendListArray.count > 0) {
                [tempCell initDocumentLibrarySearchResultTableViewCellWithType:kDocumentSearchResultCellTypeRecommend andTitle:self.recommendListArray[indexPath.row]];
            } else if ([self.searchViewModel documentSearchHistoryList]
                       && [self.searchViewModel documentSearchHistoryList].count > 0) {
                [tempCell initDocumentLibrarySearchResultTableViewCellWithType:kDocumentSearchResultCellTypeHistory andTitle:[self.searchViewModel documentSearchHistoryList][indexPath.row]];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // 从搜索结果中选择
    if ([self.searchDisplayController.searchBar.text trim].length > 0
        && self.searchListArray.count > 0){
        HXStoreDocumentLibraryReviewViewController *reviewVC = [HXStoreDocumentLibraryReviewViewController createReviewVCWithDocId:[[self.searchListArray objectAtIndex:indexPath.row] docIdStr]];
        [self.navigationController pushViewController:reviewVC animated:YES];
        
    } else {
        NSString *keyWords;
        if([tableView numberOfSections] == noSearchSectionNums) {
            if(indexPath.section == kDocumentSearchSectionHistory) {
                keyWords = [self.searchViewModel documentSearchHistoryList][indexPath.row];
                [self addSearchResultViewWithKeywords:keyWords];
            } else if (indexPath.section == kDocumentSearchSectionRecommend) {
                keyWords = self.recommendListArray[indexPath.row];
                [self addSearchResultViewWithKeywords:keyWords];
            }
            
        } else if([tableView numberOfSections] == 1) {
            if(self.recommendListArray.count > 0) {
                keyWords = self.recommendListArray[indexPath.row];
                [self addSearchResultViewWithKeywords:keyWords];
            } else if ([self.searchViewModel documentSearchHistoryList]
                       && [self.searchViewModel documentSearchHistoryList].count > 0) {
                keyWords = [self.searchViewModel documentSearchHistoryList][indexPath.row];
                [self addSearchResultViewWithKeywords:keyWords];
            }
        }
    }
    
}


#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchDisplayControllerActive = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *keyWordsStr = searchBar.text.trim;
    
    if([keyWordsStr isEqualToString:@""]) {
        return;
    }
    
    if(_searchListArray
       && _searchListArray.count > 0) {
           [self addSearchResultViewWithKeywords:keyWordsStr]; 
    }
}


#pragma mark - UISearchDisplayDelegate

-(void)bringSearchResultToFront
{
    if (self.searchDisplayController.active == YES) {
        UITableView *table = self.searchDisplayController.searchResultsTableView;
        table.alpha = 1.0;
        table.hidden = NO;
        
        UIView *superView = table.superview;
        [superView bringSubviewToFront:table];
        [table reloadData];
        [self.view sendSubviewToBack:_mainView];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self searchDocumentAction];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self searchDocumentAction];
    return YES;
}

-(void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{
    [self bringSearchResultToFront];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [self bringSearchResultToFront];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    [self bringSearchResultToFront];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self setNeedsStatusBarAppearanceUpdate];
    
    for (UIView *subView in controller.searchResultsTableView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UILabel")]) {
            UILabel *label =(UILabel *)subView;
            label.text = @"";
        }
    }
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    CGFloat height = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    UITableView *tableView = [[self searchDisplayController] searchResultsTableView];
    UIEdgeInsets inset;
    [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? (inset = UIEdgeInsetsMake(0, 0, height, 0)) : (inset = UIEdgeInsetsZero);
    [tableView setContentInset:inset];
    [tableView setScrollIndicatorInsets:inset];
}


#pragma mark - Search document

- (void)searchDocumentAction
{
    if(_isNoNeedToSearchCurrent) {
        return;
    }
    [self bringSearchResultToFront];
    NSString *keyWordsStr = self.searchDisplayController.searchBar.text.trim;
    if(keyWordsStr.length == 0) {
        [self.searchListArray removeAllObjects];
        [self.searchDisplayController.searchResultsTableView setTableHeaderView:nil];
        [self.searchDisplayController.searchResultsTableView reloadData];
        return;
    } else {
        [self searchDocNetworkingWithSearchKeyWords:keyWordsStr];
    }
}


#pragma mark - networking

/**
 *  获取热门关键字
 */
- (void)fetchHotwordsNetworking
{
    [MBProgressHUD showInView:self.view];
    WS(weakSelf);
    [self.documentViewModel fetchSearchHotwordsComplete:^(HXSErrorCode code, NSString *message, NSArray<NSString *> *hotWordsArray) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if(kHXSNoError == code) {
            weakSelf.recommendListArray = hotWordsArray;
            [weakSelf.searchDisplayController.searchResultsTableView reloadData];
        } else {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:message
                                           afterDelay:1.5];
        }
        [weakSelf initialSearchBar];
        
    }];
}


/**
 *  搜索关键字网络连接
 */
- (void)searchDocNetworkingWithSearchKeyWords:(NSString *)searchKeyWordsStr
{
    if(_loading) {
        return;
    }
    
    HXStoreDocumentLibraryDocListParamModel *paramModelGood = [[HXStoreDocumentLibraryDocListParamModel alloc]init];
    paramModelGood.keywordStr = searchKeyWordsStr;
    paramModelGood.limitNum = @(DEFAULT_PAGESIZENUM);
    paramModelGood.offsetNum = @(0);
    paramModelGood.sortNum = @(HXStoreDocumentLibraryDocListTypeDefault);
    
    _loading = YES;
    [MBProgressHUD showInView:self.view];
    WS(weakSelf);
    [self.documentViewModel fetchSearchDocumentListWithParamModel:paramModelGood
                                                         Complete:^(HXSErrorCode code, NSString *message, NSArray<HXStoreDocumentLibraryDocumentModel *> *modelList) {
                                                             [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                             weakSelf.loading = NO;
                                                             if(kHXSNoError == code
                                                                && modelList.count > 0) {
                                                                 weakSelf.searchListArray = [[NSMutableArray alloc]init];
                                                                 [weakSelf.searchListArray addObjectsFromArray:modelList];
                                                                 [weakSelf.searchDisplayController.searchResultsTableView setTableHeaderView:nil];
                                                                 [weakSelf.searchDisplayController.searchResultsTableView reloadData];
                                                             }
                                                             else {
                                                                 weakSelf.searchListArray = nil;
                                                                 [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                                    status:message
                                                                                                afterDelay:1.5];
                                                                 [weakSelf.searchDisplayController.searchResultsTableView setTableHeaderView:self.searchInforNoDataView];
                                                                 [weakSelf.searchDisplayController.searchResultsTableView reloadData];
                                                             }
                                                         }];
}


#pragma mark add search Result view

/**
 *  将搜索结果界面增加到主界面
 *
 *  @param keyWordsStr
 */
- (void)addSearchResultViewWithKeywords:(NSString *)keyWordsStr
{
    HXStoreDocumentSearchResultViewController *resultVC = [HXStoreDocumentSearchResultViewController createDocumentSearchResultVCWithKeyWords:keyWordsStr];
    
    [self addChildViewController:resultVC];
    
    [_mainView addSubview:resultVC.view];
    [resultVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_mainView);
    }];
    
    [resultVC didMoveToParentViewController:self];
    
    [self.view bringSubviewToFront:_mainView];
    
    _isNoNeedToSearchCurrent = YES;
    [self.searchDisplayController.searchBar setText:keyWordsStr];
    
    [self.searchViewModel addDocumentSearchHistory:keyWordsStr];
    _isNoNeedToSearchCurrent = NO;
}

#pragma mark - getter setter

- (void)setSearchDisplayControllerActive:(BOOL)searchDisplayControllerActive
{
    _searchDisplayControllerActive = searchDisplayControllerActive;
    if(_searchDisplayControllerActive) { // 展示
        self.searchBarTopLayoutConstraint.constant = 0;
        [self.view setNeedsLayout];
        [self.searchDisplayController setActive:YES animated:YES];
    } else {
        [self.searchDisplayController setActive:NO animated:NO];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (HXStoreDocumentSearchViewModel *)searchViewModel
{
    if(nil == _searchViewModel) {
        _searchViewModel = [[HXStoreDocumentSearchViewModel alloc]init];
    }
    
    return _searchViewModel;
}

- (HXStoreDocumentLibraryViewModel *)documentViewModel
{
    if(nil == _documentViewModel) {
        _documentViewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
    }
    
    return _documentViewModel;
}

- (HXStoreDocumentLibrarySearchInforView *)searchInforNoDataView
{
    if(nil == _searchInforNoDataView) {
        _searchInforNoDataView = [HXStoreDocumentLibrarySearchInforView initDocumentLibrarySearchInforViewWithTitle:@"抱歉，未检索到相关文档"
                                                                                                  andBackGroudColor:[UIColor colorWithRGBHex:0xf6fdfe]
                                                                                                       andTextColor:[UIColor colorWithRGBHex:0x07A9FA]];
        
    }
    
    return _searchInforNoDataView;
}

@end
