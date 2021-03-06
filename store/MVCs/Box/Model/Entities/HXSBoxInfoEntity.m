//
//  HXSBoxInfoEntity.m
//  store
//
//  Created by ArthurWang on 16/5/31.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBoxInfoEntity.h"

@implementation HXSBoxRelatedEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"username" , @"userNameStr",
                             @"phone"    , @"phoneStr",
                             @"dormentry_id" , @"dormentryIdNum",
                             @"address"  , @"addressStr",
                             @"room"     , @"roomStr",
                             @"gender"   , @"genderNum",
                             @"enrollment_year" , @"enrollmentYearNum", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSBoxRelatedEntity alloc] initWithDictionary:object error:nil];
}

@end


@implementation HXSBoxInfoEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"box_id"          , @"boxIdNum",
                             @"is_boxer"        , @"isBoxerNum",
                             @"batch_no"        , @"batchNoNum",
                             @"has_last_bill"   , @"hasLastBillNum",
                             @"shared_user_num" , @"sharedUserNum",
                             @"boxer_avatar"    , @"boxerAvatarStr",
                             @"status"          , @"statusNum",
                             @"dorm_info"       , @"dormInfo",
                             @"boxer_info"      , @"boxerInfo", nil];
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

+ (instancetype)objectFromJSONObject:(NSDictionary *)object
{
    return [[HXSBoxInfoEntity alloc] initWithDictionary:object error:nil];
}

@end
