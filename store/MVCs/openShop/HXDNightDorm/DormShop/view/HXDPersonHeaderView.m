//
//  HXDPersonHeaderView.m
//  store
//
//  Created by caixinye on 2017/9/11.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXDPersonHeaderView.h"
#import "HXSPersonalMenuButton.h"



@interface HXDPersonHeaderView ()


@end
@implementation HXDPersonHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self initialSubviews];
        return self;
    }
    return self;
}


- (void)initialSubviews{

    //backView
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    backView.backgroundColor = [UIColor colorWithHexString:@"fde25c"];
    [self addSubview:backView];
    
    //backBut
    UIButton *backBut = [Maker makeBtn:CGRectMake(5, 5, 30, 35) title:nil img:@"btn_back_normal" font:nil target:self action:@selector(back)];
    [backView addSubview:backBut];
    
    //title
    UILabel *titleLb = [Maker makeLb:CGRectMake((SCREEN_WIDTH-100)/2.0, 5, 100, 30) title:@"我的店铺" alignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:18] textColor:[UIColor blackColor  ]];
    [backView addSubview:titleLb];
    
    //_accumBut
    _accumBut = [[HXSPersonalMenuButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2.0, CGRectGetMaxY(titleLb.frame)+30, 100, 40)];
    _accumBut.valueLabel.adjustsFontSizeToFitWidth = YES;
    _accumBut.tag = HXDPersonHeaderButtonAccumulate;
    [backView addSubview:_accumBut];
    _accumBut.subTitleLabel.text = @"累计销售额";
    _accumBut.subTitleLabel.textColor = [UIColor blackColor];
    [_accumBut addTarget:self action:@selector(jumpToVCWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //tongjiBut
    _tongjiBut = [Maker makeBtn:CGRectMake(SCREEN_WIDTH-140, CGRectGetMaxY(_accumBut.frame)+40, 140, 20) title:@"数据统计截止于1小时前" img:nil font:[UIFont systemFontOfSize:13] target:self action:@selector(jumpToVCWithBtn:)];
    _tongjiBut.tag = HXDPersonHeaderButtonTongji;
    [backView addSubview:_tongjiBut];
    

}

#pragma mark - target
- (void)jumpToVCWithBtn:(HXSPersonalMenuButton *)currentBtn{
    
    if ([self.delegate respondsToSelector:@selector(clickPersonMenuButtonType:)]) {
        [self.delegate clickPersonMenuButtonType:currentBtn.tag];
    }


}
- (void)back{






}

@end
