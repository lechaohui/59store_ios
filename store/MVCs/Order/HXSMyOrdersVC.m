//
//  HXSMyOrdersVC.m
//  store
//
//  Created by 格格 on 16/8/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyOrdersVC.h"

// Controllers
#import "HXSOrderListViewController.h"
#import "HXSLoginViewController.h"

// Models
#import "HXSOrderProgress.h"
#import "HXSShopViewModel.h"
#import "HXSOrderCount.h"
#import "HXSOrderViewModel.h"

// Views
#import "HXSAddressSelectionControl.h"
#import "HXSPopView.h"


@interface HXSMyOrdersVC ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, weak) IBOutlet HXSAddressSelectionControl *selectionControl;
@property (nonatomic, weak) IBOutlet UIView *pageContainterView;

@property (nonatomic, strong) NSMutableArray<HXSOrderProgress *> *orderProgressArray;
@property (nonatomic, strong) NSMutableArray *orderListVCArray;

@property (nonatomic, strong) UIPageViewController *pageViewVC;


@property (nonatomic, strong) HXSShopViewModel        *shopModel;
@property (nonatomic, strong) HXSPopView *popView;
@property (nonatomic, strong) NSArray *tabBannerEntriesArr;
@property (nonatomic, strong) HXSOrderCount *orderCount;

@end

@implementation HXSMyOrdersVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNav];
    
    self.currentPage = self.page;
    
    [self initialSelectionControl];
    
    [self initialPageView];
    
    [self fetchTab2Entries];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self changeNavigationBarBackgroundColor:[UIColor colorWithHexString:@"fde25c"]
                        pushBackButItemImage:[UIImage imageNamed:@"btn_back_normal"]
                     presentBackButItemImage:[UIImage imageNamed:@"xia"]
                                  titleColor:[UIColor blackColor]];
    
    if (self.hasBackBut) {
        
        UIButton *leftBtn = [self buttonWithTitle:nil];
        [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        
    }else{
        
        
        self.navigationItem.leftBarButtonItem = nil;
        
    }
    
    
    [self fecthOrderCount];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.hasBackBut = NO;
    [self changeNavigationBarNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.orderProgressArray = nil;
    self.orderListVCArray = nil;
    self.pageViewVC = nil;
}

#pragma mark - override

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Initial methodx

- (void)initialNav
{
    
    self.navigationItem.leftBarButtonItem = nil;
   
    
}
- (UIButton *)buttonWithTitle:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor highlightedColorFromColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithARGBHex:0x66FFFFFF] forState:UIControlStateDisabled];
    btn.frame = CGRectMake(0, 0, 35, 40);
    
    return btn;
}
- (void)initialSelectionControl
{
    [self updateSelectionControlTitles];
    self.selectionControl.selectedIdx = self.currentPage;
}

- (void)initialPageView
{
    [self.pageViewVC.view setFrame:self.pageContainterView.frame];
    HXSOrderListViewController *orderListVC = [self.orderListVCArray objectAtIndex:self.currentPage];
    NSArray *array = [NSArray arrayWithObjects:orderListVC, nil];
    [self.pageViewVC setViewControllers:array
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:YES
                                 completion:nil];
    [self addChildViewController:self.pageViewVC];
    [self.pageContainterView addSubview:self.pageViewVC.view];
    [self.pageViewVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.pageContainterView);
    }];
    [self.pageContainterView layoutIfNeeded];
    [self.pageViewVC didMoveToParentViewController:self];
}


#pragma mark - Target/Action

- (IBAction)selectionControlValueChanged:(id)sender
{
    HXSAddressSelectionControl *selectionControl = (HXSAddressSelectionControl *)sender;
    
    NSArray *array = [NSArray arrayWithObject:[self.orderListVCArray objectAtIndex: selectionControl.selectedIdx]];
    
    if (0 >= [array count]) {
        return; // Do nothing when view controllers is empty
    }
    
    __weak typeof(self) weakSelf = self;
    
    [self.selectionControl setUserInteractionEnabled:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.selectionControl setUserInteractionEnabled:YES];
    });
    
    if (self.currentPage > selectionControl.selectedIdx) {
        [self.pageViewVC setViewControllers:array
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:YES
                                     completion:^(BOOL finished) {
                                         
                                     }];
    } else {
        
        [self.pageViewVC setViewControllers:array
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:^(BOOL finished) {
                                         
                                     }];
    }
    
    self.currentPage = selectionControl.selectedIdx;

}


#pragma mark - webService

- (void)fecthOrderCount
{
    WS(weakSelf);
    
    [HXSOrderViewModel facthMyOrderCountComplete:^(HXSErrorCode status, NSString *message, HXSOrderCount *orderCount) {
        
        if(kHXSNoError == status) {
            weakSelf.orderCount = orderCount;
            [weakSelf updateSelectionControlTitles];
        } else {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
        }
    }];
}

#pragma mark - Private method

