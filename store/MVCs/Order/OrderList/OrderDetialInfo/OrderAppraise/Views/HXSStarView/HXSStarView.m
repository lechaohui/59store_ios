//
//  ZHNstartView.m
//  ZHNstratView
//
//  Created by zhn on 16/4/26.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "HXSStarView.h"
#import "HXSSingleStarView.h"
#import <objc/runtime.h>

#define KstarWidth self.frame.size.height
#define KsupviewWidth self.frame.size.width

typedef NS_ENUM(NSInteger,startViewType){
        startViewTypeFill,
        startViewTypeLine
};

typedef NS_ENUM(NSInteger,scoreType){
    scoreTypeInterger,
    scoreTypeNormal,
    scoreTypeContainHalf
};

static const NSString * Kkey = @"key";
static const NSString * KarrayKey = @"arrayKey";

@interface HXSStarView()
@property (nonatomic,strong) UIView * maskView;
@property (nonatomic,strong) NSMutableArray * starRectArray;// 星星位置的数组
@property (nonatomic,weak) UIView * starBackView;
@end


@implementation HXSStarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initialPrama];
        
        return self;
    }
    
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self initialPrama];
        
        return self;
    }
    
    return nil;
}

- (void)initialPrama
{
    self.starNumber = 5;
    self.backFillColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1];
    self.hightLightFillColor = [UIColor colorWithRed:246.0/255.0 green:192.0/255.0 blue:89.0/255.0 alpha:1];
    
    self.animate = YES;
    self.scoreInterger = YES;
    self.startShowScore = 0;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    if (!objc_getAssociatedObject(self, (__bridge const void *)(Kkey))) {
         [self initSubViewWithFrame:self.frame];
         [self forScoreTypeDealTheScore:self.startShowScore];
         [self setScoreWithNumber:self.startShowScore];
         self.currentScore = self.startShowScore;
        objc_setAssociatedObject(self, (__bridge const void *)(Kkey), @"true", OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

//  设置的分数要和设置的分数type挂钩
- (void)forScoreTypeDealTheScore:(CGFloat)score{
    if (self.scoreInterger) {
        self.startShowScore = round(score);
    }else if(self.scoreContainHalf){
        CGFloat decimalsScore = score - (int)score;
        decimalsScore = decimalsScore < 0.5 ? 0.5 : 1;
        self.startShowScore = (int)score + decimalsScore;
    }
}

- (void)initSubViewWithFrame:(CGRect)frame{

    // 底层星星
    [self addStarViewUseType:startViewTypeLine supView:self frame:frame];
    
    // 遮盖的星星
    UIView * maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
    [self addSubview:maskView];
    self.maskView = maskView;
    maskView.clipsToBounds = YES;
    
    // 最上层的星星
    [self addStarViewUseType:startViewTypeFill supView:maskView frame:frame];
    
    // 添加滑动的手势
    UIPanGestureRecognizer * panTheMenu = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panTheMenu:)];
    [self addGestureRecognizer:panTheMenu];
    
    UITapGestureRecognizer * tapTheMenu = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheMenu:)];
    [self addGestureRecognizer:tapTheMenu];
}


