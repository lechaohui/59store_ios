//
//  HXSRootViewModel.h
//  store
//
//  Created by  黎明 on 16/8/16.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HXSRootTabModel;
@interface HXSRootViewModel : NSObject

/**
 *  网络请求获取tabBar的样式
 *
 *  @param block
 */
+ (void)getTabItemsPropertiesWithComplite:(void (^)(HXSRootTabModel *rootTabModel))block;

@end
