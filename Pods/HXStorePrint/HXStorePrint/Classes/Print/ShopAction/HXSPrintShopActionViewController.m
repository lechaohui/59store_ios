//
//  HXSPrintShopActionViewController.m
//  Pods
//
//  Created by J006 on 16/10/19.
//
//

#import "HXSPrintShopActionViewController.h"

//views
#import "HXSActionSheet.h"
#import "HXSBannerLinkHeaderView.h"

//model
#import "HXSPrintModel.h"

//others
#import "HXSPrintHeaderImport.h"

#define DEFAULT_CONTENTVIEW_HEIGHT 691 //691为iphone 6s下整个内容的高度
#define DEFAULT_IPHONE_HEIGHT 667 //667为iPhone 6s的屏幕高度

@interface HXSPrintShopActionViewController ()<HXSBannerLinkHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView        *bannerImageView;
@property (weak, nonatomic) IBOutlet UIImageView        *qrCodeImageView;
@property (weak, nonatomic) IBOutlet UIButton           *connectButton;
@property (weak, nonatomic) IBOutlet UIScrollView       *mainScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *connectButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *connectButtonRightConstraint;
@property (nonatomic, strong) HXSActionSheet            *actionSheet;
@property (nonatomic, strong) HXSActionSheet            *longPressQRCodeSheet;
@property (nonatomic, strong) HXSPrintShopFreePicModel  *model;
@property (weak, nonatomic) IBOutlet UIView             *bannerHeaderView;
@property (nonatomic, strong) HXSBannerLinkHeaderView   *libraryHeaderView;

@end

@implementation HXSPrintShopActionViewController


#pragma mark life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initScrollView];
    
    [self initGesture];
    
    [self fetchPrintSlideNetworking];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - create

+ (instancetype)createShopActionVCWithModel:(HXSPrintShopFreePicModel *)model;
{
    HXSPrintShopActionViewController *vc = [HXSPrintShopActionViewController controllerFromXibWithModuleName:@"HXStorePrint"];
    vc.model = model;
    
    return vc;
}


#pragma mark - init

- (void)initialNavigationBar
{
    [self.navigationItem setTitle:@"店铺活动"];
}

- (void)initScrollView
{
    CGFloat defaulContentHeight = SCREEN_HEIGHT * 691 / DEFAULT_IPHONE_HEIGHT;
    _contentViewHeightConstraint.constant = defaulContentHeight;
    
    [_mainScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, defaulContentHeight)];
    _connectButtonTopConstraint.constant = 7 * defaulContentHeight / DEFAULT_CONTENTVIEW_HEIGHT;//7为iPhone 6s下的top约束
    _connectButtonRightConstraint.constant = 25 * defaulContentHeight / DEFAULT_CONTENTVIEW_HEIGHT;//25为iPhone 6s下的右边约束
}

- (void)initGesture
{
    [_qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:_model.urlStr]];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(longPressQRCodeAction:)];
    for (UIGestureRecognizer* recognizer in _mainScrollView.gestureRecognizers ) {
        [longPressGesture requireGestureRecognizerToFail:recognizer];
    }
    [longPressGesture setMinimumPressDuration:0.5];
    [_qrCodeImageView addGestureRecognizer:longPressGesture];
    _qrCodeImageView.userInteractionEnabled = YES;
}


#pragma mark - HXSBannerLinkHeaderViewDelegate

