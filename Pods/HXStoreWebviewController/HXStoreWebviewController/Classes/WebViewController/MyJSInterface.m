//
//  MyJSInterface.m
//  EasyJSWebViewSample
//
//  Created by Lau Alex on 19/1/13.
//  Copyright (c) 2013 Dukeland. All rights reserved.
//

#import "MyJSInterface.h"

// Controllers
#import "HXSMediator+HXPersonalModule.h"
#import "HXSMediator+HXCreditModule.h"
#import "HXSMediator+HXWebviewModule.h"

// Model
#import "HXSOrderInfo.h"

//wechat
#import "HXSWXApiManager.h"

#import "HXMacrosUtils.h"
#import "HXMacrosDefault.h"
#import "HXSCommunitUploadImageEntity.h"
#import "HXSCommunityPhotosBrowserViewController.h"
#import "UIViewController+Extensions.h"
#import "Masonry.h"

#import "HXAppConfig.h"
#import "HXAppDeviceHelper.h"

@interface MyJSInterface()

@end

@implementation MyJSInterface

- (void)setUpWithBridge:(WebViewJavascriptBridge *)bridge {
    self.bridge = bridge;

    //设置本地监听
    __weak typeof (self) weakSelf = self;
    [bridge registerHandler:@"pushViewWithUrlAndTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
        if(![data isKindOfClass:[NSDictionary class]]) {
            data = [NSDictionary dictionary];
        }
        NSString *url;
        NSString *title;
        SET_NULLTONIL(url, [data objectForKey:@"url"]);
        SET_NULLTONIL(title, [data objectForKey:@"title"]);
        [weakSelf pushViewWithUrl:url AndTitle:title callback:^(NSDictionary * info) {
            responseCallback(info);
        }];
    }];
    
    [bridge registerHandler:@"setNavigationButton" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *result = @"NO";
        
        if([data isKindOfClass:[NSDictionary class]]) {
            result = [weakSelf.currentViewController setUpNavigationRightButton:data];
        }
        
        responseCallback(@{@"result":result, @"message":@"push view success"});
    }];
    
    [bridge registerHandler:@"sharePlatform" handler:^(id data, WVJBResponseCallback responseCallback) {
                
        if([data isKindOfClass:[NSDictionary class]]) {
            [weakSelf.currentViewController sharePlatform:data callback:^(NSInteger status, NSString *result, NSDictionary *_data) {
                responseCallback(@{
                  @"status":[NSNumber numberWithInteger:status],
                  @"message":result,
                  @"data":[_data isKindOfClass:[NSDictionary class]]?_data:@{}
                  });
            }];
        }
    }];
    
    [bridge registerHandler:@"needUserLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        responseCallback(@{@"result":[weakSelf needUserLogin], @"message":@""});
    }];
    
    [bridge registerHandler:@"closeCurrentView" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@{@"result":[weakSelf closeCurrentView], @"message":@""});
    }];
    
    [bridge registerHandler:@"pushMyCouponView" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@{@"result":[weakSelf pushMyCouponView], @"message":@""});
    }];
    
    [bridge registerHandler:@"openOrderListView" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@{@"result":[weakSelf openOrderListView:data[@"type"]], @"message":@""});
    }];
    
    [bridge registerHandler:@"openCreditCardView" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@{@"result":[weakSelf openCreditCardView], @"message":@""});
    }];
    
    [bridge registerHandler:@"openFindPayPasswordView" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@{@"result":[weakSelf openFindPayPasswordView], @"message":@""});
    }];
    
    [bridge registerHandler:@"openCreditPayView" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@{@"result":[weakSelf openCreditPayView], @"message":@""});
    }];
    
    [bridge registerHandler:@"openRouter" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@{@"result":[weakSelf openRouter:data[@"url"]], @"message":@""});
    }];
    
    [bridge registerHandler:@"payWithTypeAndParam" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *type = data[@"type"];
        id param = data[@"param"];
        
        if([param isKindOfClass:[NSString class]]) {
            param = [NSJSONSerialization JSONObjectWithData:[param dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        }
        
        if(![param isKindOfClass:[NSDictionary class]]) {
            param = @{};
        }
        
        [self payWithType:type AndParam:param callback:^(NSDictionary * dic) {
            responseCallback(dic);
//            responseCallback(@{@"result":[weakSelf payWithType: AndParam:data[@"param"]], @"message":@""});
        }];
    }];
    
    [bridge registerHandler:@"previewImages" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@{@"result":[weakSelf previewImages:data[@"images"] index:data[@"current"]], @"message":@""});
    }];
    
    [bridge registerHandler:@"getPlatformInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *info = @{@"status":@"0",
                               @"message":@"获取成功",
                               @"data":@{
                                       @"appName":[HXAppConfig sharedInstance].appName,
                                       @"appBuild":[HXAppConfig sharedInstance].appBuild,
                                       @"appBundle":[[[NSBundle mainBundle] infoDictionary]
                                                     objectForKey:@"CFBundleIdentifier"],
                                       @"appVersion":[HXAppConfig sharedInstance].appVersion,
                                       @"deviceId":[HXAppDeviceHelper uniqueDeviceIdentifier],
                                       @"system":[NSString stringWithFormat:@"iOS %@", [[UIDevice currentDevice] systemVersion]],
                                       @"screen":[NSString stringWithFormat:@"%.0fX%.0f/%0.1f", SCREEN_WIDTH*[[UIScreen mainScreen] scale],SCREEN_HEIGHT*[[UIScreen mainScreen] scale], [[UIScreen mainScreen] scale]]
                                       }
                               };
        responseCallback(info);
    }];
    //请在这里添加方法之后在jssdk里也添加相应方法
}

