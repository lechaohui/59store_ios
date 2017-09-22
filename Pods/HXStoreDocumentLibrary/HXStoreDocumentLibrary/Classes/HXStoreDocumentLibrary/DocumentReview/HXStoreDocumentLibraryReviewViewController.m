//
//  HXStoreDocumentLibraryReviewViewController.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/12.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibraryReviewViewController.h"

//vc
#import "HXSLoginViewController.h"
#import "HXStoreDocumentLibraryPDFViewController.h"
#import "HXStoreDocumentLibraryPaymentViewController.h"

//view
#import "HXSShareView.h"

//model
#import "HXStoreDocumentLibraryViewModel.h"
#import "HXSDocumentPersistencyManger.h"
#import "HXStoreDocumentSearchViewModel.h"
#import "HXStoreDocumentLibraryPersistencyManger.h"
#import "HXSOrderInfo.h"

//other
#import "HXStoreDocumentLibraryImport.h"
#import "NSString+Verification.h"
#import "AFNetworkReachabilityManager.h"
#import "AFHTTPSessionManager.h"
#import <AFNetworking/UIKit+AFNetworking.h>

CGFloat const buyButtonWidth = 135.0;
CGFloat const starAndShareButtonLeadingTrailingNormal = 50;//收藏分享按钮左右边距(在没有购买按钮时)
CGFloat const starAndShareButtonLeadingTrailingBuy    = 28;//收藏分享按钮左右边距(在有购买按钮时)

@interface HXStoreDocumentLibraryReviewViewController ()<HXStoreDocumentLibraryPDFViewControllerDelegate,
                                                         UIScrollViewDelegate,
                                                         HXStoreDocumentLibraryPaymentViewControllerDelegate>

@property (nonatomic, strong) NSString                              *docIdStr;
@property (nonatomic, strong) HXStoreDocumentLibraryDocumentModel   *docModel;
@property (nonatomic, strong) HXStoreDocumentLibraryViewModel       *documentViewModel;
@property (weak, nonatomic) IBOutlet UIView                         *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView                    *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton                       *reloadButton;
@property (weak, nonatomic) IBOutlet UILabel                        *loadFailLabel;
@property (weak, nonatomic) IBOutlet UIView                         *mainView;
@property (weak, nonatomic) IBOutlet UIButton                       *starButton;
@property (weak, nonatomic) IBOutlet UIButton                       *printButton;
@property (weak, nonatomic) IBOutlet UIButton                       *shareButton;
@property (weak, nonatomic) IBOutlet UIProgressView                 *progressView;
@property (nonatomic, strong) NSURLSessionDownloadTask              *downLoadTask;
@property (nonatomic, strong) HXStoreDocumentSearchViewModel        *searchViewModel;
@property (nonatomic, strong) HXStoreDocumentLibraryPersistencyManger *persistencyManager;
@property (nonatomic, strong) HXStoreDocumentLibraryPDFViewController   *pdfVC;
@property (weak, nonatomic) IBOutlet UIButton                       *reReadButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint             *reReadButtonTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton                       *buyButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint             *buyButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint             *starButtonLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint             *shareButtonRightConstraint;
@property (nonatomic, strong) HXSCustomAlertView                    *payFailedAlertView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint             *bottomViewHeightConstraint;

@end

@implementation HXStoreDocumentLibraryReviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fetchDocumentModelFirstLoadNetworking];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self checkLocalFileAndPDFDocumentSaveDocModel];
}


#pragma mark - create

+ (instancetype)createReviewVCWithDocId:(NSString *)docIdStr
{
    HXStoreDocumentLibraryReviewViewController *vc = [HXStoreDocumentLibraryReviewViewController controllerFromXibWithModuleName:@"HXStoreDocumentLibrary"];
    
    vc.docIdStr = docIdStr;
    
    return vc;
}


#pragma mark - init

- (void)initNavaitionBar
{
    if(_docModel) {
        [self.navigationItem setTitle:_docModel.docTitleStr];
    }
    
    if(_isNoNeedToShowBottomViewAndRightBarButton) {
        [self.navigationItem setRightBarButtonItem:nil];
        _bottomViewHeightConstraint.constant = 0;
    }
}


