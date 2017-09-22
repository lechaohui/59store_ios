//
//  HXSRootViewModel.m
//  store
//
//  Created by  黎明 on 16/8/16.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSRootViewModel.h"
#import "HXSRootTabModel.h"

#define FILE_PATH  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject

static NSString * const kFileName = @"tabBar.config";
static NSString * const kAppTabList = @"/app/tab/list";



@implementation HXSRootViewModel

+ (void)getTabItemsPropertiesWithComplite:(void (^)(HXSRootTabModel *rootTabModel))block
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];

    NSString *appBuildVersion = [infoDict objectForKey:@"CFBundleVersion"];

    NSDictionary *dict = @{@"app_version":appBuildVersion};

    HXSRootTabModel *rootTabModel = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:[FILE_PATH stringByAppendingPathComponent:kFileName]]) {
        rootTabModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[FILE_PATH stringByAppendingPathComponent:kFileName]];
        
        NSString *timestamp = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
        
        long long time = [timestamp longLongValue];
        
        //有效期到了之后就删掉本地数据
        if (time > rootTabModel.expireTime.longLongValue) {
            [fileManager removeItemAtPath:[FILE_PATH stringByAppendingPathComponent:kFileName] error:nil];
            rootTabModel = nil;
        }
        
        block(rootTabModel);
    }
    
    [HXStoreWebService getRequest:kAppTabList
                       parameters:dict
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if(kHXSNoError == status) {
                                  HXSRootTabModel *model = [[HXSRootTabModel alloc] initWithDictionary:data error:nil];
                                  
                                  if ([model.expireTime longLongValue] != [rootTabModel.expireTime longLongValue]) {
                                      [NSKeyedArchiver archiveRootObject:model toFile:[FILE_PATH stringByAppendingPathComponent:kFileName]];
                                      block(model);
                                  }
                              }
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              // Do nothing
                          }];
}

@end
