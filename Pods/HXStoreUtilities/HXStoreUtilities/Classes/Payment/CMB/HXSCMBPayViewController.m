//
//  WebViewController.m
//  SKeyboardDemo
//
//  Created by zk on 15/12/2.
//  Copyright © 2015年 zk. All rights reserved.
//

#import "HXSCMBPayViewController.h"

#import "HXMacrosUtils.h"

#import <cmbkeyboard/CMBWebKeyboard.h>
#import <cmbkeyboard/NSString+Additions.h>



@interface HXSCMBPayViewController () <UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, assign) id<HXSCMBPayViewControllerDelegate> delegate;
@property (nonatomic, strong) NSURLRequest *requestUrl;

@end

@implementation HXSCMBPayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationLeftItem];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    DLog(@"load web");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[CMBWebKeyboard shareInstance] hideKeyboard];
    
    [self reloadWebView];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[CMBWebKeyboard shareInstance] hideKeyboard];
}

- (void)dealloc
{
    [[CMBWebKeyboard shareInstance] hideKeyboard];
}


#pragma mark - Public Methods

+ (instancetype)createCMBPayWithUrl:(NSString *)outerURL delegate:(id<HXSCMBPayViewControllerDelegate>)delegate
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"Payment" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    HXSCMBPayViewController *vc = [[HXSCMBPayViewController alloc] initWithNibName:NSStringFromClass([HXSCMBPayViewController class]) bundle:bundle];
    
    NSURL *url = [NSURL URLWithString: outerURL];
    
    vc.requestUrl = [NSURLRequest requestWithURL:url];
    vc.delegate = delegate;
    
    return vc;
}


#pragma mark - UIWebViewDelegate

static BOOL FROM = FALSE;
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.host isCaseInsensitiveEqualToString:@"cmbls"]) {
        CMBWebKeyboard *secKeyboard = [CMBWebKeyboard shareInstance];
        [secKeyboard showKeyboardWithRequest:request];
        secKeyboard.webView = webView;
        
        UITapGestureRecognizer* myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self.view addGestureRecognizer:myTap]; //这个可以加到任何控件上,比如你只想响应WebView，我正好填满整个屏幕
        myTap.delegate = self;
        myTap.cancelsTouchesInView = NO;
        return NO;
    } else if ([request.URL.absoluteString containsString:@"hxstore"]) {
        
        [self backAfterSuccess];
        
        return NO;
    }
    

    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [[CMBWebKeyboard shareInstance] hideKeyboard];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DLog(@"Load webView error:%@", [error localizedDescription]);
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (FROM) {
        return;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView_
{
    //_secKeyboard.webView = _webView;
}


#pragma mark Override Navigtaion Left Item Methods

- (void)turnBack
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [self close];
    }
}

- (void)close
{
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(cmbPayFailure)]) {
        [self.delegate cmbPayFailure];
    }
}

#pragma mark - Target Methods

- (void)backAfterSuccess
{
    [[CMBWebKeyboard shareInstance] hideKeyboard];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(cmbPaySuccess)]) {
        [self.delegate cmbPaySuccess];
    }
}

- (BOOL)needBackItem
{
    return YES;
}

- (void)reloadWebView
{
    [_webView loadRequest: _requestUrl];
    
}






@end
