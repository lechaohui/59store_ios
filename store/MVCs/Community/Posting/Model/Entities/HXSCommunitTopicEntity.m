//
//  HXSCommunitTopicEntity.m
//  store
//
//  Created by J006 on 16/4/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunitTopicEntity.h"

@implementation HXSCommunitTopicEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mappingList = @{@"idStr":            @"id",
                                  @"titleStr":         @"title",
                                  @"avatarStr":        @"avatar",
                                  @"introStr":         @"intro",
                                  @"weightNum":        @"weight",
                                  @"statusNum":        @"status",};
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mappingList];
}

@end
