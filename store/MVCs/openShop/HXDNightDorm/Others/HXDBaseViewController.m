//
//  HXDBaseViewController.m
//  store
//
//  Created by ranliang on 15/4/14.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXDBaseViewController.h"

#import "HXSWarningBarView.h"

#define PADDING_LEFT_BAR_ITEM  10


@interface HXDBaseViewController ()

@property (nonatomic, strong) HXDBlankView *blankView;
@property (nonatomic, strong) HXDBlankView *networkErrorBlankView;

@end

@implementation HXDBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.firstLoading = YES;

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initSuperNavigationBarStatus];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

- (void)dealloc
{
    // Do nothing
}


#pragma mark - Override Methods

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Initial Methods

- (void)initSuperNavigationBarStatus
{
    self.navigationItem.backBarButtonItem = nil;
    
    self.navigationController.navigationBar.translucent = NO;
    
    if (nil == self.navigationItem.leftBarButtonItem) {
        UIImage *leftItemImage = [UIImage imageNamed:@"btn_back_blue"];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[leftItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(back)];
        self.navigationItem.leftBarButtonItem.imageInsets = self.navigationController.viewControllers.count == 1 ? UIEdgeInsetsZero : UIEdgeInsetsMake(0, -5, 0, 5);
    }
}


#pragma mark - Public Methods

- (void)showWarning:(NSString *)wStr
{
    if(wStr == nil || wStr.length == 0)
        return;
    CGFloat warningHeight = 44;
    if (!self.warnBarView) {
        self.warnBarView = [[HXSWarningBarView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), warningHeight)];
    }
    [self.warnBarView customWarningText:wStr];
    [self.view addSubview:self.warnBarView];
    
    __weak typeof(self) weakSelf = self;
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.warnBarView removeMyselfViewFromSuperview];
        weakSelf.warnBarView = nil;
    });
}

- (void)addLeftBarButtonItemWithImageName:(NSString *)imageName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 50, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(back)
     forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 10);
}

- (void)initialNavigationLeftItem
{
    UIImage *backImage = [UIImage imageNamed:@"btn_back_blue"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self
                   action:@selector(turnBack)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *closeImage = [UIImage imageNamed:@"ico_delete"];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundColor:[UIColor clearColor]];
    [closeButton setImage:closeImage forState:UIControlStateNormal];
    [closeButton addTarget:self
                    action:@selector(close)
          forControlEvents:UIControlEventTouchUpInside];
    
    // set frame
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backImage.size.width + (PADDING_LEFT_BAR_ITEM * 2) + closeImage.size.width, MAX(backImage.size.height, backImage.size.height))];
    
    [backButton setFrame:CGRectMake(0, 0, backImage.size.width, backImage.size.height)];
    [view addSubview:backButton];
    
    [closeButton setFrame:CGRectMake(CGRectGetMaxX(backButton.frame) + PADDING_LEFT_BAR_ITEM * 2, 0, closeImage.size.width, closeImage.size.height)];
    [view addSubview:closeButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
}

- (void)replaceCurrentViewControllerWith:(UIViewController *)viewController animated:(BOOL)animated
{
    NSMutableArray * viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [viewControllers replaceObjectAtIndex:(viewControllers.count - 1) withObject:viewController];
    [self.navigationController setViewControllers:viewControllers animated:animated];
}

- (void)hideNoDataImage
{
    self.blankView.hidden = YES;
    self.networkErrorBlankView.hidden = YES;
}

- (void)showNoDataImageWithMessage:(NSString *)message
{
    self.blankView.hidden = NO;
    self.networkErrorBlankView.hidden = YES;
    [self.blankView updateMessage:message];
}

- (void)showNetworkingErrorWithMessage:(NSString *)message
{
    self.blankView.hidden = YES;
    self.networkErrorBlankView.hidden = NO;
    [_networkErrorBlankView updateMessage:message];
}

- (void)dismissWarning
{
    self.warnBarView.hidden = YES;
}


#pragma mark Navigtaion Left Item Methods

- (void)turnBack
{
    if(self.navigationController.viewControllers.count == 1) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - getter

- (HXDBlankView *)blankView
{
    if (_blankView == nil) {
        _blankView = [[HXDBlankView alloc] initWithImageName:@"no_data" title:@"暂时没有数据哦~"];
        _blankView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _blankView.hidden = YES;
        [self.view addSubview:_blankView];
    }
    return _blankView;
}

- (HXDBlankView *)networkErrorBlankView
{
    if(_networkErrorBlankView == nil)
    {
        _networkErrorBlankView = [[HXDBlankView alloc] initWithImageName:@"ku_img" title:networkingErrorStr];
        _networkErrorBlankView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _networkErrorBlankView.hidden = YES;
        [self.view addSubview:_networkErrorBlankView];
    }
    
    return _networkErrorBlankView;
}

@end