- (void)initLoadingView
{
    [_reloadButton setHidden:YES];
    [_loadFailLabel setHidden:YES];
    [_progressView setHidden:YES];
    [_iconImageView setHidden:NO];
    
    [self setIconImageViewWithModel:_docModel];
    [self setStarButtonWithModel:_docModel];
}

- (void)setIconImageViewWithModel:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    if([docModel.docSuffixStr hasSuffix:@"doc"]
       || [docModel.docSuffixStr hasSuffix:@"docx"]) {
        [_iconImageView setImage:[self.documentViewModel imageFromNewName:@"img_print_word_160"]];
    } else if([docModel.docSuffixStr hasSuffix:@"pdf"]) {
        [_iconImageView setImage:[self.documentViewModel imageFromNewName:@"img_print_pdf_160"]];;
    } else if([docModel.docSuffixStr hasSuffix:@"ppt"]
              || [docModel.docSuffixStr hasSuffix:@"pptx"]) {
        [_iconImageView setImage:[self.documentViewModel imageFromNewName:@"img_print_ppt_160"]];
    } else {
        [_iconImageView setImage:[self.documentViewModel imageFromNewName:@"img_print_pdf_160"]];
    }
}

- (void)setStarButtonWithModel:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    if([docModel.isFavorNum boolValue]) {
        [_starButton setImage:[self.documentViewModel imageFromNewName:@"ic_star_big"]
                     forState:UIControlStateNormal];
    } else {
        [_starButton setImage:[self.documentViewModel imageFromNewName:@"ic_star_black"]
                     forState:UIControlStateNormal];
    }
}

- (void)updateBottomViewConstraints
{
    [_bottomView setHidden:NO];
    if([_docModel.typeNum isEqualToNumber:@(HXSLibraryDocumentTypeBuy)]
       && ![_docModel.hasRightsNum boolValue]) {
        
        NSString *price = _docModel.priceDecNum.stringValue;
        
        [_buyButton setTitle:[NSString stringWithFormat:@"购买：¥%@",price]
                    forState:UIControlStateNormal];
        _buyButtonWidthConstraint.constant   = buyButtonWidth;
        _starButtonLeftConstraint.constant   = starAndShareButtonLeadingTrailingBuy;
        _shareButtonRightConstraint.constant = starAndShareButtonLeadingTrailingBuy;
    } else {
        _buyButtonWidthConstraint.constant   = 0;
        _starButtonLeftConstraint.constant   = starAndShareButtonLeadingTrailingNormal;
        _shareButtonRightConstraint.constant = starAndShareButtonLeadingTrailingNormal;
    }
    
    [self checkDocTypeAndShowInfor];
}

/**
 *  检测是否是付费文档并弹框显示信息
 */
- (void)checkDocTypeAndShowInfor
{
    if([_docModel.typeNum isEqualToNumber:@(HXSLibraryDocumentTypeBuy)]
       && ![_docModel.hasRightsNum boolValue]) {
        [MBProgressHUD showInViewWithoutIndicator:self.view
                                           status:@"付费文档需购买后才能阅读完整内容"
                                       afterDelay:1.5];
    }
}


#pragma mark - networking

- (void)fetchDocumentModelFirstLoadNetworking
{
    [MBProgressHUD showInView:self.view];
    WS(weakSelf);
    [self.documentViewModel fetchDocumentModelWithDocId:_docIdStr
                                               Complete:^(HXSErrorCode code, NSString *message, HXStoreDocumentLibraryDocumentModel *docModel)
     {
         [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
         if(kHXSNoError == code
            && nil != docModel) {
             weakSelf.docModel = docModel;
             [weakSelf initNavaitionBar];
             [weakSelf initLoadingView];
             [weakSelf checkWifiStatusAndShowWithModel:docModel];
         } else {
             [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                status:message
                                            afterDelay:1.5];
         }
     }];
}

/**
 *  获取单个文档对象
 */
- (void)fetchDocumentModelNetworking
{    
    [MBProgressHUD showInView:self.view];
    WS(weakSelf);
    [self.documentViewModel fetchDocumentModelWithDocId:_docIdStr
                                               Complete:^(HXSErrorCode code, NSString *message, HXStoreDocumentLibraryDocumentModel *docModel)
    {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if(kHXSNoError == code
           && nil != docModel) {
            weakSelf.docModel = docModel;
            [weakSelf initNavaitionBar];
            [weakSelf initLoadingView];
            [weakSelf checkWifiStatusAndShowWithModel:docModel];
        } else {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:message
                                           afterDelay:1.5];
        }
    }];
}

