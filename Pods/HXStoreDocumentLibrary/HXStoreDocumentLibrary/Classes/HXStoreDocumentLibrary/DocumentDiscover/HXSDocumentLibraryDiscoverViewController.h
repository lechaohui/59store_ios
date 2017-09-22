//
//  HXSDocumentLibraryDiscoverViewController.h
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/10.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@interface HXSDocumentLibraryDiscoverViewController : HXSBaseViewController

+ (instancetype)createDocumentDiscoverVCWithIndex:(NSInteger)index;

@property (nonatomic, copy) void(^updateSelectionTitle)(NSInteger index);
@property (nonatomic, copy) void(^scrollviewScrolled)(CGPoint contentOffset);

@end
