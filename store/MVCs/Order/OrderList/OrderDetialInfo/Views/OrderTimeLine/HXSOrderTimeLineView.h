//
//  HXSOrderTimeLineView.h
//  store
//
//  Created by 格格 on 16/8/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSOrderTimeLineView : UIView

/** 时间轴节点名称 */
@property (nonatomic,strong) NSArray *nodeNameArr;

/** 时间轴当前节点 */
@property (nonatomic,assign) NSInteger currentIndex;

/** 当前节点中心圆颜色 */
@property (nonatomic,strong) UIColor *currentNodeColor;

/** 时间轴颜色 */
@property (nonatomic,strong) UIColor *timeLineColor;

/** 文本颜色 */
@property (nonatomic,strong) UIColor *textColor;

/** 文字样式 */
@property (nonatomic,strong) UIFont *textFont;

- (instancetype)initWithFrame:(CGRect)frame
                  nodeNameArr:(NSArray *)nodeNameArr;

@end