- (NSString *)previewImages:(NSArray *)imageUrls index:(NSString *)index
{
    NSMutableArray *imageEntitys = [NSMutableArray array];
    for(NSString *imageUrl in imageUrls) {
        HXSCommunitUploadImageEntity *entity = [[HXSCommunitUploadImageEntity alloc] init];
        entity.urlStr = imageUrl;
        [imageEntitys addObject:entity];
    }
    
    HXSCommunityPhotosBrowserViewController *communityPhotosBrowserViewController = [HXSCommunityPhotosBrowserViewController controllerFromXibWithModuleName:@"PhotosBrowse"];
    [communityPhotosBrowserViewController setTheOriginImageView:nil];
    [communityPhotosBrowserViewController initCommunityPhotosBrowserWithImageParamArray:imageEntitys
                                                                               andIndex:[index integerValue]
                                                                                andType:kCommunitPhotoBrowserTypeViewImage];
    [self.currentViewController.navigationController addChildViewController:communityPhotosBrowserViewController];
    [self.currentViewController.navigationController.view addSubview:communityPhotosBrowserViewController.view];
    [communityPhotosBrowserViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.currentViewController.navigationController.view);
    }];
    [communityPhotosBrowserViewController didMoveToParentViewController:self.currentViewController.navigationController];
    
    return @"YES";
}

- (void) pushViewWithUrl:(NSString *)url AndTitle:(NSString *)title callback:(void (^)(NSDictionary*))callback {
	DLog(@"pushViewWithUrl: %@ title: %@", url, title);
    
    void (^completionHandler)(NSInteger status, NSString *result, NSDictionary *data);
    completionHandler = ^(NSInteger status, NSString *result, NSDictionary *data) {
        
        callback(@{
                   @"status":[NSNumber numberWithInteger:status],
                   @"result":[result isKindOfClass:[NSString class]]?result:@"YES",
                   @"message":@"",
                   @"data":[data isKindOfClass:[NSDictionary class]]?data:@{}
                   }
                 );
    };
    
    id result = [[HXSMediator sharedInstance] HXSMediator_webviewViewController:@{
                                                                      @"url":url,
                                                                      @"title":title,
                                                                      @"completionHandler":completionHandler
                                                                      }];
    [self.currentViewController.navigationController pushViewController:result animated:YES];
}

- (NSString *)needUserLogin
{
    if([[[HXSMediator sharedInstance] HXSMediator_isLoggedin] boolValue]) {
        return @"YES";
    }else {
        return @"NO";
    }
}

- (NSString *)closeCurrentView {
    
    if(self.currentViewController) {
        [self.currentViewController.navigationController popViewControllerAnimated:YES];
        
        return @"YES";
    }
    
    return @"NO";
}

