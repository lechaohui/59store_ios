//
//  HXSCommissionEntity.m
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommissionEntity.h"

@implementation HXSCommissionEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{
                              @"typeIntNum":     @"type",
                              @"timeLongNum":    @"create_time",
                              @"amountIntNum":   @"change_money",
                              @"contentStr":     @"content",};
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSCommissionEntity alloc] initWithDictionary:object error:nil];
}

@end
