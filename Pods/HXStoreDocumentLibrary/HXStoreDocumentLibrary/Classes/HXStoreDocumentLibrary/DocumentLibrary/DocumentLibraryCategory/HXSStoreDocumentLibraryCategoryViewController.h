//
//  HXSStoreDocumentLibraryCategoryViewController.h
//  HXStoreDocumentLibrary_Example
//  一级分类
//  Created by J006 on 16/9/8.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibraryBaseViewController.h"
#import "HXStoreDocumentLibraryCategoryListModel.h"

@interface HXSStoreDocumentLibraryCategoryViewController : HXStoreDocumentLibraryBaseViewController

+ (instancetype)createDocumentLibraryCategorVCWithListModel:(HXStoreDocumentLibraryCategoryListModel *)listModel;

@end
