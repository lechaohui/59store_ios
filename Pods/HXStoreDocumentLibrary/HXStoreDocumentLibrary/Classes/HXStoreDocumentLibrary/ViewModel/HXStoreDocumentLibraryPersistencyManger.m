//
//  HXStoreDocumentLibraryPersistencyManger.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/13.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibraryPersistencyManger.h"
#import "HXSDocumentPersistencyManger.h"

//model
#import "HXSPrintDownloadsObjectEntity.h"

@interface HXStoreDocumentLibraryPersistencyManger()

@end

@implementation HXStoreDocumentLibraryPersistencyManger

- (void)saveLibraryDocument:(NSMutableArray *)array
                andFilePath:(NSString *)filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSError *error;
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:documentLibraryHomeFolderPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:folderPath])
    {
        [fileManager setAttributes:@{NSFileProtectionKey: NSFileProtectionCompleteUntilFirstUserAuthentication} ofItemAtPath:folderPath error:nil];
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    if(error)
        return;
    NSString *filename = [documentsDirectory stringByAppendingPathComponent:filePath];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    [data writeToFile:filename atomically:YES];
}

- (NSMutableArray *)loadLibrarySavedDocumentWithFilePath:(NSString *)filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filename = [documentsDirectory stringByAppendingPathComponent:filePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filename]) {
        return nil;
    }
    NSData *data = [NSData dataWithContentsOfFile:[documentsDirectory stringByAppendingString:filePath]];
    
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return array;
}

- (void)saveStarLibraryDocument:(HXStoreDocumentLibraryDocumentModel *)doc
                     toFilePath:(NSString *)filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSError *error;
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:documentLibraryHomeFolderPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:folderPath])
    {
        [fileManager setAttributes:@{NSFileProtectionKey: NSFileProtectionCompleteUntilFirstUserAuthentication} ofItemAtPath:folderPath error:nil];
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    if(error)
        return;
    
    NSData *data = [NSData dataWithContentsOfFile:[documentsDirectory stringByAppendingString:filePath]];
    NSString *filename = [documentsDirectory stringByAppendingPathComponent:filePath];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if(!array) {
        array = [[NSMutableArray alloc]init];
    }
    BOOL hasGotDocModel = NO;
    for (HXStoreDocumentLibraryDocumentModel *baseModel in array) {
        if([baseModel.docIdStr isEqualToString:doc.docIdStr]) {
            [array replaceObjectAtIndex:[array indexOfObject:baseModel]
                             withObject:doc];
            hasGotDocModel = YES;
            break;
        }
    }
    if(!hasGotDocModel) {
        [array addObject:doc];
    }
    
    data = [NSKeyedArchiver archivedDataWithRootObject:array];
    [data writeToFile:filename atomically:YES];
}

- (void)removeStarLibraryDocument:(HXStoreDocumentLibraryDocumentModel *)doc
                       toFilePath:(NSString *)filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filename = [documentsDirectory stringByAppendingPathComponent:filePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filename]) {
        return;
    }
    NSData *data = [NSData dataWithContentsOfFile:[documentsDirectory stringByAppendingString:filePath]];
    
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if(!array || array.count == 0) {
        return;
    }
    
    for (HXStoreDocumentLibraryDocumentModel *baseModel in array) {
        if([baseModel.docIdStr isEqualToString:doc.docIdStr]) {
            [array removeObject:baseModel];
            break;
        }
    }
    
    data = [NSKeyedArchiver archivedDataWithRootObject:array];
    [data writeToFile:filename atomically:YES];
}

#pragma mark - remove file

- (void)removeDocFileWithModel:(HXStoreDocumentLibraryDocumentModel *)doc
{
    if(!doc.archiveDocPathURL) {
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:[doc.archiveDocPathURL absoluteString]];
    if (isExist) {
        NSError *err;
        [fileManager removeItemAtPath:[doc.archiveDocPathURL absoluteString]
                                error:&err];
        if(err) {
            DLog(@"del file error =%@",err);
        }
        
    }
}

