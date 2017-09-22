//
//  HXStoreDocumentLibraryPaymentResultViewController.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/27.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibraryPaymentResultViewController.h"

//vc
#import "HXSWebViewController.h"
#import "HXStoreDocumentLibraryShareViewController.h"

//other
#import "HXStoreDocumentLibraryImport.h"
#import "HXSMediator.h"
#import "HXSMediator+OrderModule.h"

@interface HXStoreDocumentLibraryPaymentResultViewController ()

@property (weak, nonatomic) IBOutlet UIView  *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *backToShopButton;
@property (nonatomic, strong) HXSOrderInfo   *printOrderInfo;
@property (nonatomic, strong) NSMutableArray<HXSMyPrintOrderItem *> *cartArray;

@end

@implementation HXStoreDocumentLibraryPaymentResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initBottomView];
    
    [self initOrderInfoView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

+ (instancetype)createDocumentLibraryPaymentResultVCWithArray:(NSMutableArray<HXSMyPrintOrderItem *> *)array
                                                 andOrderInfo:(HXSOrderInfo *)orderInfo
{
    HXStoreDocumentLibraryPaymentResultViewController *vc = [HXStoreDocumentLibraryPaymentResultViewController controllerFromXibWithModuleName:@"HXStoreDocumentLibrary"];
    
    vc.cartArray = array;
    vc.printOrderInfo = orderInfo;
    
    return vc;
}


#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    self.navigationItem.title = @"结算";
}

- (void)initBottomView
{
    UIColor *lineColor = [UIColor colorWithRGBHex:0xE1E2E3];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(SCREEN_WIDTH, 0)];
    
    [path moveToPoint:CGPointMake(0, 44)];
    [path addLineToPoint:CGPointMake(SCREEN_WIDTH, 44)];
    
    [path moveToPoint:CGPointMake(SCREEN_WIDTH / 2, 0)];
    [path addLineToPoint:CGPointMake(SCREEN_WIDTH / 2, 44)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor     = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor   = lineColor.CGColor;
    shapeLayer.lineWidth     = 1;
    shapeLayer.path          = path.CGPath;
    
    [_bottomView.layer addSublayer:shapeLayer];
}

- (void)initOrderInfoView
{
    [_priceLabel setText:[NSString stringWithFormat:@"%.2f",[_printOrderInfo.order_amount doubleValue]]];
    [_orderNumLabel setText:_printOrderInfo.order_sn];
    [_orderTimeLabel setText:[self getDateString:_printOrderInfo.add_time.longValue]];
}


#pragma mark - Button Action

- (IBAction)backToShopAction:(id)sender
{
    [self jumpToShopMainVC];
}

- (IBAction)checkOrderAction:(id)sender
{
    [self jumpToMyPrintOrderVC];
}

- (IBAction)shareToEarnMoneyAction:(id)sender
{
    [self jumpToShareVC];
}

- (IBAction)helpButtonAction:(id)sender
{
    [self jumpToHelpVC];
}


#pragma mark - Jump Action

- (void)jumpToShareVC
{
    HXStoreDocumentLibraryShareViewController *shareVC = [HXStoreDocumentLibraryShareViewController createDocumentLibraryShareVCWithArray:_cartArray];
    
    [self replaceCurrentViewControllerWith:shareVC animated:YES];
}

- (void)jumpToHelpVC
{
    NSString *url = [[ApplicationSettings instance] currentDocLibURL];
    HXSWebViewController *webVc = [HXSWebViewController controllerFromXib];
    webVc.url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self.navigationController pushViewController:webVc animated:YES];
}

- (void)jumpToShopMainVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)jumpToMyPrintOrderVC
{
    NSDictionary *dic = @{@"order_sn":_printOrderInfo.order_sn};
    UIViewController *vc = [[HXSMediator sharedInstance] HXSMediator_orderDetailViewControllerWithParams:dic];
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - private method

- (NSString *)getDateString:(long)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    return [dateFormatter stringFromDate:date];
}

@end
