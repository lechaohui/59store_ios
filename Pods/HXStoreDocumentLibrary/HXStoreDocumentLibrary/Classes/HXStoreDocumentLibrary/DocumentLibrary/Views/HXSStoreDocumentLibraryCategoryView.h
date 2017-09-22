//
//  HXSStoreDocumentLibraryCategoryView.h
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/8.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXStoreDocumentLibraryCategoryListModel.h"
#import "HXStoreDocumentLibraryImport.h"

@protocol HXSStoreDocumentLibraryCategoryViewDelegate <NSObject>

@optional

/**
 *  单个按钮点击代理方法
 *
 *  @param listModel
 *  @param model
 */
- (void)categoryButtonClick:(HXStoreDocumentLibraryCategoryListModel *)listModel
                andCategory:(HXStoreDocumentLibraryCategoryModel *)model;

/**
 *  更多分类按钮点击代理方法
 *
 *  @param listModel 
 */
- (void)categoryMoreButtonClick:(HXStoreDocumentLibraryCategoryListModel *)listModel;

@end

@interface HXSStoreDocumentLibraryCategoryView : UIView

@property (nonatomic, weak) id<HXSStoreDocumentLibraryCategoryViewDelegate> delegate;

+ (instancetype)initLibraryCategoryViewWithCategoryList:(HXStoreDocumentLibraryCategoryListModel *)categoryListModel
                                           andIsShowAll:(BOOL)isShowAll;

@end
