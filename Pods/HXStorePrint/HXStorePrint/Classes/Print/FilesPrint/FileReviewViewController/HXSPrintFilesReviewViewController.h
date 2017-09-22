//
//  HXSPrintFilesReviewViewController.h
//  Pods
//
//  Created by J006 on 16/9/29.
//
//

#import "HXSBaseViewController.h"
#import "HXSPrintHeaderImport.h"

@interface HXSPrintFilesReviewViewController : HXSBaseViewController

+ (instancetype)createPrintFilesReviewVCWithFileURL:(NSString *)fileURL
                                        andFileName:(NSString *)fileName;

@end
