//
//  HXStoreDocumentLibraryReviewViewController.h
//  HXStoreDocumentLibrary_Example
//  文档预览界面
//  Created by J006 on 16/9/12.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibraryBaseViewController.h"
#import "HXStoreDocumentLibraryDocumentModel.h"

@interface HXStoreDocumentLibraryReviewViewController : HXStoreDocumentLibraryBaseViewController

/** 是否需要展示底部界面和右上角按钮 */
@property (nonatomic, assign) BOOL isNoNeedToShowBottomViewAndRightBarButton;

+ (instancetype)createReviewVCWithDocId:(NSString *)docIdStr;

@end
