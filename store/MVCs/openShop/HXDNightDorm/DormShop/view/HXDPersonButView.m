//
//  HXDPersonButView.m
//  store
//
//  Created by caixinye on 2017/9/11.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXDPersonButView.h"
#import "HXSPersonalMenuButton.h"


@implementation HXDPersonButView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        [self initialSubviews];
        return self;
    }
    return nil;
}
- (void)initialSubviews{

    //backview
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 50)];
//    backView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:backView];
    
    CGFloat width = (CGRectGetWidth(self.frame)-30-20-20)/3.0;
    CGFloat height = 40;
    //_visitBut
    
    _visitBut = [[HXSPersonalMenuButton alloc] initWithFrame:CGRectMake(15, 5, width, height)];
    _visitBut.valueLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_visitBut];
    _visitBut.tag = HXDPersonHeaderButtonVisit;
    _visitBut.subTitleLabel.text = @"今日访客";
    [_visitBut addTarget:self action:@selector(jumpToVCWithBtn:) forControlEvents:UIControlEventTouchUpInside];

    
    //line1
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_visitBut.frame)+10, 5, 1, height)];
    line1.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [self addSubview:line1];
    
    //_numBut
    _numBut = [[HXSPersonalMenuButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_visitBut.frame)+20, 5, width, height)];
    _numBut.valueLabel.adjustsFontSizeToFitWidth = YES;
    _numBut.subTitleLabel.text = @"今日订单数";
    _numBut.subTitleLabel.adjustsFontSizeToFitWidth = YES;
    _numBut.tag = HXDPersonHeaderButtonNum;
    [_numBut addTarget:self action:@selector(jumpToVCWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_numBut];
    
    //line2
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_numBut.frame)+10, 5, 1, height)];
    line2.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [self addSubview:line2];
    
    //_accumBut
    _accumBut = [[HXSPersonalMenuButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_numBut.frame)+20, 5, width, height)];
    _accumBut.valueLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_accumBut];
    _accumBut.subTitleLabel.adjustsFontSizeToFitWidth = YES;
    _accumBut.subTitleLabel.text = @"今日销售额";
    _accumBut.tag = HXDPersonHeaderButtonSale;
    [_accumBut addTarget:self action:@selector(jumpToVCWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    

}

- (void)jumpToVCWithBtn:(HXSPersonalMenuButton *)currentBtn{

    if ([self.delegate respondsToSelector:@selector(clickPersonButtonType:)]) {
        [self.delegate clickPersonButtonType:currentBtn.tag];
    }
    


}
@end
