//
//  HXSTarget_DocumentLibrary.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/26.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXSTarget_doc.h"
#import "HXStoreDocumentLibraryMainViewController.h"

@implementation HXSTarget_doc

- (UIViewController *)Action_library:(NSDictionary *)paramsDic
{    
    HXStoreDocumentLibraryMainViewController *docLibraryMainVC = [HXStoreDocumentLibraryMainViewController createDocumentLibraryMainVC];
    
    return docLibraryMainVC;
}

@end
