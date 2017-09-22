//
//  HXDSellerInfoModel.h
//  59dorm
//
//  Created by BeyondChao on 16/8/29.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HXDSellerIdentityModel <NSObject>

@end

@interface HXDSellerIdentityModel : HXBaseJSONModel

@property (nonatomic, strong) NSString *dormId;
@property (nonatomic, strong) NSString *mankeepId;

@end

@interface HXDSellerInfoViewModel : HXBaseJSONModel

/** 用户id */
@property (nonatomic, strong) NSNumber *uid;
/** 用户名称 */
@property (nonatomic, strong) NSString *nameStr;
/** 用户角色 */
@property (nonatomic, strong) NSNumber *roleNum; // 0-无角色，1-脉客，2-店长，3-店长&脉客
/** 头像链接 */
@property (nonatomic, strong) NSString *portraitStr;
/** 联系电话 */
@property (nonatomic, strong) NSString *phoneStr;
/** 店长资产 */
@property (nonatomic, strong) NSNumber *dormWalletAmountNum;
/** 脉客资产 */
@property (nonatomic, strong) NSNumber *mkWalletAmountNum;
/** 超级店长 */
@property (nonatomic, strong) NSNumber *powerSeller; //  0-不是，1-是

@property (nonatomic, strong) HXDSellerIdentityModel *sellerIdentity;

@end
