//
//  customStartView.m
//  ZHNstratView
//
//  Created by zhn on 16/4/26.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "HXSSingleStarView.h"

@interface HXSSingleStarView()

@property (nonatomic,strong) NSMutableArray * outPointsArray;
@property (nonatomic,strong) NSMutableArray * inPointsArray;

@end

@implementation HXSSingleStarView

- (void)drawRect:(CGRect)rect{

    UIBezierPath * path = [UIBezierPath bezierPath];
    path.lineWidth = 1;
    if (self.strokeColor) {
        [self.strokeColor set];
    }else{
        [self.fillColor set];
    }
    [self.fillColor setFill];
    for (int i = 0; i < 5; i++) {
        if (i == 0) {
            [path moveToPoint:[self.outPointsArray[i]CGPointValue]];
            [path addLineToPoint:[self.inPointsArray[i]CGPointValue]];
        }else{
            [path addLineToPoint:[self.outPointsArray[i]CGPointValue]];
            [path addLineToPoint:[self.inPointsArray[i]CGPointValue]];
        }
    }
    [path closePath];
    [path stroke];
    if (self.isFillStar == YES) {
        [path fill];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubViews:frame];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)initSubViews:(CGRect)frame{
    [self Get5Points:frame];
}


-(void)Get5Points:(CGRect)frame
{
    CGFloat minWith = frame.size.width <= frame.size.height ? frame.size.width :frame.size.height;
    CGFloat delta_x;
    if(frame.size.height < frame.size.width) {
        delta_x = (frame.size.width - frame.size.height)/2;
    } else {
        delta_x = 0.00;
    }
    
    CGFloat radius = minWith/2;
    
    for (NSInteger i = 0; i < 5; i++) {
        NSInteger delta = ( i == 1 ? frame.size.width / 30 : 0);
        CGFloat x = radius + radius * cos((0.2 * M_PI * 2)*i+(0.05 * M_PI * 2)) + delta_x;
        CGFloat y = radius - radius * sin((0.2 * M_PI * 2)*i+(0.05 * M_PI * 2)) + delta;
        CGPoint point = CGPointMake(x, y);
        [self.outPointsArray addObject:[NSValue valueWithCGPoint:point]];
    }
    
    CGFloat smallRadius = radius * sin(0.05 * M_PI * 2)/sin(0.1 * M_PI * 2);
    for (NSInteger i=0; i<5; i++) {
        CGFloat x = radius + smallRadius * cos((0.1 * M_PI * 2)*(1 + 2 * i)+(0.05 * M_PI * 2)) + delta_x;
        CGFloat y = radius - smallRadius * sin((0.1 * M_PI * 2)*(1 + 2 * i)+(0.05 * M_PI * 2));
        [self.inPointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
    }
}

- (NSMutableArray *)outPointsArray{
    if (_outPointsArray == nil) {
        _outPointsArray = [NSMutableArray array];
    }
    return _outPointsArray;
}
- (NSMutableArray *)inPointsArray{
    if (_inPointsArray == nil) {
        _inPointsArray = [NSMutableArray array];
    }
    return _inPointsArray;
}


@end
