//
//  HXSMessageBoxViewModel.h
//  store
//
//  Created by 格格 on 16/8/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSMessageCate.h"

static NSString * const kUserMessageCateList = @"user/message/cate/list"; // 获取所有消息分类信息
static NSString * const kUserMessageList     = @"user/message/list";      // 获取某个分类下的所有消息
static NSString * const kUserMessageDelete   = @"user/message/delete";    // 删除消息
static NSString * const kUserMessageRead     = @"user/message/read";      // 把消息变为已读

@interface HXSMessageBoxViewModel : NSObject

/**
 * 获取所有消息分类信息
 */
+ (void)fetchMessageCateListComplete:(void (^)(HXSErrorCode code, NSString * message, NSArray *messageCateArr))block;

/**
 * 获取某个分类下的所有消息
 */
+ (void)fetMesssageListWithModel:(HXSMessageCate *)messageCate
                            page:(NSInteger )page
                            size:(NSInteger )size
                        complete:(void (^)(HXSErrorCode code, NSString * message, NSArray *messageItemArr))block;

/**
 *  删除某条消息
 */
+ (void)deleteMessageItemWithMessageId:(NSString *)message_id
                              complete:(void (^) (HXSErrorCode code, NSString * message, NSDictionary *dic))block;


/**
 *  把消息变为已读
 */
+ (void)updateMessageReadedWithCateId:(NSString *)cate_id
                            messageId:(NSString *)message_id
                             complete:(void (^) (HXSErrorCode code, NSString * message, NSDictionary *dic))block;


// unread message
+ (void)fetchUnreadMessage;

@end