- (void)refreshDocumentModelNetworking
{
    WS(weakSelf);
    [self.documentViewModel fetchDocumentModelWithDocId:_docIdStr
                                               Complete:^(HXSErrorCode code, NSString *message, HXStoreDocumentLibraryDocumentModel *docModel)
     {
         if(kHXSNoError == code
            && nil != docModel) {
             weakSelf.docModel = docModel;
             [weakSelf initNavaitionBar];
             [weakSelf initLoadingView];
             [weakSelf checkWifiStatusAndShowWithModel:docModel];
         } else {
             [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                status:message
                                            afterDelay:1.5];
         }
     }];
}

/**
 *  下载文档网络请求
 */
- (void)downLoadDocumentNetworking
{
    if(!_docModel.urlStr) {
        return;
    }
    [_loadFailLabel setHidden:YES];
    [_reloadButton setHidden:YES];
    [_progressView setHidden:NO];
    [_progressView setProgress:0];
    
    WS(weakSelf);
    NSURL *documentPath = [self.searchViewModel createDocumentFolderURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_docModel.urlStr]];
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    
    _downLoadTask = [manage downloadTaskWithRequest:request
                                           progress:nil
                                        destination:^NSURL *(NSURL *targetPath, NSURLResponse *response){
                                            NSURL *url = [documentPath URLByAppendingPathComponent:weakSelf.docModel.pdfNameStr];
                                            [self removedDocFileBeforeDownloadWithURLStr:url.absoluteString
                                                                              andDocName:weakSelf.docModel.pdfNameStr];
                                            return url;
                                            
                                        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error){
                                            [_progressView setHidden:YES];
                                            
                                            if(error) {
                                                [weakSelf.loadFailLabel setHidden:NO];
                                                [weakSelf.reloadButton setHidden:NO];
                                                [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                   status:@"没有网络，请稍后再试~"
                                                                               afterDelay:1.5];
                                            } else {
                                                weakSelf.docModel.archiveDocPathURL = filePath;
                                                weakSelf.docModel.archiveDocPathStr = [self.documentViewModel saveLocalDocPathURLWithURL:_docModel];
                                                [weakSelf updateBottomViewConstraints];
                                                [weakSelf addPDFReviewToView];
                                            }
                                        }];
    
    [_progressView setProgressWithDownloadProgressOfTask:_downLoadTask
                                                animated:YES];
    [_downLoadTask resume];
}

/**
 *删除之前缓存的文件
 */
