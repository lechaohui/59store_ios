//
//  HXSMessageCate.m
//  store
//
//  Created by 格格 on 16/8/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMessageCate.h"

@implementation HXSMessageCate

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"cate_id"    , @"cateIdStr",
                             @"cate_name"  , @"cateNameStr",
                             @"icon"       , @"iconStr",
                             @"create_time", @"createTimeStr",
                             @"operation"  , @"operationStr",
                             @"message"    , @"messageItem", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

@end
