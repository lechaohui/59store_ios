//
//  HXStoreDocumentLibraryBaseViewController.h
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/13.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@interface HXStoreDocumentLibraryBaseViewController : HXSBaseViewController

@property (nonatomic ,strong) UIBarButtonItem *rightBarButtonItem;

- (void)setBadgeStr:(NSInteger)badgeValue
 andNoNeedAnimation:(BOOL)noNeedAnimation;

- (void)refreshBadgeActionWithNoNeedAnimation:(BOOL)noNeedAnimation;

@end