- (void)removedDocFileBeforeDownloadWithURLStr:(NSString *)urlStr
                                    andDocName:(NSString *)docName
{
    if ([urlStr hasPrefix:@"file://"]) {
        urlStr = [[urlStr substringFromIndex:7] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        urlStr = [urlStr stringByDeletingLastPathComponent];
        urlStr = [NSString stringWithFormat:@"%@/%@",urlStr,docName];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir;
    BOOL isFileExist = [fileManager fileExistsAtPath:urlStr
                                         isDirectory:&isDir];
    NSError *error;
    if(isFileExist) {
        [fileManager removeItemAtPath:urlStr
                                error:&error];
    }
}

- (void)updateDocReadPageNumsNetworking
{
    if(!_docModel.pageReadNum
       || [_docModel.pageReadNum integerValue] < 1) {
        return;
    }
    
    [self.documentViewModel updateDocumentReadPagesWithPageNums:_docModel.pageReadNum
                                                       andDocId:_docModel.docIdStr
                                                       Complete:^(HXSErrorCode code, NSString *message, BOOL isSuccess) {
    }];
}

- (void)createOrderInfoNetworking
{
    [MBProgressHUD showInView:self.view];
    WS(weakSelf);
    [self.documentViewModel createDocumentOrderInfoWithDocId:_docIdStr
                                                    Complete:^(HXSErrorCode code, NSString *message, HXSPrintDocumentOrderInfo *docOrderInfo)
    {
        [MBProgressHUD hideHUDForView:weakSelf.view
                             animated:YES];
        if(kHXSNoError == code
           && docOrderInfo) {
            HXSOrderInfo *orderInfo = [[HXSOrderInfo alloc] initWithOrderInfo:docOrderInfo];
            HXStoreDocumentLibraryPaymentViewController *paymentVC = [HXStoreDocumentLibraryPaymentViewController createPrintDocumentPaymentVCWithOrderInfo:orderInfo
                                                                                                                                                installment:NO
                                                                                                                                                    andType:HXSPrintPaymentTypeDocBuy];
            paymentVC.delegate = self;
            [weakSelf.navigationController pushViewController:paymentVC animated:YES];
            
        } else {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:message
                                           afterDelay:1.5];
        }
    }];
}


#pragma mark - HXStoreDocumentLibraryPaymentViewControllerDelegate

- (void)payFinishWithType:(HXSPrintPaymentType)type
               andSuccess:(BOOL)isSuccess
{
    if(!isSuccess) {
        [self.payFailedAlertView show];
    } else {
        [MBProgressHUD showInViewWithoutIndicator:self.view
                                           status:@"支付成功"
                                       afterDelay:1.5];
        [self refreshDocumentModelNetworking];
    }
}


#pragma mark - check network

/**
 *  检测当前网络环境
 */
- (void)checkWifiStatusAndShowWithModel:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    WS(weakSelf);
    AFNetworkReachabilityManager *manage = [AFNetworkReachabilityManager sharedManager];
    NSNumber *hasShowAlertForWifi = [[NSUserDefaults standardUserDefaults] objectForKey: kHXSDocumentLibraryShowAlertForWifi];
    if(nil == hasShowAlertForWifi) {
        NSNumber *hasNoWifiNum = [[NSNumber alloc]initWithBool:YES];
        [[NSUserDefaults standardUserDefaults] setObject:hasNoWifiNum forKey:kHXSDocumentLibraryShowAlertForWifi];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        hasShowAlertForWifi = [[NSUserDefaults standardUserDefaults] objectForKey: kHXSDocumentLibraryShowAlertForWifi];
    }
    
    if(!manage.isReachableViaWiFi
       && [hasShowAlertForWifi boolValue]) {
        
        HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc]initWithTitle:@""
                                                                         message:@"你正在非Wifi环境浏览，\n打开文档可能会产生费用。\n是否继续打开文档？"
                                                                 leftButtonTitle:@"取消"
                                                               rightButtonTitles:@"打开"];
        alertView.rightBtnBlock = ^{
            NSNumber *hasNoWifiNum = [[NSNumber alloc]initWithBool:NO];
            [[NSUserDefaults standardUserDefaults] setObject:hasNoWifiNum forKey:kHXSDocumentLibraryShowAlertForWifi];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weakSelf downLoadDocumentNetworking];
        };
        [alertView show];
    } else {
        [weakSelf downLoadDocumentNetworking];
    }
}


#pragma mark Button Action

- (IBAction)reloadButtonAction:(id)sender
{
    [self downLoadDocumentNetworking];
}

- (IBAction)starButtonAction:(id)sender
{
    WS(weakSelf);
    if([HXSUserAccount currentAccount].isLogin) {
        [self.documentViewModel updateDocmentStarWithDocModelAndSaveLocal:_docModel
                                                                    andVC:self
                                                              andComplete:^(HXStoreDocumentLibraryDocumentModel *docModel)
         {
             [weakSelf setStarButtonWithModel:weakSelf.docModel];
        }];
    } else {
        [HXSLoginViewController showLoginController:self
                                    loginCompletion:^{
            [weakSelf fetchDocumentModelNetworking];
        }];
    }
}

- (IBAction)addToPrintButtonAction:(id)sender
{
    if(![HXSUserAccount currentAccount].isLogin) {
        WS(weakSelf);
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            [weakSelf fetchDocumentModelNetworking];
        }];
        return;
    } else {
        if(![_docModel.hasRightsNum boolValue]
           && [_docModel.typeNum isEqualToNumber:@(HXSLibraryDocumentTypeBuy)]) {
            [MBProgressHUD showInViewWithoutIndicator:self.view
                                               status:@"付费文档需购买后才能打印文档"
                                           afterDelay:1.5];
            return;
        }
    }
    
    [self.persistencyManager addDocumentToPrintQueueWithDoc:_docModel
                                                      andVC:self];
    
    [self refreshBadgeActionWithNoNeedAnimation:YES];
    
}

