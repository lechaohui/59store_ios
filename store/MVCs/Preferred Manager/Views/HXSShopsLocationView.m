//
//  HXSShopsLocationView.m
//  store
//
//  Created by caixinye on 2017/9/5.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXSShopsLocationView.h"

static NSInteger const kWidthTitleViewButtonMaxIphone4 = 160;
static NSInteger const kWidthTitleViewButtonMaxIphone6 = 220;
static NSInteger const kHeightTitleView                = 30;

static CGFloat const kFontSize                         = 14.0f;

@implementation HXSShopsLocationView
- (instancetype)init;
{
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews{

    //根据地址的长度自动计算宽度
    CGFloat width = [self.locationStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, kHeightTitleView)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kFontSize]}
                                                   context:nil].size.width+20;
    width= ceil(width);
    
    if (320==SCREEN_WIDTH) {
        if (width>kWidthTitleViewButtonMaxIphone4) {
            width = kWidthTitleViewButtonMaxIphone4;
        }
    }else{
        
        if (width>kWidthTitleViewButtonMaxIphone6) {
            width = kWidthTitleViewButtonMaxIphone6;
        }
        
    }
    
    //button
    UIButton *locationBut = [Maker makeBtn:CGRectMake(10, 0, 80, kHeightTitleView) title:self.locationStr img:nil font:[UIFont systemFontOfSize:kFontSize] target:self action:@selector(clickLocation:)];
    [locationBut setBackgroundColor:[UIColor clearColor]];
    [locationBut.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [locationBut.titleLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
    [locationBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.frame = CGRectMake((SCREEN_WIDTH-100)/2.0, 137,
                            100,
                            kHeightTitleView);
    
    [self addSubview:locationBut];
    
    
    



}
- (void)setLocationStr:(NSString *)locationStr
{
    if (locationStr) {
        _locationStr = locationStr;
        [self setupSubViews];
    }
}
#pragma mark - action
- (void)clickLocation:(id)sender{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(doUpdateLocation)]) {
        
        [self.delegate performSelector:@selector(doUpdateLocation)];
        
    }
    
    
    
}
@end
