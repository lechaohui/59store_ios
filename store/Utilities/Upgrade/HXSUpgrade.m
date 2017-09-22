//
//  HXSUpgrade.m
//  store
//
//  Created by ArthurWang on 2016/10/5.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSUpgrade.h"

static NSString * const deviceMsgURL = @"device/msg";

@interface HXSUpgrade () <UIAlertViewDelegate>

@end

@implementation HXSUpgrade

+ (void)upgrade
{
    static HXSUpgrade *sharedInstance = nil;
    if (sharedInstance == nil)
    {
        sharedInstance = [[HXSUpgrade alloc] init];
    }
    
    [sharedInstance fetchVersion];
}

#pragma mark - Fetch version Methods

- (void)fetchVersion
{
    NSDictionary *params = @{@"a": @(1),   // app类型 1:iOS 2:android
                             @"b": [HXAppConfig sharedInstance].appBuild
                             };
    
    __weak typeof(self) weakSelf = self;
    
    [HXStoreWebService getRequest:deviceMsgURL
                       parameters:params
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  return ;
                              }
                              
                              if (1 == [[data objectForKey:@"status"] integerValue]) { // 0:不需要升级 1:需要升级
                                  [weakSelf showAlertWithTitle:@"提醒"
                                                       details:@"为了使您得到更好的体验快下载最新版本吧"];
                              }
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              // Do nothing
                          }];
}


#pragma mark - Alert View

- (id)showAlertWithTitle:(NSString *)title
                 details:(NSString *)details
{
    UIViewController *topController = [UIApplication sharedApplication].delegate.window.rootViewController;
    while (topController.presentedViewController)
    {
        topController = topController.presentedViewController;
    }
    
    if ([UIAlertController class]
        && topController )
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:details preferredStyle:UIAlertControllerStyleAlert];
        
        //download/ok action
        [alert addAction:[UIAlertAction actionWithTitle:@"更新"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(__unused UIAlertAction *action) {
            [self jumpToAppStoreForDownloading];
        }]];
        
        //get current view controller and present alert
        [topController presentViewController:alert animated:YES completion:NULL];
        
        return alert;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:details
                                                       delegate:(id<UIAlertViewDelegate>)self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"更新", nil];
        
        [alert show];
        
        return alert;
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self jumpToAppStoreForDownloading];
}


#pragma mark - Jump To App Store

- (void)jumpToAppStoreForDownloading
{
    NSString *updateURL = @"itms-apps://itunes.apple.com/app/id933710338";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateURL]];
}

@end