- (NSMutableArray<NSString *> *)copyDocArrayToPrintQueue;
{
    NSMutableArray<HXStoreDocumentLibraryDocumentModel *> *docModelArray = [self loadLibrarySavedDocumentWithFilePath:documentLibraryAddToPrintDocFilePath];
    
    if(!docModelArray
       || docModelArray.count == 0) {
        return nil;
    }
    
    HXSDocumentPersistencyManger *printPersistencyManager = [[HXSDocumentPersistencyManger alloc]init];
    NSMutableArray *pdfmd5StrArray = [[NSMutableArray alloc]init];
    NSMutableArray *array = [printPersistencyManager loadTheSavedDocument];
    
    if(!array) {
        array = [[NSMutableArray alloc]init];
    }
    
    for (HXStoreDocumentLibraryDocumentModel *docModel in docModelArray) {
        HXSPrintDownloadsObjectEntity *downLoadObjecEntity = [[HXSPrintDownloadsObjectEntity alloc]init];
        downLoadObjecEntity.archiveDocNameStr           = docModel.docTitleStr;
        downLoadObjecEntity.archiveDocLocalURLStr       = docModel.archiveDocPathStr;
        downLoadObjecEntity.archiveDocTypeNum           = [self getDocTypeFromDocSuffixStr:docModel.docSuffixStr];
        downLoadObjecEntity.localDocMd5Str              = docModel.pdfMd5Str;
        downLoadObjecEntity.uploadType                  = kHXSDocumentDownloadTypeUploadSucc;
        downLoadObjecEntity.archiveDocPathStr           = docModel.urlStr;
        downLoadObjecEntity.archiveDocMd5Str            = docModel.sourceMd5Str;
        downLoadObjecEntity.archiveDocSizeNum           = docModel.sourceSizeNum;
        downLoadObjecEntity.mimeTypeStr                 = [self getMimeTypeFromDocumentType:downLoadObjecEntity.archiveDocTypeNum];
        downLoadObjecEntity.upLoadDate                  = [NSDate date];
        downLoadObjecEntity.isFromLibraryDocumentNum    = [NSNumber numberWithBool:YES];
        [pdfmd5StrArray addObject:docModel.pdfMd5Str];
        
        HXSMyPrintOrderItem *printOrderItem         = [[HXSMyPrintOrderItem alloc]init];
        printOrderItem.pdfPathStr                   = docModel.urlStr;
        printOrderItem.pdfMd5Str                    = docModel.pdfMd5Str;
        printOrderItem.pdfSizeLongNum               = docModel.sourceSizeNum;
        printOrderItem.originPathStr                = docModel.urlStr;
        printOrderItem.originMd5Str                 = docModel.pdfMd5Str;
        printOrderItem.fileNameStr                  = docModel.pdfNameStr;
        printOrderItem.archiveDocTypeNum            = [self getDocTypeFromDocSuffixStr:docModel.docSuffixStr];
        printOrderItem.pageIntNum                   = docModel.docNum;
        printOrderItem.isFromLibraryDocumentNum     = [NSNumber numberWithBool:YES];
        printOrderItem.docIdStr                     = docModel.docIdStr;
        
        downLoadObjecEntity.uploadAndCartDocEntity  = printOrderItem;
        
        [array addObject:downLoadObjecEntity];
    }
    [printPersistencyManager saveTheDocument:array];

    [docModelArray removeAllObjects];
    [self saveLibraryDocument:docModelArray
                  andFilePath:documentLibraryAddToPrintDocFilePath];
    
    return pdfmd5StrArray;
}

