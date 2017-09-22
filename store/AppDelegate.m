//
//  AppDelegate.m
//  store
//
//  Created by chsasaw on 14-10-11.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "AppDelegate.h"

// Controllers
#import "HXSLaunchViewController.h"
#import "HXSMyFilesPrintViewController.h"

// View Model
#import "HXSGexinSdkManager.h"
#import "HXSSinaWeiboManager.h"
#import "HXSQQSdkManager.h"
#import "HXSWXApiManager.h"
#import "HXSAlipayManager.h"
#import "HXSGPSLocationManager.h"
#import "HXSDeviceUpdateRequest.h"

// Others
#import "HXSMediator.h"
#import "HXSUpgrade.h"
#import "UIWindow+Extension.h"

// Third Framework
#import "AFNetworking.h"
#import "Udesk.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>

// System
#import <UserNotifications/UserNotifications.h>



#define kChanelKey          @"A1000"                            //渠道key
#define kMobclickKey        @"5444c89afd98c5d6dc003391"         //友盟统计
static NSString * const kAliHttpNDSAccountID = @"176677";       // Ali HTTPDNS

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@property (nonatomic, strong) NSURL  *urlFromOtherApp;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupAliHttpDNS];
    
    [self setupCache];
    
    [self setupInitialStatusOfBusiness];
    
    [self initialAPNSiOS10];
    
    [self setupRemoteNotificationWithOptions:launchOptions];
    
    [self setupUserAgent];
    
    [self setupFMDeviceManager];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    HXSLaunchViewController *viewController = [[HXSLaunchViewController alloc] initWithNibName:NSStringFromClass([HXSLaunchViewController class]) bundle:nil];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[HXSGexinSdkManager sharedInstance] stopSdk];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[HXSGexinSdkManager sharedInstance] startSdk];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBoxOrderHasPayed object:nil];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [HXSUpgrade upgrade]; // must check everty time when app show
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    DLog(@"deviceToken:%@", token);
    
    // [3]:向个推服务器注册deviceToken
    [[HXSGexinSdkManager sharedInstance] setDeviceToken:token data:deviceToken];
    [[HXSGexinSdkManager sharedInstance] setAlias:[HXAppDeviceHelper uniqueDeviceIdentifier]];
    [[HXSDeviceUpdateRequest currentRequest] setDeviceToken:token];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    // [3-EXT]:如果APNS注册失败，通知个推服务器
    [[HXSGexinSdkManager sharedInstance] setDeviceToken:@"" data:nil];
    
    DLog(@"didFailToRegisterForRemoteNotificationsWithError:%@", [error localizedDescription]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userinfo
{
    [self dealWithRemoteNotification:userinfo];
    
    [self showPayloadWithDic:userinfo];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if([url.scheme isEqualToString:@"file"] && !_urlFromOtherApp)
    {
        [self copyTheDocumentFromOtherAppAndJumpToICloudWithFileURL:url];
    }
    
    id result = [[HXSMediator sharedInstance] performActionWithUrl:url completion:nil];
    if([result isKindOfClass:[UIViewController class]]) {
        HXSBaseNavigationController * nav = [[HXSBaseNavigationController alloc] initWithRootViewController:result];
        [self.rootViewController presentViewController:nav animated:YES completion:nil];
    }else if([result isKindOfClass:[UINavigationController class]]) {
        [self.rootViewController presentViewController:result animated:YES completion:nil];
    }

    return [[HXSSinaWeiboManager sharedManager] handleOpenURL:url]
    || [[HXSWXApiManager sharedManager] handleOpenURL:url]
    || [[HXSQQSdkManager sharedManager] handleOpenURL:url]
    || [[HXSAlipayManager sharedManager] handleOpenURL:url];
}

#pragma mark - Public Methods

+ (AppDelegate *)sharedDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (RootViewController *) rootViewController
{
    UIViewController * controller;
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0") && ([UIApplication sharedApplication].windows.count > 0)) {
        controller = [UIApplication sharedApplication].windows[0].rootViewController;
    }
    else {
        controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    
    if([controller isKindOfClass:[RootViewController class]]) {
        return (RootViewController *)controller;
        
    }else if([controller isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController * nav = (UINavigationController *)controller;
        for(UIViewController * root in nav.viewControllers) {
            if([root isKindOfClass:[RootViewController class]]) {
                return (RootViewController *)root;
            }
        }
    }
    
    return nil;
}


#pragma mark - Set up Methods

- (void)setupAliHttpDNS
{
    HttpDnsService *httpdns = [HttpDnsService sharedInstance];
    
    [httpdns setAccountID:[kAliHttpNDSAccountID intValue]];
    
    [httpdns setPreResolveHosts:[[ApplicationSettings instance] hosts]];
    
    [httpdns setExpiredIPEnabled:YES];
}

- (void)setupCache
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:200 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    [HXSDirectoryManager addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[HXSDirectoryManager getDocumentsDirectory]]];
    [HXSDirectoryManager addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[HXSDirectoryManager getLibraryDirectory]]];
}

