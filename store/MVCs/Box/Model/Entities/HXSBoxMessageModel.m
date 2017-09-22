//
//  HXSBoxMessageModel.m
//  store
//
//  Created by 格格 on 16/6/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBoxMessageModel.h"

@implementation HXSBoxMessagEvent

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"type",       @"typeNum",
                             @"button",     @"buttonArr", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSBoxMessagEvent alloc] initWithDictionary:object error:nil];
}

@end



@implementation HXSBoxMessageModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"message_id",        @"messageIdStr",
                             @"content",           @"contentStr",
                             @"create_time",       @"createTimeNum",
                             @"status",            @"statusNum",
                             @"type",              @"typeNum",
                             @"title",             @"titleStr",
                             @"icon",              @"iconStr",
                             @"event",             @"event", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSBoxMessageModel alloc] initWithDictionary:object error:nil];
}

@end
