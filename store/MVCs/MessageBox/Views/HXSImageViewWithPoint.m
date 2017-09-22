//
//  HXSImageViewWithPoint.m
//  store
//
//  Created by 格格 on 16/8/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSImageViewWithPoint.h"

static CGFloat const pointR = 5.0;

@interface HXSImageViewWithPoint()

@property (nonatomic,strong) UIView *pointView;

@end

@implementation HXSImageViewWithPoint

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self initialPrama];
        return self;
    }
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self initialPrama];
        return self;
    }
    return nil;
}

- (void)initialPrama
{
    _pointColor = [UIColor redColor];
    _imageViewCornerRadius = 0;
    _showPint = NO;
    [self addSubview:self.imageView];
    [self addSubview:self.pointView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.clipsToBounds = NO;
    
    self.imageView.frame = self.bounds;
    self.imageView.layer.cornerRadius = self.imageViewCornerRadius;
    self.imageView.layer.masksToBounds = YES;
    
    self.pointView.hidden = !self.showPint;
    [self.pointView setBackgroundColor:self.pointColor];
    self.pointView.frame = CGRectMake(self.bounds.size.width - pointR - self.imageViewCornerRadius, self.imageViewCornerRadius - pointR, pointR * 2, pointR * 2);
    self.pointView.layer.cornerRadius = pointR;
}


#pragma mark - Setter

- (void)setPointColor:(UIColor *)pointColor
{
    _pointColor = pointColor;
    [self layoutSubviews];
}

- (void)setImageViewCornerRadius:(CGFloat)imageViewCornerRadius
{
    _imageViewCornerRadius = imageViewCornerRadius;
    [self layoutSubviews];
}

- (void)setShowPint:(BOOL)showPint
{
    _showPint = showPint;
    [self layoutSubviews];
}


#pragma mark - Getter

- (UIImageView *)imageView
{
    if(!_imageView) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}

- (UIView *)pointView
{
    if(!_pointView) {
        _pointView = [[UIView alloc]init];
    }
    return _pointView;
}

@end
