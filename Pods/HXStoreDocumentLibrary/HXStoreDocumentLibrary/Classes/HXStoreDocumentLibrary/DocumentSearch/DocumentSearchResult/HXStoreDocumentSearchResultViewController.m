//
//  HXStoreDocumentSearchResultViewController.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/7.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentSearchResultViewController.h"

//vc
#import "HXStoreDocumentLibraryPageViewController.h"

//views
#import "HXSelectionControl.h"

//model
#import "HXStoreDocumentLibraryViewModel.h"
#import "HXStoreDocumentLibraryDocListParamModel.h"

//other
#import "HXStoreDocumentLibraryImport.h"

@interface HXStoreDocumentSearchResultViewController ()<UIPageViewControllerDelegate,
                                                        UIPageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet HXSelectionControl      *scrollabelTabBar;
@property (weak, nonatomic) IBOutlet UIView                  *mainView;
@property (nonatomic, strong) UIPageViewController           *pageController;
@property (nonatomic, strong) NSMutableArray                 *pageViewControllersArr;
@property (nonatomic, assign) NSInteger                      currentPage;//当前选择的tab栏索引
@property (nonatomic, strong) NSString                       *searchWords;

@end

@implementation HXStoreDocumentSearchResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initScrollabelTabBar];
    
    [self initialPageViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - create

+ (instancetype)createDocumentSearchResultVCWithKeyWords:(NSString *)keyWordsStr;
{
    HXStoreDocumentSearchResultViewController *vc = [HXStoreDocumentSearchResultViewController controllerFromXibWithModuleName:@"HXStoreDocumentLibrary"];
    
    vc.searchWords = keyWordsStr;
    
    return vc;
}

#pragma mark - init

- (void)initScrollabelTabBar
{
    [_scrollabelTabBar setTitles:@[@"相关",@"热门",@"好评",@"最新"]];
    [_scrollabelTabBar addTarget:self
                          action:@selector(selectItemAction:)
                forControlEvents:UIControlEventValueChanged];
    [_scrollabelTabBar setSelectedIdx:0];
}

- (void)initialPageViewController
{
    if (nil != self.pageController) {
        [self.pageController.view removeFromSuperview];
        [self.pageController removeFromParentViewController];
        self.pageController = nil;
    }
    
    NSNumber *spineLocationNumber = [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMax];
    NSDictionary *options = [NSDictionary dictionaryWithObject:spineLocationNumber
                                                        forKey:UIPageViewControllerOptionSpineLocationKey];
    _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                      navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                    options:options];
    _pageController.view.backgroundColor = [UIColor colorWithRGBHex:0xf4f5f6];
    _pageController.delegate = self;
    _pageController.dataSource = self;
    [self addChildViewController:_pageController];
    
    [_mainView addSubview:self.pageController.view];
    [self.pageController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_mainView);
    }];
    
    UIViewController *initialVC = [self viewControllerAtIndex:0]; // deafult is first one
    NSArray *array = [NSArray arrayWithObjects:initialVC, nil];
    [_pageController setViewControllers:array
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:YES
                             completion:nil];
}


