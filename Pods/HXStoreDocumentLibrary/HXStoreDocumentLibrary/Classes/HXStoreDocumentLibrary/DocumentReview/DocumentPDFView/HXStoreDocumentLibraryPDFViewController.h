//
//  HXStoreDocumentLibraryPDFViewController.h
//  HXStoreDocumentLibrary_Example
//  PDF预览浏览器
//  Created by J006 on 16/9/19.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibraryBaseViewController.h"
#import "ReaderDocument.h"

@class HXStoreDocumentLibraryPDFViewController;

@protocol HXStoreDocumentLibraryPDFViewControllerDelegate <NSObject>

@optional

- (void)dismissReaderViewController:(HXStoreDocumentLibraryPDFViewController *)viewController;

@end

@interface HXStoreDocumentLibraryPDFViewController : HXStoreDocumentLibraryBaseViewController

@property (nonatomic, weak, readwrite) id <HXStoreDocumentLibraryPDFViewControllerDelegate> delegate;

@property (nonatomic, strong) ReaderDocument        *document;

@property (nonatomic, assign) BOOL                  isNotNeedToShowPageLabel;//是否需要不展示page页数显示

@property (weak, nonatomic) IBOutlet UIScrollView   *mainScrollView;

+ (instancetype)createPDFViewVCWithReaderDocument:(ReaderDocument *)readerDoc;

@end
