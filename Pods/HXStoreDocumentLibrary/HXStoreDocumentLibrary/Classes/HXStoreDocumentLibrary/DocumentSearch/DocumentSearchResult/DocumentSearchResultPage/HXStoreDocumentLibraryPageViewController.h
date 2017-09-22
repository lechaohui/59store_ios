//
//  HXStoreDocumentLibraryPageViewController.h
//  HXStoreDocumentLibrary_Example
//  带收藏按钮的Page界面
//  Created by J006 on 16/9/7.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXStoreDocumentLibraryDocListParamModel.h"

@interface HXStoreDocumentLibraryPageViewController : HXSBaseViewController

+ (instancetype)createDocumentLibraryPageVCWithIndex:(NSInteger)index
                                       andParamModel:(HXStoreDocumentLibraryDocListParamModel *)paramModel;

+ (instancetype)createDocumentLibraryPageVCWithIndex:(NSInteger)index
                                 andSearchParamModel:(HXStoreDocumentLibraryDocListParamModel *)paramModel;

@property (nonatomic, copy) void(^updateSelectionTitle)(NSInteger index);

@end
