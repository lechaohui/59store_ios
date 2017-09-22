//
//  HXSPrintFilesReviewViewController.m
//  Pods
//
//  Created by J006 on 16/9/29.
//
//

#import "HXSPrintFilesReviewViewController.h"

//vc
#import "HXStoreDocumentLibraryPDFViewController.h"

@interface HXSPrintFilesReviewViewController ()

@property (nonatomic, strong) NSString *fileURLStr;
@property (nonatomic, strong) NSString *fileNameStr;

@end

@implementation HXSPrintFilesReviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationBar];
    
    [self initPDFReviewVC];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

+ (instancetype)createPrintFilesReviewVCWithFileURL:(NSString *)fileURL
                                        andFileName:(NSString *)fileName
{
    HXSPrintFilesReviewViewController *vc = [HXSPrintFilesReviewViewController controllerFromXibWithModuleName:@"HXStorePrint"];
    
    vc.fileURLStr  = fileURL;
    vc.fileNameStr = fileName;
    
    return vc;
}


#pragma mark - init

- (void)initNavigationBar
{
    if(_fileNameStr) {
        [self.navigationItem setTitle:_fileNameStr];
    }
}

- (void)initPDFReviewVC
{
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:_fileURLStr
                                                           password:nil];
    if(!document) {
        return;
    }
    
    HXStoreDocumentLibraryPDFViewController *pdfVC = [HXStoreDocumentLibraryPDFViewController createPDFViewVCWithReaderDocument:document];
    [self addChildViewController:pdfVC];
    [self.view addSubview:pdfVC.view];
    [pdfVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [pdfVC didMoveToParentViewController:self];
}

@end
