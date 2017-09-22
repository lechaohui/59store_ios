//
//  HXSKnightInfo.h
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSCashBankInfo : HXBaseJSONModel

@property (nonatomic, strong) NSString *bankUserNameStr;
@property (nonatomic, strong) NSString *bankCardNoStr;
@property (nonatomic, strong) NSString *bankCodeStr;
@property (nonatomic, strong) NSString *bankCityStr;
@property (nonatomic, strong) NSString *bankCardIdStr;
@property (nonatomic, strong) NSString *bankSiteStr;
@property (nonatomic, strong) NSString *bankNameStr;
@property (nonatomic, strong) NSString *bankIconStr;

+ (id)objectFromJSONObject:(NSDictionary *)object;

@end
