//
//  HXStoreDocumentSearchViewModel.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/6.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentSearchViewModel.h"

#define documentHomeFolderPath @"/DocumentDownloadFiles"

NSInteger const kSearchListLimit = 5;//最大历史记录为5条

NSString * const kHXSDocumentLibrarySearchHistoryKey    = @"kHXSDocumentLibrarySearchHistoryKey";

@implementation HXStoreDocumentSearchViewModel

- (NSArray *)documentSearchHistoryList
{
    NSArray *list = [[NSUserDefaults standardUserDefaults] objectForKey: kHXSDocumentLibrarySearchHistoryKey];
    return list;
}

- (void)addDocumentSearchHistory:(NSString *)searchNameStr
{
    NSArray *list = [[NSUserDefaults standardUserDefaults] objectForKey: kHXSDocumentLibrarySearchHistoryKey];
    NSMutableArray *searchList;
    if (list.count > 0) {
        searchList = [NSMutableArray arrayWithArray:list];
        NSInteger idx = [searchList indexOfObject:searchNameStr];
        if (idx >= 0 && idx < list.count) {
            [searchList removeObjectAtIndex:idx];
        }
        
        [searchList insertObject:searchNameStr atIndex:0];
        if (searchList.count > kSearchListLimit) {
            [searchList removeLastObject];
        }
    }
    else {
        searchList = [NSMutableArray arrayWithObject:searchNameStr];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:searchList forKey:kHXSDocumentLibrarySearchHistoryKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (UIImage *)imageFromNewName:(NSString *)nameStr
{
    UIImage *image = [UIImage imageNamed:nameStr];
    
    if(!image)
    {
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
        {
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSString *bundlePath = [bundle pathForResource:@"HXStoreDocumentLibrary" ofType:@"bundle"];
            if (bundlePath) {
                bundle = [NSBundle bundleWithPath:bundlePath];
            }
            UIImage *imageNew = [UIImage imageNamed:nameStr
                                           inBundle:bundle
                      compatibleWithTraitCollection:nil];
            
            return imageNew;
        }
    }
    
    return image;
}

- (NSURL *)createDocumentFolderURL
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSError *error;
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:documentHomeFolderPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    NSURL *documentPath = [NSURL fileURLWithPath:dataPath];
    
    return documentPath;
}

- (NSString *)createPDFNameFromSourceName:(NSString *)sourceName
{
    NSString *fileName = [sourceName stringByDeletingPathExtension];
    
    return fileName;
}

@end
