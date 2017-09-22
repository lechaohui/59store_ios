//
//  HXDSellerInfoModel.m
//  59dorm
//
//  Created by BeyondChao on 16/8/29.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXDSellerInfoViewModel.h"

@implementation HXDSellerInfoViewModel

+ (JSONKeyMapper *)keyMapper
{
    
    NSDictionary *itemMapping = @{
                                  @"uid":                 @"uid",
                                  @"portraitStr":         @"portrait",
                                  @"dormWalletAmountNum": @"dorm_assets",
                                  @"mkWalletAmountNum":   @"mk_assets",
                                  @"roleNum":             @"role",
                                  @"powerSeller":        @"powerseller",
                                  @"nameStr":            @"name",
                                  @"phoneStr":           @"phone",
                                  @"sellerIdentity":     @"role_ids",
                                  };

    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:itemMapping];
}

@end


@implementation HXDSellerIdentityModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *itemMapping = @{
                                  @"mankeepId":           @"mk_id",
                                  @"dormId":              @"dorm_id",
                                  };
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:itemMapping];
}

@end
