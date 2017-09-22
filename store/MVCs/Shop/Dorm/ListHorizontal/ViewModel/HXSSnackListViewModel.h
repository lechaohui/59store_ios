//
//  HXSSnackViewModel.h
//  store
//
//  Created by  黎明 on 16/8/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSSnacksCategoryModelSet.h"

@interface HXSSnackListViewModel : NSObject

+ (void)fechCategoryListWith:(NSNumber *)shopId
                    shopType:(NSNumber *)shopType
                    complete:(void (^)(HXSErrorCode status, NSString *message,
                                       HXSSnacksCategoryModelSet *snacksCategoryModelSet))block;

+ (void)fetchGoodsCategoryListWith:(NSNumber *)categoryId
                             shopId:(NSNumber *)shopId
                       categoryType:(NSNumber *)type
                           starPage:(NSNumber *)page
                         numPerPage:(NSNumber *)num_per_page
                           complete:(void (^)(HXSErrorCode status, NSString *message, NSArray *slideArr))block;


@end
