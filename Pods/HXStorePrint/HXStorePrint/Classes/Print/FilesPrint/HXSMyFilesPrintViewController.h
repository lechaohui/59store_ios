//
//  HXSMyFilesPrintViewController.h
//  store
//
//  Created by J006 on 16/5/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSPrintHeaderImport.h"

@interface HXSMyFilesPrintViewController : HXSBaseViewController

+ (instancetype)createFilesPrintVCWithEntity:(HXSShopEntity *)shopEntity;

+ (instancetype)createFilesPrintVCWithURL:(NSURL *)url;

- (void)refreshThePrintVCWithURL:(NSURL *)url;

@end
