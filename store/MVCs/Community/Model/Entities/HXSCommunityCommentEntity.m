//
//  HXSCommunityCommentEntity.m
//  store
//
//  Created by J006 on 16/4/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityCommentEntity.h"

@implementation HXSCommunityCommentEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mappingList = @{@"commentIDStr":           @"comment_id",
                                  @"postIDStr":              @"post_id",
                                  @"topicIDStr":             @"topic_id",
                                  @"topicTitleStr":          @"topic_title",
                                  @"postContentStr":         @"post_content",
                                  @"commentContentStr":      @"comment_content",
                                  @"commentedContentStr":    @"commented_content",
                                  @"commentType":            @"comment_type",
                                  @"createTimeNum":          @"create_time",
                                  @"postOwner":              @"post_owner",
                                  @"commentUser":            @"comment_user",
                                  @"commentedUser":          @"commented_user",
                                  };
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:mappingList];
}

@end