- (void)addDocumentToPrintQueueWithDoc:(HXStoreDocumentLibraryDocumentModel *)docModel
                                 andVC:(UIViewController *)vc
{
    HXSDocumentPersistencyManger *manager = [[HXSDocumentPersistencyManger alloc]init];
    NSMutableArray *array           = [self loadLibrarySavedDocumentWithFilePath:documentLibraryAddToPrintDocFilePath];
    NSMutableArray *downLoadArray   = [manager loadTheSavedDocument];
    if(!array) {
        array = [[NSMutableArray alloc]init];
    }
    
    //检查已经加入到打印队列的文件中是否有重复
    for (HXStoreDocumentLibraryDocumentModel *model in array) {
        if([model.docIdStr isEqualToString:docModel.docIdStr]) {
            [MBProgressHUD showInViewWithoutIndicator:vc.view
                                               status:@"已经添加过啦~"
                                           afterDelay:1.5];
            return;
        }
    }
    
    //检查本地已经下载的文件中是否有重复
    for (HXSPrintDownloadsObjectEntity *downLoadEntity in downLoadArray) {
        if([downLoadEntity.uploadAndCartDocEntity.pdfMd5Str isEqualToString:docModel.pdfMd5Str]) {
            [MBProgressHUD showInViewWithoutIndicator:vc.view
                                               status:@"已经添加过啦~"
                                           afterDelay:1.5];
            return;
        }
    }
    
    //添加到打印队列
    [array addObject:docModel];
    [self saveLibraryDocument:array
                  andFilePath:documentLibraryAddToPrintDocFilePath];
    [MBProgressHUD showInViewWithoutIndicator:vc.view
                                       status:@"添加至打印队伍成功！"
                                   afterDelay:1.5];
}

- (void)checkShareDocModelArrayAndSaveLocalDownloadEntity:(NSMutableArray<HXStoreDocumentLibraryDocumentModel *> *)docModelArray
                               andWithPrintOrderItemArray:(NSMutableArray<HXSMyPrintOrderItem *> *)printOrderItemArray
{
    if(!docModelArray
       || docModelArray.count == 0
       || !printOrderItemArray
       || printOrderItemArray.count == 0) {
        return;
    }
    
    for (HXStoreDocumentLibraryDocumentModel *docModel in docModelArray) {
        if(!docModel.isShowTagsAndPrice) {
            continue;
        }
        
        for (HXSMyPrintOrderItem *orderItem in printOrderItemArray) {
            if([orderItem.pdfMd5Str isEqualToString:docModel.pdfMd5Str]) {
                orderItem.isFromLibraryDocumentNum = [[NSNumber alloc]initWithBool:YES];
                break;
            }
        }
    }
    
    //存储到本地
    HXSDocumentPersistencyManger *printPersistencyManager = [[HXSDocumentPersistencyManger alloc]init];
    NSMutableArray *downLoadArray = [printPersistencyManager loadTheSavedDocument];
    for (HXSPrintDownloadsObjectEntity *entity in downLoadArray) {
        for (HXSMyPrintOrderItem *orderItem in printOrderItemArray) {
            if([entity.uploadAndCartDocEntity.pdfMd5Str isEqualToString:orderItem.pdfMd5Str]) {
                entity.uploadAndCartDocEntity.isFromLibraryDocumentNum = orderItem.isFromLibraryDocumentNum;
                entity.isFromLibraryDocumentNum = orderItem.isFromLibraryDocumentNum;
                break;
            }
        }
    }
    
    [printPersistencyManager saveTheDocument:downLoadArray];
}

#pragma mark - private methods

- (HXSDocumentType)getDocTypeFromDocSuffixStr:(NSString *)suffixStr
{
    if([suffixStr hasSuffix:@"doc"]
       || [suffixStr hasSuffix:@"docx"]) {
        return HXSDocumentTypeDoc;
    } else if([suffixStr hasSuffix:@"pdf"]) {
        return HXSDocumentTypePdf;
    } else if([suffixStr hasSuffix:@"ppt"]
              || [suffixStr hasSuffix:@"pptx"]) {
        return HXSDocumentTypePPT;
    } else {
        return HXSDocumentTypePdf;
    }
}

- (NSString *)getMimeTypeFromDocumentType:(HXSDocumentType)type
{
    NSString *mimeTypeStr;
    
    switch (type) {
        case HXSDocumentTypeDoc:
            
            mimeTypeStr = @"application/msword";
            
            break;
            
        case HXSDocumentTypePPT:
            
            mimeTypeStr = @"application/vnd.openxmlformats-officedocument.presentationml.presentation";
            
            break;
            
        default:
            
            mimeTypeStr = @"application/pdf";
            
            break;
    }
    
    return mimeTypeStr;
}

@end
