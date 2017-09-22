//
//  HXSOrderTimeLineCell.m
//  store
//
//  Created by 格格 on 16/8/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSOrderTimeLineCell.h"

#import "HXSOrderTimeLineView.h"

@interface HXSOrderTimeLineCell ()

@property (nonatomic, weak) IBOutlet HXSOrderTimeLineView *orderTimeLineView;

@end

@implementation HXSOrderTimeLineCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (instancetype)orderTimeLineCell
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSOrderTimeLineCell class])
                                         owner:nil options:nil].firstObject;
}

- (void)refresh
{
    NSMutableArray <NSString *> *strArr = [NSMutableArray array];
    
    NSInteger selectIndex = 0;
    for(HXStimelineStatus *temp in self.timelineStatusArr) {
        [strArr addObject:temp.statusStr];
        if (temp.statusHitStr.boolValue) {
            selectIndex = [self.timelineStatusArr indexOfObject:temp];
        }
    }
    
    self.orderTimeLineView.nodeNameArr = strArr;
    self.orderTimeLineView.currentIndex = selectIndex;
}

- (void)setTimelineStatusArr:(NSArray<HXStimelineStatus *> *)timelineStatusArr
{
    _timelineStatusArr = timelineStatusArr;
    
    [self refresh];
}

@end
