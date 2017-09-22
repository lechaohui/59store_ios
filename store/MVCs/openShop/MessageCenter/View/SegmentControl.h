//
//  SegmentControl.h
//  store
//
//  Created by caixinye on 2017/8/27.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SegmentControlDelegate <NSObject>

@optional
/**
 *  此方法用于获取当前被选中索引
 *
 *  @param selectedIndex 被选中索引
 */
- (void)selectedChanged:(NSInteger)selectedIndex;
- (void)selectedCurrentTitleButton ;
- (void)selectedIndexWillChange;

@end

@interface SegmentControl : UIView
/** 标题 */
@property(nonatomic, strong ,readonly) NSArray *titles;
/** 选中状态下文字颜色 */
@property(nonatomic, strong) UIColor *selectedTitleColor;
/** 未选中状态下文字颜色 */
@property(nonatomic, strong) UIColor *titleColor;
/** 滑块颜色 */
@property(nonatomic, strong) UIColor *bottomSlideViewColor;
/** 当前索引 默认为0*/
@property(nonatomic, assign ,readonly) NSInteger currentIndex;
/** 滑块距离左边的距离 */
@property(nonatomic, assign) CGFloat blockX;
/** 被托管的scrollView 不能为空*/
@property(nonatomic, weak) UIScrollView *scrollView;

/** 代理 */
@property(nonatomic, weak) id<SegmentControlDelegate> delegate;


- (instancetype)initWithTitles:(NSArray *)titles;

/**
 *  设置消息个数
 *
 *  @param noticeCount  公告
 *  @param messageCount 消息
 */
- (void)setNoticeCount:(NSNumber *)noticeCount messageCount:(NSNumber *)messageCount;
@end