- (void)setupInitialStatusOfBusiness
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    // Override point for customization after application launch.
#if !DEBUG
    UMConfigInstance.appKey = kMobclickKey;
    UMConfigInstance.ePolicy = REALTIME;
    UMConfigInstance.channelId = kChanelKey;
    
    [MobClick startWithConfigure:UMConfigInstance];
#endif
    // 推送
    [[HXSGexinSdkManager sharedInstance] startSdk];
    
    [self initCustomUniversal];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self initCustomControlPhone];
    }
    
    [HXSUsageManager trackEvent:HXS_USAGE_EVENT_LAUNCH parameter:nil];
    
    [[HXSGPSLocationManager instance] startPositioning];
    
    // initial unreaded message
    [HXSMessageBoxViewModel fetchUnreadMessage];
    
    // 初始化Udesk   e4ffb1aa618267ac1690c5d59c42f79b
    [UdeskManager initWithAppkey:@"e4ffb1aa618267ac1690c5d59c42f79b" domianName:@"59store.udesk.cn"];
}

- (void)initialAPNSiOS10
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
}

- (void)setupRemoteNotificationWithOptions:(NSDictionary *)launchOptions
{
    // remote notification
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    self.urlFromOtherApp = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(self.urlFromOtherApp)
        {
            [self copyTheDocumentFromOtherAppAndJumpToICloudWithFileURL:self.urlFromOtherApp];
            self.urlFromOtherApp = nil;
        }
    });
    
    NSDictionary* message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (nil != message)
    {
        // Jump to the notification vc after displaying the ad vc
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf showPayloadWithDic:message];
        });
    }
}

- (void)setupUserAgent
{
    //设置webview的user-agent
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"]) {
        
        NSString *userAgent = [NSString stringWithFormat:@"%@/%@; iOS %@; %.0fX%.0f/%0.1f", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleNameKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] systemVersion], SCREEN_WIDTH*[[UIScreen mainScreen] scale],SCREEN_HEIGHT*[[UIScreen mainScreen] scale], [[UIScreen mainScreen] scale]];
        if (userAgent) {
            if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
                NSMutableString *mutableUserAgent = [userAgent mutableCopy];
                if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                    userAgent = mutableUserAgent;
                }
            }
        }
        
        UIWebView *tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSString *originalUserAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        NSString *userAgentStr = [NSString stringWithFormat:@"%@\\%@; %@; %@", originalUserAgent, [HXAppDeviceHelper modelString], userAgent,[NSString stringWithFormat:@"IsJailbroken/%d",[HXAppDeviceHelper isJailbroken]]];
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":userAgentStr, @"User-Agent":userAgentStr}];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)setupFMDeviceManager
{
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    
    NSMutableDictionary *options = [[NSMutableDictionary alloc] initWithCapacity:5];
#if DEBUG
    [options setValue:@"allowd" forKey:@"allowd"];
    
    [options setValue:@"sandbox" forKey:@"env"];
#endif
    
    [options setValue:@"59store" forKey:@"partner"];
    
    manager->initWithOptions(options);
}


#pragma mark - Initial Methods

- (void)initCustomUniversal
{    
    // UINavigationBar
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:HXS_MAIN_COLOR] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
    [[UINavigationBar appearance] setBarTintColor:HXS_MAIN_COLOR];
    
    NSShadow * shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    shadow.shadowOffset = CGSizeZero;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                         NSFontAttributeName : [UIFont systemFontOfSize:17.0f],
                                                         NSShadowAttributeName:shadow};
    [UINavigationBar appearance].shadowImage = [[UIImage alloc] init];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor whiteColor]];
}

