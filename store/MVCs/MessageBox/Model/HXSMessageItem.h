//
//  HXSMessageItem.h
//  store
//
//  Created by 格格 on 16/8/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXBaseJSONModel.h"

/** 消息是否可删除 */
typedef NS_ENUM(NSInteger, HXSMessageCateOperation)
{
    HXSMessageCateOperationAvailable    = 0, // 消息可删除
    HXSMessageCateOperationUnavailable  = 1, // 消息不可删除
};

/** 消息已读未读状态 */
typedef NS_ENUM(NSInteger, HXSMessageItemStatus)
{
    HXSMessageItemStatusUnRead   = 0, // 未读
    HXSMessageItemStatusReaded   = 1, // 已读
};

@protocol HXSMessageItem <NSObject>

@end

@interface HXSMessageItem : HXBaseJSONModel

@property (nonatomic, strong) NSString *messageIdStr;
@property (nonatomic, strong) NSString *contentStr;
@property (nonatomic, strong) NSString *createTimeStr;
@property (nonatomic, strong) NSString *statusStr;
@property (nonatomic, strong) NSString *typeStr;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *iconStr;
@property (nonatomic, strong) NSString *cateIdStr;
@property (nonatomic, strong) NSString *linkStr;
@property (nonatomic, strong) NSString *imageStr;
@property (nonatomic, strong) NSString *operationStr;

// 以下属性不从服务器取值，用于计算展示cell的高度
/** 图片宽高比 */
@property (nonatomic, assign) CGFloat aspectRatio;
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, assign) CGFloat contentTextHeight;
@property (nonatomic, assign) CGFloat cellHeight;

@end
