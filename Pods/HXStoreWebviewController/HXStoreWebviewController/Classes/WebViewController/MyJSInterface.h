//
//  MyJSInterface.h
//  EasyJSWebViewSample
//
//  Created by Lau Alex on 19/1/13.
//  Copyright (c) 2013 Dukeland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSWebViewController.h"
#import "WebViewJavascriptBridge.h"

@interface MyJSInterface : NSObject

@property (nonatomic, weak) HXSWebViewController * currentViewController;
@property (nonatomic, strong) WebViewJavascriptBridge *bridge;

- (void)setUpWithBridge:(WebViewJavascriptBridge *)bridge;

@end