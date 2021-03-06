//
//  HXSPersonalCellButton.m
//  store
//
//  Created by caixinye on 2017/9/12.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXSPersonalCellButton.h"
@interface HXSPersonalCellButton() {
    
}

- (void)setup;

@end

@implementation HXSPersonalCellButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _iconImageView.frame = CGRectMake(self.width/2.0, 5, 30, 30);
    _iconImageView.center = CGPointMake(self.width/2.0, self.height/2.0 - 10);
    
    if ((_valueLabel.text.length < 1) && (_valueLabel.attributedText.length < 1)) {
        _subTitleLabel.frame = CGRectMake(0, _iconImageView.bottom, self.width, 20);
    }
    else {
        
        _valueLabel.frame = CGRectMake(0, self.height/2.0 - 25, self.width, 20);
        _subTitleLabel.frame = CGRectMake(0, _valueLabel.bottom + 5, self.width, 20);
    }
}

#pragma mark - private method

- (void)setup
{
    if (_valueLabel == nil) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.textColor = [UIColor colorWithRGBHex:0xF59E1C];
        _valueLabel.font = [UIFont systemFontOfSize:18.0];
        _valueLabel.userInteractionEnabled = NO;
        _valueLabel.backgroundColor = [UIColor clearColor];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_valueLabel];
    }
    
    if (_subTitleLabel == nil) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = [UIColor colorWithRGBHex:0x6d6d6d];
        _subTitleLabel.font = [UIFont systemFontOfSize:15.0];
        _subTitleLabel.userInteractionEnabled = NO;
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_subTitleLabel];
    }
    
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_iconImageView];
    }
    
    [self setBackgroundImage:[UIImage imageFromColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]] forState:UIControlStateHighlighted];
}


@end
