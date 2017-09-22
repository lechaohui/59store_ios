//
//  HXStoreDocumentSearchViewModel.h
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/6.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXStoreDocumentLibraryImport.h"

@interface HXStoreDocumentSearchViewModel : NSObject

/**
 *  返回文库搜索历史集合
 *
 *  @return
 */
- (NSArray *)documentSearchHistoryList;

/**
 *  添加文库搜索历史记录
 *
 *  @param address
 */
- (void)addDocumentSearchHistory:(NSString *)searchNameStr;

/**
 *  读取图片名称
 *
 *  @param nameStr
 *
 *  @return
 */
- (UIImage *)imageFromNewName:(NSString *)nameStr;

/**
 *  设置指定的document文件夹
 *
 *  @return
 */
- (NSURL *)createDocumentFolderURL;

- (NSString *)createPDFNameFromSourceName:(NSString *)sourceName;

@end
