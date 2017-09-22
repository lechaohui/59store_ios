//
//  HXStoreDocumentLibraryPersistencyManger.h
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/13.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

//model
#import "HXStoreDocumentLibraryDocumentModel.h"
#import "HXSMyPrintOrderItem.h"

//others
#import "HXStoreDocumentLibraryImport.h"

#define documentLibraryHomeFolderPath           @"/DocumentDownloadFiles"
#define documentLibraryAddToPrintDocFilePath    @"/DocumentDownloadFiles/addToPrintDocuments.bin"
#define documentLibraryStarDocFilePath          @"/DocumentDownloadFiles/StarDocuments.bin"

@interface HXStoreDocumentLibraryPersistencyManger : NSObject

/**
 *  存储归档的数组
 *
 *  @param array
 *  @param filePath
 */
- (void)saveLibraryDocument:(NSMutableArray *)array
                andFilePath:(NSString *)filePath;
/**
 *  读取归档的数组
 *
 *  @return
 */
- (NSMutableArray *)loadLibrarySavedDocumentWithFilePath:(NSString *)filePath;

/**
 *  将当前已经加入队列的文档转换成可以被打印的对象并且清空"打印队列"
 *
 *  @param docModelArray
 */
- (NSMutableArray<NSString *> *)copyDocArrayToPrintQueue;

/**
 *  将指定的文档对象加入到打印队列
 *
 *  @return
 */
- (void)addDocumentToPrintQueueWithDoc:(HXStoreDocumentLibraryDocumentModel *)docModel
                                 andVC:(UIViewController *)vc;

/**
 *  检查已经分享成功的doc,并保存"已加入文库"的状态到本地文件
 *
 *  @return
 */
- (void)checkShareDocModelArrayAndSaveLocalDownloadEntity:(NSMutableArray<HXStoreDocumentLibraryDocumentModel *> *)docModelArray
                               andWithPrintOrderItemArray:(NSMutableArray<HXSMyPrintOrderItem *> *)printOrderItemArray;

@end