- (NSString *)pushMyCouponView
{
    if (![[[HXSMediator sharedInstance] HXSMediator_isLoggedin] boolValue]) {
        return @"NO";
    }
    
    if (nil != self.currentViewController) {
        UIViewController *viewController = [[HXSMediator sharedInstance] HXSMediator_couponViewController];
        
        if ([viewController isKindOfClass:[UIViewController class]]) {
            [self.currentViewController.navigationController pushViewController:viewController animated:YES];
        }
        
        return @"YES";
    }

    return @"NO";
}

// 跳转订单列表页
- (NSString *)openOrderListView:(NSString *)orderType
{
    if (([orderType isKindOfClass:[NSString class]]
        && (0 < [orderType length])) || [orderType isKindOfClass:[NSNumber class]]) {
        // save type of order
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[orderType intValue]] forKey:USER_DEFAULT_LATEST_ORDER_TYPE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    UIViewController *viewController = [[HXSMediator sharedInstance] HXSMediator_orderListViewController];
    
    if ([viewController isKindOfClass:[UIViewController class]]) {
        [self.currentViewController.navigationController pushViewController:viewController animated:YES];
        
        return @"YES";
    } else {
        return @"NO";
    }
}

// 跳转花不完页面
- (NSString *)openCreditCardView
{
    if(self.currentViewController) {
        [self.currentViewController.navigationController popToRootViewControllerAnimated:YES];
    }
    
    [self performSelector:@selector(showCreditCard) withObject:nil afterDelay:0.7];//在0.7秒后跳转到花不完界面
    
    return @"YES";
}

- (void)showCreditCard
{
    UIViewController *vc = [[HXSMediator sharedInstance] HXSMediator_creditViewController];
    
    if ([vc isKindOfClass:[UIViewController class]]) {
        [self.currentViewController.navigationController pushViewController:vc animated:YES];
    }
}

// 跳转找回支付密码页面
- (NSString *)openFindPayPasswordView
{
    UIViewController *viewController = [[HXSMediator sharedInstance] HXSMediator_forgotPasswordViewController];
    
    if ([viewController isKindOfClass:[UIViewController class]]) {
        [self.currentViewController.navigationController pushViewController:viewController animated:YES];
        
        return @"YES";
    }
    
    return @"NO";
}

// 跳转信用钱包页面
- (NSString *)openCreditPayView
{
    if ([[[HXSMediator sharedInstance] HXSMediator_isLoggedin] boolValue]) {
        UIViewController *viewController = [[HXSMediator sharedInstance] HXSMediator_creditWalletViewController];
        
        if ([viewController isKindOfClass:[UIViewController class]]) {
            [self.currentViewController.navigationController pushViewController:viewController animated:YES];
        }
        
        return @"YES";
    } else {
        return @"NO";
    }
}

- (void)payWithType:(NSString *)payType AndParam:(NSDictionary *)param  callback:(void (^)(NSDictionary*))callback {
    self.currentViewController.payCallBack = ^(NSInteger status, NSString *result, NSDictionary *data){
        callback(@{
          @"status":[NSNumber numberWithInteger:status],
          @"message":result,
          @"data":[data isKindOfClass:[NSDictionary class]]?data:@{}
          });
    };
    HXSOrderInfo *orderInfo = [[HXSOrderInfo alloc] initWithDictionary:param];
    if(payType.intValue == 1) {
        [[HXSAlipayManager sharedManager] pay:orderInfo delegate:self.currentViewController];
    }else if(payType.intValue == 2) {
        [[HXSWXApiManager sharedManager] wechatPay:orderInfo delegate:self.currentViewController];
    }
}

- (NSString *)openRouter:(NSString *)url
{
    id result = [[HXSMediator sharedInstance] performActionWithUrl:[NSURL URLWithString:url] completion:nil];
    
    if([result isKindOfClass:[UINavigationController class]]) {
        [self.currentViewController presentViewController:result animated:YES completion:nil];
    }else if([result isKindOfClass:[UIViewController class]]) {
        [self.currentViewController.navigationController pushViewController:result animated:YES];
    }
    
    return @"YES";
}

@end
