//
//  HXDBusinessItemViewModel.h
//  59dorm
//
//  Created by BeyondChao on 16/8/31.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXDBusinessItemViewModel : HXBaseJSONModel

/** 业务名称 */
@property (nonatomic, copy) NSString *businessName;
/** 业务id */
@property (nonatomic, strong) NSNumber *businessId; // 对应盒子id店铺id
/** 业务图片名 */
@property (nonatomic, copy) NSString *iconImageName;
/** 是否正在营业 */
@property (nonatomic, strong)NSNumber *shopStatus; // 状态，云印店之后新增：type为打印的话0-关店，1-营业中，2-可预定
/** 是否开通 */
@property (nonatomic, getter=isOpen) BOOL open;
/** badge */
@property (nonatomic, copy) NSString *badgeString;
/** 业务类型 */
@property (nonatomic, assign) HXAvailableBusinessType businessType;

- (instancetype)initWithName:(NSString *)businessName
                   imageName:(NSString *)imageName
                  badgeString:(NSString *)badgeString
                businessType:(HXAvailableBusinessType)businessType
                      isOpen:(BOOL)isOpen
                   shopStatus:(NSNumber *)shopStatus;

+ (instancetype)businessItemEntityWithDictionary:(NSDictionary *)businessModel;

@end
