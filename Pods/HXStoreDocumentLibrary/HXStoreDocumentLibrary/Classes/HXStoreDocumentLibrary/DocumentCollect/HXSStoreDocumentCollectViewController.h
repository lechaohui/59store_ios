//
//  HXSStoreDocumentCollectViewController.h
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/6.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@protocol HXSStoreDocumentCollectViewControllerDelegate <NSObject>

@optional

- (void)refreshBadge;

@end

@interface HXSStoreDocumentCollectViewController : HXSBaseViewController

+ (instancetype)createDocumentCollectVCWithIndex:(NSInteger)index;

@property (nonatomic, copy) void(^updateSelectionTitle)(NSInteger index);
@property (nonatomic, copy) void(^scrollviewScrolled)(CGPoint contentOffset);
@property (nonatomic, weak, readwrite) id <HXSStoreDocumentCollectViewControllerDelegate> delegate;


@end
