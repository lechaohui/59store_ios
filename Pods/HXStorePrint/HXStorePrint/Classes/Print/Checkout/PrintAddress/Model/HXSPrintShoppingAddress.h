//
//  HXSShoppingAddress.h
//  store
//
//  Created by 格格 on 16/8/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXBaseJSONModel.h"


/** 收货地址性别 */
typedef NS_ENUM(NSInteger, HXSShoppingAddressGender)
{
    HXSShoppingAddressGenderFemale   = 0,  // 女
    HXSShoppingAddressGenderMale     = 1,  // 男
};

@interface HXSPrintShoppingAddress : HXBaseJSONModel

@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *contactNameStr;
@property (nonatomic, strong) NSString *contactPhoneStr;
@property (nonatomic, strong) NSString *genderStr;
@property (nonatomic, strong) NSString *provinceIdStr;
@property (nonatomic, strong) NSString *provinceNameStr;
@property (nonatomic, strong) NSString *zoneIdStr;
@property (nonatomic, strong) NSString *zoneNameStr;
@property (nonatomic, strong) NSString *cityIdStr;
@property (nonatomic, strong) NSString *cityNameStr;
@property (nonatomic, strong) NSString *siteIdStr;
@property (nonatomic, strong) NSString *siteNameStr;
@property (nonatomic, strong) NSString *dormentryZoneNameStr;
@property (nonatomic, strong) NSString *dormentryIdStr;
@property (nonatomic, strong) NSString *dormentryNameStr;
@property (nonatomic, strong) NSString *phoneStr;
@property (nonatomic, strong) NSString *detailAddressStr;

@end