- (void)updateSelectionControlTitles
{
    NSInteger selectIndex = self.selectionControl.selectedIdx;
    
    NSArray *titleNameArr = [self.orderProgressArray valueForKeyPath:@"@unionOfObjects.showName"];
    
    if (self.orderCount) {
        
        NSMutableArray *titleMarr = [NSMutableArray arrayWithCapacity:5];
        [titleMarr addObject:titleNameArr.firstObject];
        
        for (int i = 1;i < titleNameArr.count; i ++) {
            
            NSString *str = titleNameArr[i];
            
            switch (i) {
                case 1:
                {
                    if (self.orderCount.waitingpayCountStr && self.orderCount.waitingpayCountStr.integerValue > 0) {
                        str = [NSString stringWithFormat:@"%@(%@)",str,self.orderCount.waitingpayCountStr];
                    }
                
                }
                    break;
                case 2:
                {
                    if (self.orderCount.processingCountStr && self.orderCount.processingCountStr.integerValue > 0) {
                        str = [NSString stringWithFormat:@"%@(%@)",str,self.orderCount.processingCountStr];
                    }
                }
                    break;
                case 3:
                {
                    if (self.orderCount.tobecommentCountStr && self.orderCount.tobecommentCountStr.integerValue > 0) {
                        str = [NSString stringWithFormat:@"%@(%@)",str,self.orderCount.tobecommentCountStr];
                    }
                }
                    break;
                case 4:
                {
                    if (self.orderCount.refundCountStr && self.orderCount.refundCountStr.integerValue > 0) {
                        str = [NSString stringWithFormat:@"%@(%@)",str,self.orderCount.refundCountStr];
                    }
                
                }
                    break;
                default:
                    // do nothing
                    break;
            }
            [titleMarr addObject:str];
        }
        
        self.selectionControl.titles = titleMarr;
    
    } else {
        
            self.selectionControl.titles = titleNameArr;
    }
    
    self.selectionControl.selectedIdx = selectIndex;

}


#pragma mark - UIPageViewControllerDelegate/UIPageViewControllerDataSource

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.orderListVCArray indexOfObject:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    self.currentPage = index;
    return self.orderListVCArray[index];
 
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSUInteger index = [self.orderListVCArray indexOfObject:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.orderListVCArray count]) {
        return nil;
    }
    self.currentPage = index;
    return [self.orderListVCArray objectAtIndex:index];


}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers

{
    UIViewController* controller = [pendingViewControllers firstObject];
    self.currentPage = [self.orderListVCArray indexOfObject:controller];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    if(!completed) {
        return;
    } else {
        [self.selectionControl setSelectedIdx:self.currentPage];
    }
}


#pragma mark - Fecth Data

- (void)fetchTab2Entries
{
    WS(weakSelf);
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSSite *site = locationMgr.currentSite;
    NSNumber *siteIdIntNum = (0 < [site.site_id integerValue]) ? site.site_id : [[ApplicationSettings instance] defaultSiteID];
    
    [self.shopModel fetchStoreAppEntriesWithSiteId:siteIdIntNum
                                              type:@(kHXSStoreInletTabBarSecond)
                                          complete:^(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr) {
                                              if (0 >= [entriesArr count]) {
                                                  return ;
                                              }
                                              
                                              weakSelf.tabBannerEntriesArr = entriesArr;
                                              
                                              [weakSelf displayTabBannerWithEntries];
                                          }];
}

#pragma mark - Tab Banner Methods

- (void)displayTabBannerWithEntries
{
    HXSStoreAppEntryEntity *entity = [self.tabBannerEntriesArr firstObject];
    
    if (0 >= [entity.linkURLStr length]) {
        return;
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView sd_setImageWithURL:[NSURL URLWithString:entity.imageURLStr] placeholderImage:[UIImage imageNamed:@"img_kp_banner_cat"]];
    
    [imageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(onClickTabBanner)];
    
    [imageView addGestureRecognizer:tap];
    
    // tab banner view
    HXSPopView *popView = [[HXSPopView alloc] initWithView:imageView];
    
    [popView show];
    
    self.popView = popView;
}

- (void)onClickTabBanner
{
    HXSStoreAppEntryEntity *entity = [self.tabBannerEntriesArr firstObject];
    
    __weak typeof(self) weakSelf = self;
    [self.popView closeWithCompleteBlock:^{
        [weakSelf pushToVCWithLink:entity.linkURLStr];
    }];
}

- (void)pushToVCWithLink:(NSString *)linkStr
{
    NSURL *url = [NSURL URLWithString:linkStr];
    if (nil == url) {
        url = [NSURL URLWithString:[linkStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    UIViewController *viewController = [[HXSMediator sharedInstance] performActionWithUrl:url
                                                                               completion:nil];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}





#pragma mark - Getter

- (NSMutableArray *)orderProgressArray
{
    if(!_orderProgressArray) {
        _orderProgressArray = [NSMutableArray array];
        for (int i = 0; i < 5; i++) {
            HXSOrderProgress *orderProgress = [[HXSOrderProgress alloc]init];
            orderProgress.progressType = i;
            [_orderProgressArray addObject:orderProgress];
        }
    }
    return _orderProgressArray;
}

- (NSMutableArray *)orderListVCArray
{
    if(!_orderListVCArray) {
        _orderListVCArray = [NSMutableArray array];
        for (HXSOrderProgress *orderProgress in self.orderProgressArray) {
            
            HXSOrderListViewController *orderListVC = [HXSOrderListViewController controllerWithOrderProgress:orderProgress];
            
            WS(weakSelf);
            orderListVC.orderDetialStatusChange = ^{
                [weakSelf fecthOrderCount];
            };
            
            [_orderListVCArray addObject:orderListVC];
        }
    }
    return _orderListVCArray;
}

- (UIPageViewController *)pageViewVC
{
    if(!_pageViewVC) {
        
        NSNumber *spineLocationNumber = [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMax];
        NSDictionary *options = [NSDictionary dictionaryWithObject:spineLocationNumber
                                                            forKey:UIPageViewControllerOptionSpineLocationKey];
        _pageViewVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:options];
        _pageViewVC.view.backgroundColor = [UIColor clearColor];
        _pageViewVC.delegate   = self;
        _pageViewVC.dataSource = self;
    
    }
    return _pageViewVC;
}

- (HXSShopViewModel *)shopModel
{
    if (nil == _shopModel) {
        _shopModel = [[HXSShopViewModel alloc] init];
    }
    
    return _shopModel;
}


@end
