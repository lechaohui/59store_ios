//
//  HXSLocationView.m
//  store
//
//  Created by caixinye on 2017/8/30.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXSLocationView.h"


static NSInteger const kWidthTitleViewButtonMaxIphone4 = 160;
static NSInteger const kWidthTitleViewButtonMaxIphone6 = 220;
static NSInteger const kHeightTitleView                = 30;
static NSInteger const kHeightTitleViewImage           = 15;
static NSInteger const kWidthTitleViewImage            = 15;
//static NSInteger const kPaddingTitleView               = 5;
static CGFloat const kFontSize                         = 12.0f;

@implementation HXSLocationView


- (instancetype)init;
{
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{

    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
 
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
    UIButton *locationBut = [Maker makeBtn:CGRectMake(5, 0, 100, kHeightTitleView) title:self.locationStr img:nil font:[UIFont systemFontOfSize:kFontSize] target:self action:@selector(clickLocation:)];
    [locationBut setBackgroundColor:[UIColor clearColor]];
    [locationBut.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [locationBut.titleLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
    [locationBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //icon
    UIImageView *imageView = [Maker makeImgView:CGRectMake(CGRectGetMaxX(locationBut.frame), 8, kWidthTitleViewImage, kHeightTitleViewImage) img:@"ic_downcontent"];
    imageView.backgroundColor = [UIColor clearColor];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLocation:)];
    [imageView addGestureRecognizer:tap];
    //CGRectGetWidth(imageView.bounds) + 10 + CGRectGetWidth(locationBut.bounds)
    self.frame = CGRectMake(-10, 64+30,
                            130,
                            kHeightTitleView);
    
    
    
    [self addSubview:locationBut];
    [self addSubview:imageView];
    
    
    
    



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

    if (self.delegate&&[self.delegate respondsToSelector:@selector(updateLocation)]) {
        
        [self.delegate performSelector:@selector(updateLocation)];
        
    }

}
@end