- (void)addStarViewUseType:(startViewType)type supView:(UIView *)supView frame:(CGRect)frame{
    
    for(int i = 0;i < self.starNumber;i++){
        CGFloat starWeightHeight = frame.size.height;
        CGFloat starY = 0;
        CGFloat starX = (starWeightHeight + (frame.size.width - self.starNumber * starWeightHeight)/(self.starNumber - 1)) * i;
        // 防止重复添加
        if (self.starRectArray.count < self.starNumber) {
            [self.starRectArray addObject:[NSValue valueWithCGRect:CGRectMake(starX, starY, starWeightHeight, starWeightHeight)]];
        }
        
        HXSSingleStarView * starView = [[HXSSingleStarView alloc]initWithFrame:CGRectMake(starX, starY, starWeightHeight, starWeightHeight)];
        starView.fillColor = self.backFillColor;
        starView.strokeColor = self.strokeColor;
        
        if (self.backFillColor) {
            starView.fillStar = YES;
        }
        if (type == startViewTypeFill) {
            starView.fillColor = self.hightLightFillColor;
            starView.fillStar = YES;
        }
        
        [supView addSubview:starView];
    }
}
// 滑动
- (void)panTheMenu:(UIPanGestureRecognizer *)pan{
    CGPoint startPoint;
    CGRect newRect;
    if (pan.state == UIGestureRecognizerStateBegan) {
        startPoint = [pan translationInView:self];
    }else if(pan.state == UIGestureRecognizerStateChanged){
        CGPoint currentPoint = [pan translationInView:self];
        CGFloat delta = currentPoint.x - startPoint.x;
        CGRect  oldRect = self.maskView.frame;
        CGFloat newWidth = oldRect.size.width + delta;
        if (oldRect.size.width + delta <= 0) {
            newWidth = 0;
        }else if(oldRect.size.width + delta >= KsupviewWidth){
            newWidth = KsupviewWidth;
        }
        newRect = CGRectMake(oldRect.origin.x, oldRect.origin.y, newWidth, oldRect.size.height);
        [self.maskView setFrame:newRect];
        [pan setTranslation:CGPointZero inView:self];
        
    }else if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded){
        CGFloat endX = self.maskView.frame.size.width;
        CGFloat endY = 1;
        CGPoint endPoint = CGPointMake(endX, endY);
        if (self.scoreInterger) {
            [self getCurrentScoreUseCurrentPoint:endPoint useType:scoreTypeInterger];
        }else if(self.scoreContainHalf){
            [self getCurrentScoreUseCurrentPoint:endPoint useType:scoreTypeContainHalf];
        }else{
            [self getCurrentScoreUseCurrentPoint:endPoint useType:scoreTypeNormal];
        }
    }
}
// 点击
- (void)tapTheMenu:(UITapGestureRecognizer *)tap{
    
    if (self.scoreInterger) { // 分数是整数
        [self getCurrentScoreUseCurrentPoint:[tap locationInView:self] useType:scoreTypeInterger];
    }else if(self.scoreContainHalf){// 分数包含.5
        [self getCurrentScoreUseCurrentPoint:[tap locationInView:self] useType:scoreTypeContainHalf];
    }else{// 分数随意啊
        [self getCurrentScoreUseCurrentPoint:[tap locationInView:self] useType:scoreTypeNormal];
    }
}

- (void)getCurrentScoreUseCurrentPoint:(CGPoint)point useType:(scoreType)type{
   
    int intScore = 0;// 整数值
    CGFloat decimalsScore;// 分数
    CGFloat currentScore;// 总的值
    CGPoint tapPoint = point;
    for(int i=0;i<self.starRectArray.count;i++){
        CGRect starRect = [self.starRectArray[i]CGRectValue];
        if (CGRectContainsPoint(starRect, tapPoint)) {
            switch (type) {
                case scoreTypeInterger:
                    currentScore = i+1;
                    break;
                case scoreTypeContainHalf:
                    intScore = i;
                    decimalsScore = (tapPoint.x - starRect.origin.x)/KstarWidth;
                    decimalsScore = decimalsScore > 0.5 ?1.0:0.5;
                    currentScore = intScore + decimalsScore;
                    break;
                case scoreTypeNormal:
                    intScore = i;
                    decimalsScore = (tapPoint.x - starRect.origin.x)/KstarWidth;
                    currentScore = intScore + decimalsScore;
                    break;
                default:
                    break;
            }
        [self setScoreWithNumber:currentScore];
        }
    }
}
// 设置分数
- (void)setScoreWithNumber:(CGFloat)score{
    CGFloat curretWeight;
    
    if (score <= 0) {
        curretWeight = 0;
        self.currentScore = 0;
    }else if(score >self.starNumber){
        curretWeight = KsupviewWidth;
        self.currentScore = self.starNumber;
    }else{
        self.currentScore = score;
        int intScore = (int)score;
        CGFloat decimalsScore = score - intScore;
        CGFloat delta = (KstarWidth + (KsupviewWidth - self.starNumber * KstarWidth)/(self.starNumber - 1));
        curretWeight = intScore * delta + decimalsScore * KstarWidth;
    }
    
    CGRect oldRect = self.maskView.frame;
    CGRect newRect = CGRectMake(oldRect.origin.x, oldRect.origin.y, curretWeight, oldRect.size.height);
    if (self.animate) {
        [UIView animateWithDuration:0.3 animations:^{
            self.maskView.frame = newRect;
        }];
    }else{
        self.maskView.frame = newRect;
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setOnlyForShow:(BOOL)onlyForShow{
    if (onlyForShow) {
        self.userInteractionEnabled = NO;
    }
}

// 懒加载
- (NSMutableArray *)starRectArray{
    if (_starRectArray == nil) {
        _starRectArray = [NSMutableArray array];
    }
    return _starRectArray;
}

@end
