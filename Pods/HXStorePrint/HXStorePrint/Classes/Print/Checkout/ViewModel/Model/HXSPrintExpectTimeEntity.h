//
//  HXSPrintExpectTimeEntity.h
//  store
//
//  Created by J.006 on 16/8/25.
//  Copyright (c) 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXBaseJSONModel.h"

typedef enum : NSUInteger {
    kHXSExpectTimeTypeImmediately = 2,
    kHXSExpectTimeTypeBook        = 3,
} HXSExpectTimeType;

@interface HXSPrintExpectTimeEntity : HXBaseJSONModel

/** 类型 2立即送出 3预订 */
@property (nonatomic, strong) NSNumber *expectTimeTypeIntNum;
/** 显示字段"立即送出" */
@property (nonatomic, strong) NSString *expectTimeNameStr;
/** 开始时间 */
@property (nonatomic, strong) NSNumber *expectStartTimeNum;
/** 结束时间 */
@property (nonatomic, strong) NSNumber *expectEndTimeNum;

@end
