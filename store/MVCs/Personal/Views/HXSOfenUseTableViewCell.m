//
//  HXSOfenUseTableViewCell.m
//  store
//
//  Created by caixinye on 2017/9/14.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXSOfenUseTableViewCell.h"

@implementation HXSOfenUseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
        
    }
    return self;
}


- (void)setupSubViews{

    //backview
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-20, 110)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    backView.layer.cornerRadius = 10.0;
    
    backView.layer.shadowOpacity = 0.2;//阴影透明度
    backView.layer.shadowColor = [UIColor colorWithHexString:@"6d6c6c"].CGColor;
    backView.layer.shadowRadius = 4;//阴影扩散的范围控制
    backView.layer.shadowOffset = CGSizeMake(5,5);//阴影的范围
    

    //常用功能
    UIView *seeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(backView.frame), 35)];
    seeView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:seeView];
    UILabel *orderLb = [Maker makeLb:CGRectMake(5, 10, 60, 20) title:@"常用功能" alignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13] textColor:[UIColor colorWithHexString:@"222222"]];
    [seeView addSubview:orderLb];
    seeView.layer.cornerRadius = 10.0;
    //line
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(seeView.frame)-1, CGRectGetWidth(seeView.frame), 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"e1e1e1"];
    [seeView addSubview:line];
    
    //buttons
    CGFloat width = (CGRectGetWidth(backView.frame)-20-15)/4.0;
    CGFloat height = 40;
    _shopCollecBut = [[HXSPersonalCellButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(seeView.frame)+15, width, height)];
    _shopCollecBut.valueLabel.adjustsFontSizeToFitWidth = YES;
    _shopCollecBut.tag = HXDOfenUseButtonTypeShopCollect;
    _shopCollecBut.subTitleLabel.text = @"店铺收藏";
    _shopCollecBut.subTitleLabel.font = [UIFont systemFontOfSize:12];
    _shopCollecBut.iconImageView.image = [UIImage imageNamed:@"lis2_dianpushoucang"];
    [_shopCollecBut addTarget:self action:@selector(jumpToVCWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_shopCollecBut];
    
    _PlaceManageBut = [[HXSPersonalCellButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_shopCollecBut.frame)+5, CGRectGetMaxY(seeView.frame)+15, width, height)];
    _PlaceManageBut.valueLabel.adjustsFontSizeToFitWidth = YES;
    _PlaceManageBut.tag = HXDOfenUseButtonTypePlaceManage;
    _PlaceManageBut.subTitleLabel.text = @"地址管理";
    _PlaceManageBut.subTitleLabel.font = [UIFont systemFontOfSize:12];
    _PlaceManageBut.iconImageView.image = [UIImage imageNamed:@"lis2_dizhiguanli"];
    [_PlaceManageBut addTarget:self action:@selector(jumpToVCWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_PlaceManageBut];
    
    _KefuBut = [[HXSPersonalCellButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_PlaceManageBut.frame)+5, CGRectGetMaxY(seeView.frame)+15, width, height)];
    _KefuBut.valueLabel.adjustsFontSizeToFitWidth = YES;
    _KefuBut.tag = HXDOfenUseButtonTypeKefu;
    _KefuBut.subTitleLabel.text = @"客服中心";
    _KefuBut.subTitleLabel.font = [UIFont systemFontOfSize:12];
    _KefuBut.iconImageView.image = [UIImage imageNamed:@"lis2_kefuzhongxin"];//ic_mycoupon
    [_KefuBut addTarget:self action:@selector(jumpToVCWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_KefuBut];
    
    _FeedbackBut = [[HXSPersonalCellButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_KefuBut.frame)+5, CGRectGetMaxY(seeView.frame)+15, width, height)];
    _FeedbackBut.valueLabel.adjustsFontSizeToFitWidth = YES;
    _FeedbackBut.tag = HXDOfenUseButtonTypeFeedback;
    _FeedbackBut.subTitleLabel.text = @"意见反馈";
    _FeedbackBut.subTitleLabel.font = [UIFont systemFontOfSize:12];
    _FeedbackBut.iconImageView.image = [UIImage imageNamed:@"lis2_yijianfankui"];
    [_FeedbackBut addTarget:self action:@selector(jumpToVCWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_FeedbackBut];
    
    
    
    



}
- (void)jumpToVCWithBtn:(HXSPersonalCellButton *)currentBtn{
    
    if ([self.delegate respondsToSelector:@selector(clickHXDOfenUseButtonType:)]) {
        [self.delegate clickHXDOfenUseButtonType:currentBtn.tag];
    }
    
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
