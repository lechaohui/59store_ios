//
//  HXDBusinessItemViewModel.m
//  59dorm
//
//  Created by BeyondChao on 16/8/31.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXDBusinessItemViewModel.h"

@implementation HXDBusinessItemViewModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{
                              @"businessId":                        @"id",
                              @"businessType":                      @"type",
                              @"shopStatus":                         @"status",
                              @"badgeString":                       @"todo_acount",
                              };

    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mapping];
}

- (instancetype)initWithName:(NSString *)businessName imageName:(NSString *)imageName badgeString:(NSString *)badgeString businessType:(HXAvailableBusinessType)businessType isOpen:(BOOL)isOpen shopStatus:(NSNumber *)shopStatus {
   
    if (self = [super init]) {
        self.businessName  = businessName;
        self.iconImageName = imageName;
        self.badgeString   = badgeString;
        self.businessType  = businessType;
        self.open          = isOpen;
        self.shopStatus    = shopStatus;
    }
    return self;
}

+ (instancetype)businessItemEntityWithDictionary:(NSDictionary *)businessModel
{
    if ((nil == businessModel)
        || [businessModel isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    HXDBusinessItemViewModel *model = [[HXDBusinessItemViewModel alloc] initWithDictionary:businessModel error:nil];
    
    
    return model;
}


@end
