//
//  HXSSnacksCategoryModel.m
//  store
//
//  Created by  黎明 on 16/8/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSSnacksCategoryModelSet.h"

@implementation HXSSnacksCategoryModelSet

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *dic = @{
                          @"recommendedCategoriesArr" : @"recommended_categories",
                          @"categoriesArr"            : @"categories"
                          };
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:dic];
}

@end


@implementation HXSSnacksCategoryModel

+ (JSONKeyMapper *)keyMapper
{
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end