- (void)didSelectedLink:(NSString *)linkStr
{
    NSURL *url = [NSURL URLWithString:linkStr];
    
    if (nil == url) {
        url = [NSURL URLWithString:[linkStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    UIViewController *viewController = [[HXSMediator sharedInstance] performActionWithUrl:url
                                                                               completion:nil];
    if([viewController isKindOfClass:[UIViewController class]]) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


#pragma marl - networking

/**
 *  顶部banner栏网络请求
 */
- (void)fetchPrintSlideNetworking
{
    WS(weakSelf);
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSSite *site = locationMgr.currentSite;
    NSNumber *siteIdIntNum = (0 < [site.site_id integerValue]) ? site.site_id : [[ApplicationSettings instance] defaultSiteID];
    [MBProgressHUD showInView:self.view];
    [HXSPrintModel fetchStoreAppEntriesWithSiteId:siteIdIntNum
                                             type:@(kHXSStoreInletYeFreePrintPicTop)
                                         complete:^(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr)
     {
         [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
         if (0 < [entriesArr count]) {
             HXSStoreAppEntryEntity *item = [entriesArr objectAtIndex:0];
             CGSize size = CGSizeMake(item.imageWidthIntNum.floatValue, item.imageHeightIntNum.floatValue);
             CGFloat scaleOfSize = size.height/size.width;
             if (isnan(scaleOfSize)
                 || isinf(scaleOfSize)) {
                 scaleOfSize = 1.0;
             }
             
             if (scaleOfSize * weakSelf.bannerHeaderView.width > weakSelf.bannerHeaderView.height) {
                 scaleOfSize = size.width/size.height;
                 if (isnan(scaleOfSize)
                     || isinf(scaleOfSize)) {
                     scaleOfSize = 1.0;
                 }
                 [weakSelf.libraryHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.centerX.equalTo(weakSelf.bannerHeaderView);
                     make.centerY.equalTo(weakSelf.bannerHeaderView);
                     make.width.mas_equalTo(scaleOfSize * weakSelf.bannerHeaderView.height);
                     make.height.mas_equalTo(weakSelf.bannerHeaderView.height);
                 }];
             } else {
                 [weakSelf.libraryHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.centerX.equalTo(weakSelf.bannerHeaderView);
                     make.centerY.equalTo(weakSelf.bannerHeaderView);
                     make.width.mas_equalTo(weakSelf.bannerHeaderView.width);
                     make.height.mas_equalTo(scaleOfSize * weakSelf.bannerHeaderView.width);
                 }];
             }
             [weakSelf.libraryHeaderView setSlideItemsArray:entriesArr];
         } else {
             [weakSelf.bannerHeaderView setHidden:YES];
         }
         
    }];
}



#pragma mark Button Action

- (IBAction)connectButtonAction:(id)sender
{
    [self.actionSheet show];
}

- (void)longPressQRCodeAction:(UILongPressGestureRecognizer *)longPressGesture
{
    if(longPressGesture.state == UIGestureRecognizerStateBegan) {
        [self.longPressQRCodeSheet show];
    }
}

- (void)saveQRPhotoToLocalAction
{
    if(!_qrCodeImageView
       || !_qrCodeImageView.image) {
        return;
    }
    UIImageWriteToSavedPhotosAlbum(_qrCodeImageView.image,self,@selector(saveImageCheckWithImage:didFinishSavingWithError:contextInfo:),nil);
}

- (void)saveImageCheckWithImage:(UIImage *)image
       didFinishSavingWithError:(NSError *)error
                    contextInfo:(void *)contextInfo
{
    if(image
       && !error) {
        [MBProgressHUD showInViewWithoutIndicator:self.view
                                           status:@"保存成功"
                                       afterDelay:1.5];
    } else if(error) {
        [MBProgressHUD showInViewWithoutIndicator:self.view
                                           status:@"保存失败"
                                       afterDelay:1.5];
    }
}


#pragma mark getter

- (HXSBannerLinkHeaderView *)libraryHeaderView
{
    if (nil == _libraryHeaderView) {
        _libraryHeaderView = [[HXSBannerLinkHeaderView alloc] initHeaderViewWithDelegate:self];
        [_bannerHeaderView addSubview:_libraryHeaderView];
    }
    
    return _libraryHeaderView;
}

- (HXSActionSheet *)actionSheet
{
    if(!_actionSheet)
    {
        HXSActionSheetEntity *phoneEntity = [[HXSActionSheetEntity alloc] init];
        phoneEntity.nameStr = [NSString stringWithFormat:@"拨号 %@",_model.phoneStr];
        WS(weakSelf);
        HXSAction *phoneAction = [HXSAction actionWithMethods:phoneEntity
                                                          handler:^(HXSAction *action){
                                                              NSString *phoneNumber = [@"tel://" stringByAppendingString:weakSelf.model.phoneStr];
                                                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                                                          }];
        _actionSheet = [HXSActionSheet actionSheetWithMessage:@""
                                            cancelButtonTitle:@"取消"];
        
        [_actionSheet addAction:phoneAction];
        
    }
    return _actionSheet;
}

- (HXSActionSheet *)longPressQRCodeSheet
{
    if(!_longPressQRCodeSheet)
    {
        HXSActionSheetEntity *qrCodeEntity = [[HXSActionSheetEntity alloc] init];
        qrCodeEntity.nameStr = @"保存二维码至相册";
        WS(weakSelf);
        HXSAction *qrCodeSaveAction = [HXSAction actionWithMethods:qrCodeEntity
                                                           handler:^(HXSAction *action){
                                                               [weakSelf saveQRPhotoToLocalAction];
                                                           }];
        _longPressQRCodeSheet = [HXSActionSheet actionSheetWithMessage:@""
                                                     cancelButtonTitle:@"取消"];
        
        [_longPressQRCodeSheet addAction:qrCodeSaveAction];
        
    }
    return _longPressQRCodeSheet;
}

@end