#pragma mark - UIPageViewControllerDelegate, UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    
    if ((0 == index)
        || (NSNotFound == index)) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    
    if (NSNotFound == index) {
        return nil;
    }
    
    index++;
    
    if (index >= [self.pageViewControllersArr count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (NSUInteger)indexOfViewController:(UIViewController *)viewController
{
    return [self.pageViewControllersArr indexOfObject:viewController];
}


#pragma mark - Create VCs

- (UIViewController *)viewControllerAtIndex:(NSInteger)index
{
    if (index >= [self.pageViewControllersArr count]) {
        return nil;
    }
    
    UIViewController *viewController = [self.pageViewControllersArr objectAtIndex:index];
    
    return viewController;
}


#pragma mark - Target Methods

- (void)selectItemAction:(HXSelectionControl *)sender
{
    NSInteger index = sender.selectedIdx;
    
    NSArray *array = [NSArray arrayWithObjects:[self viewControllerAtIndex:index], nil];
    
    if (0 >= [array count]) {
        return; // Do nothing
    }
    
    if (self.currentPage > index) {
        [self.pageController setViewControllers:array
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:YES
                                     completion:nil];
    } else {
        [self.pageController setViewControllers:array
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    }
    
}


#pragma mark - getter setter

- (NSMutableArray *)pageViewControllersArr
{
    if(nil == _pageViewControllersArr) {
        
        _pageViewControllersArr = [[NSMutableArray alloc]init];
        __weak typeof(self) weakSelf = self;
        
        HXStoreDocumentLibraryDocListParamModel *paramModelAbout = [[HXStoreDocumentLibraryDocListParamModel alloc]init];
        paramModelAbout.keywordStr = _searchWords;
        paramModelAbout.limitNum = @(DEFAULT_PAGESIZENUM);
        paramModelAbout.offsetNum = @(0);
        paramModelAbout.sortNum = @(HXStoreDocumentLibraryDocListTypeDefault);
        
        HXStoreDocumentLibraryPageViewController *documentSearchResultVC1 = [HXStoreDocumentLibraryPageViewController createDocumentLibraryPageVCWithIndex:0 andSearchParamModel:paramModelAbout];
        documentSearchResultVC1.updateSelectionTitle = ^(NSInteger index) {
            [weakSelf.scrollabelTabBar setSelectedIdx:index];
            weakSelf.currentPage = index;
        };
        [_pageViewControllersArr addObject:documentSearchResultVC1];
        
        HXStoreDocumentLibraryDocListParamModel *paramModelHot = [[HXStoreDocumentLibraryDocListParamModel alloc]init];
        paramModelHot.keywordStr = _searchWords;
        paramModelHot.limitNum = @(DEFAULT_PAGESIZENUM);
        paramModelHot.offsetNum = @(0);
        paramModelHot.sortNum = @(HXStoreDocumentLibraryDocListTypeHot);

        HXStoreDocumentLibraryPageViewController *documentSearchResultVC2 = [HXStoreDocumentLibraryPageViewController createDocumentLibraryPageVCWithIndex:1 andSearchParamModel:paramModelHot];
        documentSearchResultVC2.updateSelectionTitle = ^(NSInteger index) {
            [weakSelf.scrollabelTabBar setSelectedIdx:index];
            weakSelf.currentPage = index;
        };
        [_pageViewControllersArr addObject:documentSearchResultVC2];
        
        HXStoreDocumentLibraryDocListParamModel *paramModelGood = [[HXStoreDocumentLibraryDocListParamModel alloc]init];
        paramModelGood.keywordStr = _searchWords;
        paramModelGood.limitNum = @(DEFAULT_PAGESIZENUM);
        paramModelGood.offsetNum = @(0);
        paramModelGood.sortNum = @(HXStoreDocumentLibraryDocListTypePoint);
        
        HXStoreDocumentLibraryPageViewController *documentSearchResultVC3 = [HXStoreDocumentLibraryPageViewController createDocumentLibraryPageVCWithIndex:2 andSearchParamModel:paramModelGood];
        documentSearchResultVC3.updateSelectionTitle = ^(NSInteger index) {
            [weakSelf.scrollabelTabBar setSelectedIdx:index];
            weakSelf.currentPage = index;
        };
        [_pageViewControllersArr addObject:documentSearchResultVC3];
        
        HXStoreDocumentLibraryDocListParamModel *paramModelNewest = [[HXStoreDocumentLibraryDocListParamModel alloc]init];
        paramModelNewest.keywordStr = _searchWords;
        paramModelNewest.limitNum = @(DEFAULT_PAGESIZENUM);
        paramModelNewest.offsetNum = @(0);
        paramModelNewest.sortNum = @(HXStoreDocumentLibraryDocListTypeTime);
        
        HXStoreDocumentLibraryPageViewController *documentSearchResultVC4 = [HXStoreDocumentLibraryPageViewController createDocumentLibraryPageVCWithIndex:3 andSearchParamModel:paramModelNewest];
        documentSearchResultVC4.updateSelectionTitle = ^(NSInteger index) {
            [weakSelf.scrollabelTabBar setSelectedIdx:index];
            weakSelf.currentPage = index;
        };
        [_pageViewControllersArr addObject:documentSearchResultVC4];
        
    }
    
    return _pageViewControllersArr;
}

@end