- (IBAction)shareButtonAction:(id)sender
{
    [self.documentViewModel createShareViewAndShowIn:self
                                        withDocModel:_docModel];
}

- (IBAction)reReadButtonAction:(id)sender
{
    if(!_pdfVC
       || !_pdfVC.document) {
        return;
    }
    
    [_pdfVC.document setPageNumber:@(1)];
    [_pdfVC.mainScrollView setContentOffset:CGPointZero animated:YES];
}

- (IBAction)buyDocumentAction:(id)sender
{
    WS(weakSelf);
    if([HXSUserAccount currentAccount].isLogin) {
        [self createOrderInfoNetworking];
    } else {
        [HXSLoginViewController showLoginController:self
                                    loginCompletion:^{
                                        [weakSelf fetchDocumentModelNetworking];
                                    }];
    }
}


#pragma mark - Add PDFView to view

- (void)addPDFReviewToView
{
    NSString *shortenedURL = [self.documentViewModel saveLocalDocPathURLWithURL:_docModel];
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:shortenedURL
                                                           password:nil];
    if(!document) {
        return;
    }
    
    if(_docModel.pageReadNum
       && _docModel.pageReadNum.integerValue > 1) {
        document.pageNumber = _docModel.pageReadNum;
    }
    
    _pdfVC = [HXStoreDocumentLibraryPDFViewController createPDFViewVCWithReaderDocument:document];
    [self addChildViewController:_pdfVC];
    [self.view insertSubview:_pdfVC.view
                belowSubview:_reReadButton];
    [_pdfVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_mainView);
    }];
    [_pdfVC didMoveToParentViewController:self];
    
    [self animationReReadButton];
}


#pragma mark - animation

- (void)animationReReadButton
{
    if(!_docModel.pageReadNum
       || [_docModel.pageReadNum integerValue] <= 1) {//第一页不用弹出顶部提示栏
        return;
    }
        _reReadButtonTopConstraint.constant = 0;
        [self.view layoutIfNeeded];
        //由于UIView动画中不能触发button点击事件,所以使用NSTime来实现
        NSTimer *timer = [NSTimer timerWithTimeInterval:2
                                                 target:self
                                               selector:@selector(timerFireMethod:)
                                               userInfo:nil
                                                repeats:NO];
        
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addTimer:timer
                  forMode:NSDefaultRunLoopMode];
}

- (void)timerFireMethod:(NSTimer *)timer
{
    [timer invalidate];
    _reReadButtonTopConstraint.constant = - _reReadButton.frame.size.height;
    [UIView animateWithDuration:0.3
                          delay:0
                        options:(UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         
                     }];
}


#pragma mark - check Local file and GetDocModel

/**
 *检测本地已经收藏的文档与当前pdf浏览的对象,如果都存在则保存相关信息如:已经阅读到的页数
 **/
- (void)checkLocalFileAndPDFDocumentSaveDocModel
{
    if(!_pdfVC.document
       || !_docModel) {
        return;
    }
    _docModel.pageReadNum = _pdfVC.document.pageNumber;
    
    [self updateDocReadPageNumsNetworking];
}

#pragma mark - getter

- (HXStoreDocumentLibraryViewModel *)documentViewModel
{
    if(nil == _documentViewModel) {
        _documentViewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
    }
    
    return _documentViewModel;
}

- (HXStoreDocumentSearchViewModel *)searchViewModel
{
    if(nil == _searchViewModel) {
        _searchViewModel = [[HXStoreDocumentSearchViewModel alloc]init];
    }
    
    return _searchViewModel;
}

- (HXStoreDocumentLibraryPersistencyManger *)persistencyManager
{
    if(nil == _persistencyManager) {
        _persistencyManager = [[HXStoreDocumentLibraryPersistencyManger alloc]init];
    }
    
    return _persistencyManager;
}

- (HXSCustomAlertView *)payFailedAlertView
{
    if(nil == _payFailedAlertView) {
        _payFailedAlertView = [[HXSCustomAlertView alloc]initWithTitle:@""
                                                               message:@"支付失败"
                                                       leftButtonTitle:@"取消"
                                                     rightButtonTitles:@"重新支付"];
        WS(weakSelf);
        _payFailedAlertView.rightBtnBlock = ^{
            [weakSelf buyDocumentAction:nil];
        };
    }
    
    return _payFailedAlertView;
}

@end
