//
//  HXSOrderTimeLineView.m
//  store
//
//  Created by 格格 on 16/8/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSOrderTimeLineView.h"

// 外圆环半径
static CGFloat const kOutRingRadius = 8.5;
// 内环半径
static CGFloat const kInnerRingRadius = 5.0;
// 时间线高度
static CGFloat const kTimeLineHeight = 2.0;
// 左右留的空隙，用来书写文字
static CGFloat const kMarginLeftAndRinht = 30.0;

@interface HXSOrderTimeLineView()

/** 节点中心 */
@property (nonatomic,strong) NSMutableArray <NSValue *> *nodeCenters;

@end

@implementation HXSOrderTimeLineView


- (void)drawRect:(CGRect)rect
{
    if (self.nodeNameArr.count > 0) {
        
        /********************取点，画线*******************************/
        
        [self.timeLineColor set];
        [self.timeLineColor setFill];
        
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        linePath.lineWidth = kTimeLineHeight;
        NSValue *firstCenter = [self.nodeCenters firstObject];
        NSValue *lastCenter = [self.nodeCenters lastObject];
        [linePath moveToPoint:firstCenter.CGPointValue];
        [linePath addLineToPoint:lastCenter.CGPointValue];
        [linePath closePath];
        [linePath stroke];
        
        /********************取点，画外圆*******************************/
        
        CGFloat yValue = (rect.size.height - kOutRingRadius * 2) / 2;
        for(int i = 0;i < self.nodeNameArr.count; i++) {
            
            CGPoint point = [[self.nodeCenters objectAtIndex:i]CGPointValue];
            CGRect bigCircleRect = CGRectMake(point.x - kOutRingRadius ,yValue, kOutRingRadius * 2, kOutRingRadius * 2);
            UIBezierPath *outRingPath = [UIBezierPath bezierPathWithOvalInRect:bigCircleRect];
            
            [self.timeLineColor set];
            [self.timeLineColor setFill];
            [outRingPath fill];
        }
        
        /********************取点，画内圆*******************************/
        
        if(self.currentIndex >= 0 && self.currentIndex < self.nodeNameArr.count) {
            yValue = (rect.size.height - kInnerRingRadius * 2) / 2;
            
            CGPoint point = [[self.nodeCenters objectAtIndex:self.currentIndex]CGPointValue];
            CGRect circleRect = CGRectMake(point.x - kInnerRingRadius ,yValue, kInnerRingRadius * 2, kInnerRingRadius * 2);
            UIBezierPath *innerRingPath = [UIBezierPath bezierPathWithOvalInRect:circleRect];
            
            [self.currentNodeColor set];
            [self.currentNodeColor setFill];
            
            [innerRingPath fill];
        }
        /********************取点，写文字*******************************/
        
        NSDictionary* attrs =@{
                               NSForegroundColorAttributeName:self.textColor,
                               NSFontAttributeName:self.textFont,
                               };
        for(int i = 0;i < self.nodeNameArr.count; i++) {
            
            CGPoint point = [[self.nodeCenters objectAtIndex:i]CGPointValue];
            NSString * str = [self.nodeNameArr objectAtIndex:i];
            
            CGSize size = CGSizeMake(MAXFLOAT, self.textFont.pointSize);
            CGSize strSize = [str boundingRectWithSize:size
                                               options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                            attributes:attrs
                                               context:nil].size;
            
            CGPoint strPoint = CGPointMake(point.x - strSize.width/2 , point.y + kOutRingRadius + 10);
            [str drawAtPoint:strPoint withAttributes:attrs];
        }
    
    }
}

- (void)initialPrama
{
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    _currentIndex = 0;
    _timeLineColor = [UIColor colorWithRGBHex:0xDAF5FF];
    _currentNodeColor = [UIColor colorWithRGBHex:0x07A9FA];
    _textColor = [UIColor colorWithRGBHex:0x9B9B9B];
    _textFont = [UIFont systemFontOfSize:12];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        self.nodeNameArr = @[];
        [self initialPrama];
        
        return self;
    }
    
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.nodeNameArr = @[];
        [self initialPrama];
        
        return self;
    }
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame
                  nodeNameArr:(NSArray *)nodeNameArr
{
    self = [super initWithFrame:frame];
    if(self) {
        self.nodeNameArr = nodeNameArr;
        [self initialPrama];
        
        return self;
    }
    return nil;
}

#pragma mark - Setter

- (void)setNodeNameArr:(NSArray *)nodeNameArr
{
    _nodeNameArr = nodeNameArr;
    [self setNeedsDisplay];
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    [self setNeedsDisplay];
}

- (void)setCurrentNodeColor:(UIColor *)currentNodeColor
{
    _currentNodeColor = currentNodeColor;
    [self setNeedsDisplay];
}

- (void)setTimeLineColor:(UIColor *)timeLineColor
{
    _timeLineColor = timeLineColor;
    [self setNeedsDisplay];
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    [self setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self setNeedsDisplay];
}

#pragma mark - Getter

- (NSMutableArray *)nodeCenters
{
    if(!_nodeCenters) {
        _nodeCenters = [NSMutableArray array];
        CGFloat delatX = (self.bounds.size.width - (kOutRingRadius + kMarginLeftAndRinht) * 2) / (self.nodeNameArr.count - 1);
        
        for(int i = 0; i < self.nodeNameArr.count ;i++) {
            CGPoint center = CGPointMake(kOutRingRadius + kMarginLeftAndRinht + delatX * i , self.bounds.size.height/2);
            [_nodeCenters addObject:[NSValue valueWithCGPoint:center]];
        }
        
    }
    return _nodeCenters;
}


@end
