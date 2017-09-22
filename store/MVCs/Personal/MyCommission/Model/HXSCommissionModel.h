//
//  HXSCommissionModel.h
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSCommission.h"

static NSString * const kAccountDetail  = @"account/detail";

@interface HXSCommissionModel : NSObject

/**
 *  收支明细
 *
 *  @param page
 *  @param size
 *  @return
 */
+ (void)getCommissionRewardsWithPage:(NSNumber *)page
                                           size:(NSNumber *)size
                                      startTime:(NSNumber *)start_time
                                        endTime:(NSNumber *)end_time
                                       complete:(void(^)(HXSErrorCode code, NSString * message, HXSCommission *commission))block;

@end
