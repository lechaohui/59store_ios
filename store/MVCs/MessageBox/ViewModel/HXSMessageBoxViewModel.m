//
//  HXSMessageBoxViewModel.m
//  store
//
//  Created by 格格 on 16/8/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMessageBoxViewModel.h"

@implementation HXSMessageBoxViewModel

+ (void)fetchMessageCateListComplete:(void (^)(HXSErrorCode code, NSString * message, NSArray *messageCateArr))block
{
    [HXStoreWebService getRequest:kUserMessageCateList
                       parameters:nil
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if(kHXSNoError == status) {
                                  NSArray *arr = [data objectForKey:@"list"];
                                  if(arr) {
                                      NSArray *resultArray = [HXSMessageCate arrayOfModelsFromDictionaries:arr error:nil];
                                      block(status,msg,resultArray);
                                  }
                                  
                                  return;
                              }
                              
                              block(status,msg,nil);
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,nil);
    }];
}

+ (void)fetMesssageListWithModel:(HXSMessageCate *)messageCate
                            page:(NSInteger )page
                            size:(NSInteger )size
                        complete:(void (^)(HXSErrorCode code, NSString * message, NSArray *messageItemArr))block
{
    NSDictionary *prama = @{
                            @"num_per_page" : @(size),
                            @"page"         : @(page),
                            @"cate_id"      : messageCate.cateIdStr
                            };
    [HXStoreWebService getRequest:kUserMessageList
                       parameters:prama
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              
                              if(kHXSNoError == status) {
                                  NSArray *arr = [data objectForKey:@"list"];
                                  if(arr) {
                                      NSArray *resultArray = [HXSMessageItem arrayOfModelsFromDictionaries:arr error:nil];
                                      block(status,msg,resultArray);
                                  }
                                  
                                  return;
                              }
                              block(status,msg,nil);
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status,msg,nil);
                          }];
}

+ (void)deleteMessageItemWithMessageId:(NSString *)message_id
                              complete:(void (^) (HXSErrorCode code, NSString * message, NSDictionary *dic))block
{
    NSDictionary *prama = @{
                            @"message_id":message_id
                            };
    [HXStoreWebService postRequest:kUserMessageDelete
                        parameters:prama
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               block(status,msg,data);
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
         block(status,msg,nil);
    }];
}

+ (void)updateMessageReadedWithCateId:(NSString *)cate_id
                            messageId:(NSString *)message_id
                             complete:(void (^) (HXSErrorCode code, NSString * message, NSDictionary *dic))block
{
    NSDictionary *prama = @{
                            @"message_id": message_id,
                            @"cate_id"   : cate_id
                            };
    [HXStoreWebService postRequest:kUserMessageRead
                        parameters:prama
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               block(status,msg,data);
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
    }];
}

// unread message
+ (void)fetchUnreadMessage
{
    [HXSMessageBoxViewModel fetchMessageCateListComplete:^(HXSErrorCode code, NSString *message, NSArray *messageCateArr) {
        if (kHXSNoError == code) {
            
            BOOL unreaded = NO;
            for (HXSMessageCate *cate in messageCateArr) {
                if (0 < cate.messageItem.statusStr.length && HXSMessageItemStatusUnRead == [cate.messageItem.statusStr integerValue])
                {
                    unreaded = YES;
                    
                    break;
                }
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:@(unreaded) // has unreaded message
                                                      forKey:USER_DEFAULT_UNREAD_MESSGE_NUMBER];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMessagehasUpdated
                                                                object:nil];
        }
    }];
}


@end
