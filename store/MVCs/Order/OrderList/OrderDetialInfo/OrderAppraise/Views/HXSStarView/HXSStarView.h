//
//  ZHNstartView.h
//  ZHNstratView
//
//  Created by zhn on 16/4/26.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSStarView : UIControl

/**
 *  星星的颗数 默认5颗
 */
@property (nonatomic,assign) NSInteger starNumber;

/**
 *  高亮的填充的颜色 默认橙色
 */
@property (nonatomic,strong) UIColor * hightLightFillColor;

/**
 *  背景星星的填充颜色 默认灰色
 */
@property (nonatomic,strong) UIColor * backFillColor;

/**
 *  星星边框的颜色 不填默认和填充颜色一样
 */
@property (nonatomic,strong) UIColor * strokeColor;
/**
 *  一开始展示的分数 默认为0
 */
@property (nonatomic,assign) CGFloat startShowScore;
/**
 *  当前的分数值
 */
@property (nonatomic,assign) CGFloat currentScore;
/**
 *  星星的填充是是否需要动画
 */
@property (nonatomic,getter = isAnimate) BOOL animate;
/**
 *  分数是整数 
 */
@property (nonatomic,getter = isScoreInerger) BOOL scoreInterger;
/**
 *  分数是以0.5为单位
 */
@property (nonatomic,getter = isScoreContainHalf) BOOL scoreContainHalf;
/**
 *  仅仅是展示效果 默认是no
 */
@property (nonatomic,getter = isOnlyForShow) BOOL onlyForShow;

@end
