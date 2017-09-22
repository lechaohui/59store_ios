//
//  HXStoreDocumentLibraryShareTagSettingViewController.h
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/27.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXSBaseViewController.h"

@class HXStoreDocumentLibraryDocumentModel;

@protocol HXStoreDocumentLibraryShareTagSettingViewControllerDelegate <NSObject>

@optional

- (void)saveTags:(HXStoreDocumentLibraryDocumentModel *)docModel;

@end

@interface HXStoreDocumentLibraryShareTagSettingViewController : HXSBaseViewController

@property (nonatomic, weak) id <HXStoreDocumentLibraryShareTagSettingViewControllerDelegate> delegate;

+ (instancetype)createDocumentLibraryShareTagSettingWithDoc:(HXStoreDocumentLibraryDocumentModel *)docModel;

@end
