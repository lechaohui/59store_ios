//
//  HXSStoreDocumentLibraryChildCategoryViewController.h
//  HXStoreDocumentLibrary_Example
//  二级分类界面
//  Created by J006 on 16/9/8.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXStoreDocumentLibraryBaseViewController.h"

@interface HXSStoreDocumentLibraryChildCategoryViewController : HXStoreDocumentLibraryBaseViewController

+ (instancetype)createDocumentLibraryChiledCategorVCWithCategoryId:(NSNumber *)secondCategoryId
                                                      andTitleName:(NSString *)titleNameStr;

@end