- (void)initCustomControlPhone
{
    // UITabBar
    [UITabBar appearance].backgroundColor = [UIColor whiteColor];
    [UITabBar appearance].backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
    [UITabBar appearance].shadowImage = [UIImage imageWithColor:HXS_BORDER_COLOR];
    [UITabBar appearance].selectionIndicatorImage = [UIImage imageWithColor:[UIColor clearColor]];
    [[UITabBar appearance] setBarStyle:UIBarStyleDefault];
    
    NSShadow * shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: HXS_MAIN_COLOR,
                                                        NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10],
                                                        NSShadowAttributeName:shadow}
                                             forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: HXS_TABBAR_ITEM_TEXT_COLOR_NORMAL,
                                                        NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10],
                                                        NSShadowAttributeName:shadow}
                                             forState:UIControlStateNormal];
}

- (void)showPayloadWithDic:(NSDictionary *)payloadDic
{
    NSDictionary *apnsDic = [payloadDic objectForKey:@"aps"];
    NSDictionary *alertDic = [apnsDic objectForKey:@"alert"];
    NSString *dataStr = nil;
    if ([alertDic isKindOfClass:[NSDictionary class]]) {
        NSArray *bodyArr = [alertDic objectForKey:@"loc-args"];
        
        dataStr = [bodyArr firstObject];
    }
    
    NSDictionary *dataDic = nil;
    if ([dataStr isKindOfClass:[NSString class]]){
        dataDic = [NSJSONSerialization JSONObjectWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        
        if(![dataDic isKindOfClass:[NSDictionary class]]) {
            dataDic = [NSDictionary dictionary];
        }
    }
    
    [self checkMessageAndUrlInUserInfo:dataDic];
}

- (void)checkMessageAndUrlInUserInfo:(NSDictionary *)dataDic
{
    if(nil != dataDic){
        
        NSString *url = nil;
        if(DIC_HAS_STRING(dataDic, @"link")) {
            SET_NULLTONIL(url, [dataDic objectForKey:@"link"]);
        }
        
        //封装的alertView
        if(0 < url.length) {
            //封装的alertView
            [self showURL:url];
        }
    }
}

- (void)showURL:(NSString *)url
{
    DLog(@"url  %@", url);
    
    if((nil != url)
       && [url isKindOfClass:[NSString class]]
       && (0 < url.length)) {
        UIViewController *controller = [[HXSMediator sharedInstance] performActionWithUrl:[NSURL URLWithString:url]
                                                                               completion:nil];
        
        HXSBaseNavigationController * nav = [[HXSBaseNavigationController alloc] initWithRootViewController:controller];
        
        if (nil == self.rootViewController.presentedViewController) {
            [self.rootViewController presentViewController:nav animated:YES completion:nil];
        } else {
            [self.rootViewController.presentedViewController presentViewController:nav animated:YES completion:nil];
        }
    }
}



#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
      willPresentNotification:(UNNotification *)notification
        withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    // 当App正在前台时，此时若收到通知，将触发该方法
    
    DLog(@"notification %@", notification);
    
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    // 当用户点击通知、点击action、回复/评论时，将触发该方法
    
    DLog(@"Userinfo %@", response.notification.request.content.userInfo);
    
    [self showPayloadWithDic:response.notification.request.content.userInfo];
}


#pragma mark - Push Notice Methods

- (void)dealWithRemoteNotification:(NSDictionary *)userinfo
{
    DLog(@"userinfo is %@", userinfo);
    
    // update unread message
    [HXSMessageBoxViewModel fetchUnreadMessage];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}



/**
 *  获取从其他程序打开的文件地址并拷贝到本地
 *
 *  @param url
 */
- (void)copyTheDocumentFromOtherAppAndJumpToICloudWithFileURL:(NSURL *)url
{
    UIViewController *currentVC = [self.window topVisibleViewController];
    
    if([currentVC isKindOfClass:[HXSMyFilesPrintViewController class]])
    {
        HXSMyFilesPrintViewController *printVC = (HXSMyFilesPrintViewController *)currentVC;
        
        [printVC refreshThePrintVCWithURL:url];
    }
    else
    {
        HXSMyFilesPrintViewController *printVC = [HXSMyFilesPrintViewController createFilesPrintVCWithURL:url];
        HXSBaseNavigationController *navi = [[HXSBaseNavigationController alloc]initWithRootViewController:printVC];
        [self.rootViewController  presentViewController:navi animated:YES completion:nil];
    }
}


#pragma mark - Private Methods

/*
 //获取当前屏幕显示的viewcontroller
 */

- (UIViewController *)visibleViewController
{
    UIViewController *rootViewController = self.window.rootViewController;
    
    return [self getVisibleViewControllerFrom:rootViewController];
}

- (UIViewController *)getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}


@end
