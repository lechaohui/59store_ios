//
//  HXSPrintExpectTimeEntity.m
//  store
//
//  Created by J.006 on 16/8/25.
//  Copyright (c) 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintExpectTimeEntity.h"

@implementation HXSPrintExpectTimeEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"expectTimeTypeIntNum",        @"type",
                             @"expectTimeNameStr",           @"name",
                             @"expectStartTimeNum",          @"expect_start_time",
                             @"expectEndTimeNum",            @"expect_end_time", nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

@end
