//
//  HXSWebViewController.h
//  store
//
//  Created by chsasaw on 14/10/30.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

#import "HXSAlipayManager.h"

@interface HXSWebViewController : HXSBaseViewController <HXSAlipayDelegate>

+ (id)controllerFromXib;
- (NSString *)setUpNavigationRightButton:(NSDictionary *)button;
- (void)sharePlatform:(NSDictionary *)shareInfo callback:(void (^)(NSInteger, NSString *, NSDictionary*))callback;

/* Get/set the current URL being displayed. (Will automatically start loading) */
@property (nonatomic, strong)    NSURL *url;

/* Show the loading progress bar (default YES) */
@property (nonatomic, assign)    BOOL showLoadingBar;

/* Tint colour for the loading progress bar. Default colour is iOS system blue. */
@property (nonatomic, copy)      UIColor *loadingBarTintColor;

/* Show the 'Action' button instead of the stop/refresh button (YES by default)*/
@property (nonatomic, assign)    BOOL showActionButton;

/* Disable the contextual popup that appears if the user taps and holds on a link. */
@property (nonatomic, assign)    BOOL disableContextualPopupMenu;

/* When being presented or pushed, this optional block can be performed after the users close the controller. */
@property (nonatomic, copy)      void (^completionHandler)(NSInteger status, NSString *result, NSDictionary *data);
/* When being presented or pushed, this optional block can be performed after the users close the controller. */
@property (nonatomic, copy)      void (^payCallBack)(NSInteger status, NSString *result, NSDictionary *data);

@end