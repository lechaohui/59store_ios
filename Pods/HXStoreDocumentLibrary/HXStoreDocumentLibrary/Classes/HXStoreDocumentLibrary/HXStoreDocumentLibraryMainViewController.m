//
//  HXStoreDocumentLibraryMainViewController.m
//  Pods
//
//  Created by J006 on 16/8/30.
//
//

#import "HXStoreDocumentLibraryMainViewController.h"

//vc
#import "HXSStoreDocumentLibraryViewController.h"
#import "HXSStoreDocumentCollectViewController.h"
#import "HXStoreDocumentSearchViewController.h"
#import "HXSDocumentLibraryDiscoverViewController.h"

//views
#import "HXSBannerLinkHeaderView.h"
#import "HXSelectionControl.h"
#import "HXSStoreDocumentLibraryViewCell.h"

//model
#import "HXSPrintModel.h"
#import "HXStoreDocumentLibraryViewModel.h"

//other
#import "HXStoreDocumentLibraryImport.h"

static CGFloat const kSelectcontrolhright    = 44.0;

@interface HXStoreDocumentLibraryMainViewController ()<HXSBannerLinkHeaderViewDelegate,
                                                       UIPageViewControllerDelegate,
                                                       UIPageViewControllerDataSource,
                                                       HXSStoreDocumentCollectViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView            *baseScrollview;
@property (weak, nonatomic) IBOutlet UIView                  *bannerHeaderView;
@property (weak, nonatomic) IBOutlet HXSelectionControl      *scrollabelTabBar;
@property (weak, nonatomic) IBOutlet UIView                  *pageView;
@property (nonatomic, strong) HXSBannerLinkHeaderView        *libraryHeaderView;
@property (nonatomic, strong) UIPageViewController           *pageController;
@property (nonatomic, assign) NSInteger                      currentPage;//当前选择的tab栏索引
@property (nonatomic, strong) NSMutableArray                 *pageViewControllersArr;
@property (nonatomic, strong) NSArray                        *categoriesArr;//三个类别的对象集合
@property (weak, nonatomic) IBOutlet NSLayoutConstraint      *bannerHeaderViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint      *pageViewHeightConstraint;
@property (nonatomic, strong) UIButton                       *titleTopButton;

@end

@implementation HXStoreDocumentLibraryMainViewController


#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavgationBar];
    
    [self initScrollabelTabBar];
    
    [self fetchPrintSlideNetworking];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _pageViewHeightConstraint.constant = self.view.height - kSelectcontrolhright;
}


#pragma mark - create

+ (instancetype)createDocumentLibraryMainVC
{
    HXStoreDocumentLibraryMainViewController *vc = [HXStoreDocumentLibraryMainViewController controllerFromXibWithModuleName:@"HXStoreDocumentLibrary"];
    
    return vc;
}


#pragma mark - init

- (void)initNavgationBar
{
    [self.navigationItem setTitle:@"文库"];
    [self.navigationItem setTitleView:self.titleTopButton];
}

