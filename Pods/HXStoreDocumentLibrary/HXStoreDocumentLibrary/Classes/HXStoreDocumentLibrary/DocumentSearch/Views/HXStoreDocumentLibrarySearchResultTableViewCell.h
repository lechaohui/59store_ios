//
//  HXStoreDocumentLibrarySearchResultTableViewCell.h
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/7.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, kDocumentSearchResultCellType) {
    kDocumentSearchResultCellTypeHistory   = 0,//搜索历史
    kDocumentSearchResultCellTypeRecommend = 1,//热门推荐
    kDocumentSearchResultCellTypeMain      = 2//搜索结果
};

@interface HXStoreDocumentLibrarySearchResultTableViewCell : UITableViewCell

- (void)initDocumentLibrarySearchResultTableViewCellWithType:(kDocumentSearchResultCellType)type
                                                    andTitle:(NSString *)titleStr;

@end
