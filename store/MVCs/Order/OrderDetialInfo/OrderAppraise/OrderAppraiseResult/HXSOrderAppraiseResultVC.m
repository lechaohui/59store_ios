//
//  HXSOrderAppraiseResultVC.m
//  store
//
//  Created by 格格 on 16/8/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  评价结果页

#import "HXSOrderAppraiseResultVC.h"

// Controllers
#import "HXSWebViewController.h"

//Models
#import "HXSSlideItem.h"
#import "HXSShopViewModel.h"

// views
#import "HXSBannerLinkHeaderView.h"

@interface HXSOrderAppraiseResultVC ()<HXSBannerLinkHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet HXSBannerLinkHeaderView *shopHeaderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHeaderHeight;

@property (nonatomic, strong) HXSShopViewModel        *shopModel;

@end

@implementation HXSOrderAppraiseResultVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNav];
    
    [self initialPrama];
    
    [self initialShopHeaderView];
    
    [self fetchSlide];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - initial

- (void)initialNav
{
    self.navigationItem.title = @"感谢评价";
}

- (void)initialPrama
{
    self.shopModel = [[HXSShopViewModel alloc]init];
}

- (void)initialShopHeaderView
{
    self.shopHeaderView.eventDelegate = self;
}


#pragma mark - webservice

- (void)fetchSlide
{
    __weak typeof(self) weakSelf = self;
    
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSSite *site = locationMgr.currentSite;
    NSNumber *siteIdIntNum = (0 < [site.site_id integerValue]) ? site.site_id : [[ApplicationSettings instance] defaultSiteID];
    
    [self.shopModel fetchStoreAppEntriesWithSiteId:siteIdIntNum
                                              type:@(kHXSStoreInletCommentTop)
                                          complete:^(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr) {
                                              if (0 < [entriesArr count]) {
                                                  
                                                  HXSStoreAppEntryEntity *item = [entriesArr objectAtIndex:0];
                                                  CGSize size = CGSizeMake(item.imageWidthIntNum.floatValue, item.imageHeightIntNum.floatValue);
                                                  CGFloat scaleOfSize = size.height/size.width;
                                                  if (isnan(scaleOfSize)
                                                      || isinf(scaleOfSize)) {
                                                      scaleOfSize = 1.0;
                                                  }
                                                  
                                                  weakSelf.bannerHeaderHeight.constant = scaleOfSize * SCREEN_WIDTH;
                                                
                                                  [weakSelf.shopHeaderView setSlideItemsArray:entriesArr];
                                              } else {
                                                  weakSelf.bannerHeaderHeight.constant = 0;
                                              }
                                          }];
    
}


#pragma mark - Puch To LinkStr VCs

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


#pragma mark - HXSBannerLinkHeaderViewDelegate

- (void)didSelectedLink:(NSString *)linkStr
{
    [self pushToVCWithLink:linkStr];
}

@end