- (void)initScrollabelTabBar
{
    [_scrollabelTabBar setTitles:@[@"文库",@"收藏",@"发现"]];
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


#pragma mark HXSStoreDocumentCollectViewControllerDelegate

- (void)refreshBadge
{
    [self refreshBadgeActionWithNoNeedAnimation:YES];
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


#pragma mark - networking

/**
 *  顶部banner栏网络请求
 */
- (void)fetchPrintSlideNetworking
{
    __weak typeof(self) weakSelf = self;
    
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSSite *site = locationMgr.currentSite;
    NSNumber *siteIdIntNum = (0 < [site.site_id integerValue]) ? site.site_id : [[ApplicationSettings instance] defaultSiteID];
    [MBProgressHUD showInView:self.view];
    [HXSPrintModel fetchStoreAppEntriesWithSiteId:siteIdIntNum
                                             type:@(kHXSPrintInletTop)
                                         complete:^(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr) {
                                             [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                              if (0 < [entriesArr count]) {
                                                  HXSStoreAppEntryEntity *item = [entriesArr objectAtIndex:0];
                                                  CGSize size = CGSizeMake(item.imageWidthIntNum.floatValue, item.imageHeightIntNum.floatValue);
                                                  CGFloat scaleOfSize = size.height/size.width;
                                                  if (isnan(scaleOfSize)
                                                      || isinf(scaleOfSize)) {
                                                      scaleOfSize = 1.0;
                                                  }
                                                  
                                                  weakSelf.libraryHeaderView.frame = CGRectMake(0,
                                                                                                0,
                                                                                                weakSelf.view.width,
                                                                                                scaleOfSize * weakSelf.view.width);

                                                  
                                                  weakSelf.bannerHeaderViewHeightConstraint.constant = scaleOfSize * weakSelf.view.width;
                                                  
                                                  
                                                  [weakSelf.libraryHeaderView setSlideItemsArray:entriesArr];
                                              } else {
                                                  weakSelf.bannerHeaderViewHeightConstraint.constant = 0;
                                              }
                                             
                                             [weakSelf initialPageViewController];
                                          }];
    
}


#pragma mark - HXSBannerLinkHeaderViewDelegate

- (void)didSelectedLink:(NSString *)linkStr
{
    NSURL *url = [NSURL URLWithString:linkStr];
    
    if (nil == url) {
        url = [NSURL URLWithString:[linkStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    UIViewController *viewController = [[HXSMediator sharedInstance] performActionWithUrl:url
                                                                               completion:nil];
    if([viewController isKindOfClass:[UIViewController class]]) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
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


#pragma mark jumpAction

- (void)jumpToSearchVC
{
    HXStoreDocumentSearchViewController *searchVC = [HXStoreDocumentSearchViewController createDocumentSearchVC];
    
    [self.navigationController pushViewController:searchVC animated:NO];
}


#pragma mark - getter

- (HXSBannerLinkHeaderView *)libraryHeaderView
{
    if (nil == _libraryHeaderView) {
        _libraryHeaderView = [[HXSBannerLinkHeaderView alloc] initHeaderViewWithDelegate:self];
        [_bannerHeaderView addSubview:_libraryHeaderView];
    }
    
    return _libraryHeaderView;
}

- (NSMutableArray *)pageViewControllersArr
{
    if(nil == _pageViewControllersArr) {
        
        _pageViewControllersArr = [[NSMutableArray alloc]init];
        
        HXSStoreDocumentLibraryViewController *documentLibVC = [HXSStoreDocumentLibraryViewController createDocumentLibraryVCWithIndex:0];
        
        __weak typeof(self) weakSelf = self;
        
        documentLibVC.updateSelectionTitle = ^(NSInteger index) {
            [weakSelf.scrollabelTabBar setSelectedIdx:index];
            weakSelf.currentPage = index;
        };
        documentLibVC.scrollviewScrolled = ^(CGPoint offset) {
            if (0 < offset.y) {
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     weakSelf.baseScrollview.contentOffset = CGPointMake(0, weakSelf.bannerHeaderViewHeightConstraint.constant);
                                 }];
            } else {
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     weakSelf.baseScrollview.contentOffset = CGPointZero;
                                 }];
            }
        };
        
        
        HXSStoreDocumentCollectViewController *documentCollectVC = [HXSStoreDocumentCollectViewController createDocumentCollectVCWithIndex:1];
        documentCollectVC.delegate = self;
        documentCollectVC.updateSelectionTitle = ^(NSInteger index) {
            [weakSelf.scrollabelTabBar setSelectedIdx:index];
            weakSelf.currentPage = index;
        };
        documentCollectVC.scrollviewScrolled = ^(CGPoint offset) {
            if (0 < offset.y) {
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     weakSelf.baseScrollview.contentOffset = CGPointMake(0, weakSelf.bannerHeaderViewHeightConstraint.constant);
                                 }];
            } else {
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     weakSelf.baseScrollview.contentOffset = CGPointZero;
                                 }];
            }
        };
        
        HXSDocumentLibraryDiscoverViewController *documentLibFinding = [HXSDocumentLibraryDiscoverViewController createDocumentDiscoverVCWithIndex:2];
        
        documentLibFinding.updateSelectionTitle = ^(NSInteger index) {
            [weakSelf.scrollabelTabBar setSelectedIdx:index];
            weakSelf.currentPage = index;
        };
        documentLibFinding.scrollviewScrolled = ^(CGPoint offset) {
            if (0 < offset.y) {
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     weakSelf.baseScrollview.contentOffset = CGPointMake(0, weakSelf.bannerHeaderViewHeightConstraint.constant);
                                 }];
            } else {
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     weakSelf.baseScrollview.contentOffset = CGPointZero;
                                 }];
            }
        };
        
        [_pageViewControllersArr addObject:documentLibVC];
        [_pageViewControllersArr addObject:documentCollectVC];
        [_pageViewControllersArr addObject:documentLibFinding];
    }
    
    return _pageViewControllersArr;
}

- (UIButton *)titleTopButton
{
    if(nil == _titleTopButton) {
        _titleTopButton = [[UIButton alloc]init];
        [_titleTopButton setFrame:CGRectMake(0, 0, SCREEN_WIDTH * 2 / 3, 30)];
        [_titleTopButton.layer setCornerRadius:4];
        [_titleTopButton setBackgroundColor:[UIColor colorWithR:255 G:255 B:255 A:0.2]];
        [_titleTopButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleTopButton setTitle:@"搜索你想要的文档" forState:UIControlStateNormal];
        HXStoreDocumentLibraryViewModel *documentViewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
        [_titleTopButton setImage:[documentViewModel imageFromNewName:@"ic_search_small_white"]
                         forState:UIControlStateNormal];
        [_titleTopButton setTitleColor:[UIColor colorWithR:255 G:255 B:255 A:0.7]
                              forState:UIControlStateNormal];
        [_titleTopButton addTarget:self
                            action:@selector(jumpToSearchVC)
                  forControlEvents:UIControlEventTouchUpInside];
        _titleTopButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    }
    
    return _titleTopButton;
}

@end
