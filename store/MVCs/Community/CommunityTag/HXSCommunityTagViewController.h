//
//  HXSCommunityTagViewController.h
//  store
//
//  Created by  黎明 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  帖子列表

#import <UIKit/UIKit.h>
#import "HXSBaseViewController.h"
#import "HXSCommunityTagTableDelegate.h"

@interface HXSCommunityTagViewController : HXSBaseViewController

@property (nonatomic, weak) IBOutlet UITableView  *mTableView;

/** 向上滚动 */
@property (nonatomic, copy) void (^scrollTop)();
/** 向下滚动 */
@property (nonatomic, copy) void (^scrollBottom)();
/** 是否为校园帖子 */
@property (nonatomic, assign) BOOL isSchoolPost;

/**
 *  服务器获取帖子列表
 *
 *  @param type    帖子分类
 *  @param topicId 话题id【没有的话代表首页给的默认列表】
 *  @param siteId  学校id【没有的话代表首页给的默认列表】
 */
-(void)loadDataFromServerWith:(HXSPostListType)type
                      topicId:(NSString *)topicId
                       siteId:(NSString *)siteId
                       userId:(NSNumber *)userId;


@end
