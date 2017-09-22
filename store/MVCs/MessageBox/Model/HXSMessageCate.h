//
//  HXSMessageCate.h
//  store
//
//  Created by 格格 on 16/8/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXBaseJSONModel.h"

#import "HXSMessageItem.h"

/** 进入消息列表是否需要登录 */
typedef NS_ENUM(NSInteger, HXSMessageCatePermissionType)
{
    HXSMessageCatePermissionTypeNeedLogin   = 0, // 需要登录
    HXSMessageCatePermissionTypeAll         = 1, // 不需要登录
};


@interface HXSMessageCate : HXBaseJSONModel

@property (nonatomic, strong) NSString *cateIdStr;
@property (nonatomic, strong) NSString *cateNameStr;
@property (nonatomic, strong) NSString *iconStr;
@property (nonatomic, strong) NSString *createTimeStr;
@property (nonatomic, strong) NSString *permissionStr;
@property (nonatomic, strong) HXSMessageItem *messageItem;

@end
