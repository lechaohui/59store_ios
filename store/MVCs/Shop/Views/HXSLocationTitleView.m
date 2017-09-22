//
//  HXSLocationTitleView.m
//  store
//
//  Created by  黎明 on 16/7/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSLocationTitleView.h"

// Title View
static NSInteger const kWidthTitleViewButtonMaxIphone4 = 160;
static NSInteger const kWidthTitleViewButtonMaxIphone6 = 220;
static NSInteger const kHeightTitleView                = 30;
static NSInteger const kHeightTitleViewImage           = 15;
static NSInteger const kWidthTitleViewImage            = 15;
static NSInteger const kPaddingTitleView               = 5;
static CGFloat const kFontSize                         = 17.0f;

@implementation HXSLocationTitleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    CGFloat width = [self.locationStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, kHeightTitleView)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kFontSize]}
                                              context:nil].size.width + 20;
    width = ceil(width);
    if (320 == SCREEN_WIDTH) {
        if (width > kWidthTitleViewButtonMaxIphone4) {
            width = kWidthTitleViewButtonMaxIphone4;
        }
    } else {
        if (width > kWidthTitleViewButtonMaxIphone6) {
            width = kWidthTitleViewButtonMaxIphone6;
        }
    }
    
    // icon
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xia"]];
    imageView.backgroundColor = [UIColor clearColor];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setUserInteractionEnabled:YES];
    
    [imageView setFrame:CGRectMake(width + 5,
                                   (kHeightTitleView - kHeightTitleViewImage) / 2.0f,
                                   kWidthTitleViewImage,
                                   kHeightTitleViewImage)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(onClickLocation:)];
    [imageView addGestureRecognizer:tap];
    imageView.hidden = YES;
    
    
    // buttn
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationBtn setTitle:self.locationStr forState:UIControlStateNormal];
    [locationBtn.titleLabel setFont:[UIFont systemFontOfSize:kFontSize]];
    [locationBtn setTitleColor:[UIColor colorWithRGBHex:0x333333] forState:UIControlStateNormal];
    [locationBtn setBackgroundColor:[UIColor colorWithHexString:@"eeeeee"]];
    [locationBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [locationBtn.titleLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
    locationBtn.layer.cornerRadius = 5;
    locationBtn.layer.masksToBounds = YES;
    [locationBtn addTarget:self action:@selector(onClickLocation:) forControlEvents:UIControlEventTouchUpInside];
    [locationBtn setFrame:CGRectMake((SCREEN_WIDTH-width)/2.0,
                                     0,
                                     width,
                                     kHeightTitleView)];
    
    
    self.frame = CGRectMake(0, 12,
                            CGRectGetWidth(imageView.bounds) + kPaddingTitleView + CGRectGetWidth(locationBtn.bounds),
                            kHeightTitleView);
    
    
    //[self addSubview:imageView];
    [self addSubview:locationBtn];
}

- (void)setLocationStr:(NSString *)locationStr
{
    if (locationStr) {
        _locationStr = locationStr;
        [self setupSubViews];
    }
}

- (void)onClickLocation:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeLocation)]) {
        [self.delegate performSelector:@selector(changeLocation)];
    }
}

@end
