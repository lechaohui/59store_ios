//
//  HXSStoreDocumentLibraryChildCategoryViewController.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/8.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXSStoreDocumentLibraryChildCategoryViewController.h"
#import "HXStoreDocumentLibraryPageViewController.h"

//views
#import "HXSelectionControl.h"

//model
#import "HXStoreDocumentLibraryViewModel.h"

//other
#import "HXStoreDocumentLibraryImport.h"

@interface HXSStoreDocumentLibraryChildCategoryViewController ()<UIPageViewControllerDelegate,
                                                                 UIPageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet HXSelectionControl         *scrollabelTabBar;
@property (weak, nonatomic) IBOutlet UIView                     *pageView;
@property (nonatomic, strong) HXStoreDocumentLibraryViewModel   *documentViewModel;
@property (nonatomic, strong) NSNumber                          *secondCategoryIdNum;
@property (nonatomic, strong) NSString                          *titleNameStr;
@property (nonatomic, strong) UIPageViewController              *pageController;
@property (nonatomic, assign) NSInteger                         currentPage;//当前选择的tab栏索引
@property (nonatomic, strong) NSMutableArray                    *pageViewControllersArr;

@end

@implementation HXSStoreDocumentLibraryChildCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationBar];
    
    [self initScrollabelTabBar];
    
    [self initialPageViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - create

+ (instancetype)createDocumentLibraryChiledCategorVCWithCategoryId:(NSNumber *)secondCategoryId
                                                      andTitleName:(NSString *)titleNameStr
{
    HXSStoreDocumentLibraryChildCategoryViewController *vc = [HXSStoreDocumentLibraryChildCategoryViewController controllerFromXibWithModuleName:@"HXStoreDocumentLibrary"];
    
    vc.secondCategoryIdNum = secondCategoryId;
    vc.titleNameStr        = titleNameStr;
    
    return vc;
}


#pragma mark - init

- (void)initNavigationBar
{
    [self.navigationItem setTitle:_titleNameStr];
}

- (void)initScrollabelTabBar
{
    [_scrollabelTabBar setTitles:@[@"最新",@"热门",@"好评"]];
    [_scrollabelTabBar addTarget:self action:@selector(selectItemAction:) forControlEvents:UIControlEventValueChanged];
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
    
    [_pageView addSubview:self.pageController.view];
    [self.pageController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_pageView);
    }];
    [self.pageController didMoveToParentViewController:self];
    
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


#pragma mark - Get Set Methods

- (HXStoreDocumentLibraryViewModel *)documentViewModel
{
    if(nil == _documentViewModel) {
        _documentViewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
    }
    
    return _documentViewModel;
}

- (NSMutableArray *)pageViewControllersArr
{
    if(nil == _pageViewControllersArr) {
        __weak typeof(self) weakSelf = self;
        _pageViewControllersArr = [[NSMutableArray alloc]init];
        
        HXStoreDocumentLibraryDocListParamModel *paramModelNew = [[HXStoreDocumentLibraryDocListParamModel alloc]init];
        paramModelNew.secondCategoryIdStr = [_secondCategoryIdNum stringValue];
        paramModelNew.limitNum = @(DEFAULT_PAGESIZENUM);
        paramModelNew.offsetNum = @(0);
        paramModelNew.sortNum = @(HXStoreDocumentLibraryDocListTypeTime);
        HXStoreDocumentLibraryPageViewController *pageNewVC = [HXStoreDocumentLibraryPageViewController createDocumentLibraryPageVCWithIndex:0
                                                                                                                               andParamModel:paramModelNew];
        pageNewVC.updateSelectionTitle = ^(NSInteger index) {
            [weakSelf.scrollabelTabBar setSelectedIdx:index];
            weakSelf.currentPage = index;
        };
        [_pageViewControllersArr addObject:pageNewVC];
        
        HXStoreDocumentLibraryDocListParamModel *paramModelHot = [[HXStoreDocumentLibraryDocListParamModel alloc]init];
        paramModelHot.secondCategoryIdStr = [_secondCategoryIdNum stringValue];
        paramModelHot.limitNum = @(DEFAULT_PAGESIZENUM);
        paramModelHot.offsetNum = @(0);
        paramModelHot.sortNum = @(HXStoreDocumentLibraryDocListTypeHot);
        HXStoreDocumentLibraryPageViewController *hotPageVC = [HXStoreDocumentLibraryPageViewController createDocumentLibraryPageVCWithIndex:1
                                                                                                                               andParamModel:paramModelHot];
        hotPageVC.updateSelectionTitle = ^(NSInteger index) {
            [weakSelf.scrollabelTabBar setSelectedIdx:index];
            weakSelf.currentPage = index;
        };
        [_pageViewControllersArr addObject:hotPageVC];
        
        HXStoreDocumentLibraryDocListParamModel *paramModelGood = [[HXStoreDocumentLibraryDocListParamModel alloc]init];
        paramModelGood.secondCategoryIdStr = [_secondCategoryIdNum stringValue];
        paramModelGood.limitNum = @(DEFAULT_PAGESIZENUM);
        paramModelGood.offsetNum = @(0);
        paramModelGood.sortNum = @(HXStoreDocumentLibraryDocListTypePoint);
        HXStoreDocumentLibraryPageViewController *goodPageVC = [HXStoreDocumentLibraryPageViewController createDocumentLibraryPageVCWithIndex:2
                                                                                                                               andParamModel:paramModelGood];
        goodPageVC.updateSelectionTitle = ^(NSInteger index) {
            [weakSelf.scrollabelTabBar setSelectedIdx:index];
            weakSelf.currentPage = index;
        };
        [_pageViewControllersArr addObject:goodPageVC];
        
    }
    
    return _pageViewControllersArr;
}

@end
