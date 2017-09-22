//
//  HXDBankEntity.m
//  59dorm
//
//  Created by J006 on 16/3/2.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXDBankEntity.h"

@implementation HXDBankEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mappingList = @{@"bankIDStr":          @"bank_id",
                                  @"bankNameStr":        @"bank_name",
                                  @"bankImageStr":       @"bank_image",};
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mappingList];
}

@end
