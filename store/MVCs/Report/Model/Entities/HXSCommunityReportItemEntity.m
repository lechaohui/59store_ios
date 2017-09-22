//
//  HXSCommunityReportItemEntity.m
//  store
//
//  Created by J006 on 16/5/8.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityReportItemEntity.h"

@implementation HXSCommunityReportItemEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mappingList = @{@"idStr":            @"id",
                                  @"reasonStr":        @"reason",};
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mappingList];
}

@end
