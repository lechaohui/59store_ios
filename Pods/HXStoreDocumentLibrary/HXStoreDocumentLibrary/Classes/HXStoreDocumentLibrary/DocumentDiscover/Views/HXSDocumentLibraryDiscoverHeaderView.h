//
//  HXSDocumentLibraryDiscoverHeaderView.h
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/10.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXStoreDocumentLibraryDocumentModel.h"

typedef NS_ENUM(NSInteger, HXSDocumentLibraryDiscoverHeaderType) {
    HXSDocumentLibraryDiscoverHeaderTypeSuppose         = 1,
    HXSDocumentLibraryDiscoverHeaderTypeNearby          = 2,
    HXSDocumentLibraryDiscoverHeaderTypeRecommend       = 3
};

@protocol HXSDocumentLibraryDiscoverHeaderViewDelegate <NSObject>

@optional

/**
 *  代理方法 通知刷新"发现"
 *
 *  @param Section
 *  @param docList
 */
- (void)reloadFindingWithSection:(NSInteger)section
                      andDocList:(NSArray<HXStoreDocumentLibraryDocumentModel *> *)docList;

@end

@interface HXSDocumentLibraryDiscoverHeaderView : UIView

@property (nonatomic, weak) id<HXSDocumentLibraryDiscoverHeaderViewDelegate> delegate;

+ (instancetype)initWithType:(NSNumber *)type
                   andOffset:(NSNumber *)offSet
                    andLimit:(NSNumber *)limitNum
                    andTitle:(NSString *)title;

@end
