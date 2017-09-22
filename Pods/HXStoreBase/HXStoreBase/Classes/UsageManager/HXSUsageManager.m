//
//  HXSUsageManager.m
//  store
//
//  Created by hudezhi on 15/9/11.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSUsageManager.h"

#import "UMMobClick/MobClick.h"

//static HXSUsageManager * usageInstance;
// =================================================================

@interface HXSUsageManager ()

@end

// =================================================================

@implementation HXSUsageManager

+ (void) trackEvent:(NSString *)eventID parameter:(NSDictionary *)param
{
    if(param.allKeys.count > 0) {
        [MobClick event:eventID attributes:param];
    }
    else {
        [MobClick event:eventID];
    }
}

@end
