//
//  HXSSnacksCategoryModel.h
//  store
//
//  Created by  黎明 on 16/8/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <HXBaseJSONModel.h>

@protocol HXSSnacksCategoryModel
@end

@interface HXSSnacksCategoryModelSet: HXBaseJSONModel

@property (nonatomic ,strong) NSArray<HXSSnacksCategoryModel> *categoriesArr;
@property (nonatomic ,strong) NSArray<HXSSnacksCategoryModel> *recommendedCategoriesArr;

@end


@interface HXSSnacksCategoryModel : HXBaseJSONModel

@property (nonatomic, strong) NSNumber *categoryId;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSNumber *categoryType;

@end


