//
//  HXSOrderStatusTableViewCell.m
//  store
//
//  Created by caixinye on 2017/9/13.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXSOrderStatusTableViewCell.h"


@implementation HXSOrderStatusTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
        
    }
    return self;
}


- (void)setupSubViews{


    UIFont *font = [UIFont systemFontOfSize:13];
    //backview
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-20, 110)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    backView.layer.cornerRadius = 10.0;
    
    backView.layer.shadowOpacity = 0.2;//阴影透明度
    backView.layer.shadowColor = [UIColor colorWithHexString:@"6d6c6c"].CGColor;
    backView.layer.shadowRadius = 4;//阴影扩散的范围控制
    backView.layer.shadowOffset = CGSizeMake(5,5);//阴影的范围
    

    //我的订单  查看全部订单
    UIView *seeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(backView.frame), 35)];
    seeView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:seeView];
    UILabel *orderLb = [Maker makeLb:CGRectMake(5, 10, 60, 20) title:@"我的订单" alignment:NSTextAlignmentLeft font:font textColor:[UIColor colorWithHexString:@"222222"]];
    [seeView addSubview:orderLb];
    seeView.layer.cornerRadius = 10.0;
    
    
    //查看全部订单CGRectMake(CGRectGetWidth(seeView.frame)-60, 5, 50, 20)//ic_arrow
    _seeAllBuu = [[HXSPersonalCellButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(seeView.frame)-120, 10, 120, 20)];
    [_seeAllBuu setImage:[UIImage imageNamed:@"ic_arrow"] forState:UIControlStateNormal];
    [_seeAllBuu setTitle:@"查看全部订单" forState:UIControlStateNormal];
    _seeAllBuu.titleLabel.font = [UIFont systemFontOfSize:12];
    [_seeAllBuu setTitleColor:[UIColor colorWithHexString:@"969696"] forState:UIControlStateNormal];
    
    [_seeAllBuu setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:2];
    
    _seeAllBuu.tag = HXDOrderStatusButtonTypeAll;
    [_seeAllBuu addTarget:self action:@selector(jumpToVCWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [seeView addSubview:_seeAllBuu];
    
    //line
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(seeView.frame)-1, CGRectGetWidth(seeView.frame), 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"e1e1e1"];
    [seeView addSubview:line];
    
    //buttons
    CGFloat width = (CGRectGetWidth(backView.frame)-20-20)/5.0;
    CGFloat height = 40;
    _waitBuy = [[HXSPersonalCellButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(seeView.frame)+10, width, height)];
    _waitBuy.valueLabel.adjustsFontSizeToFitWidth = YES;
    _waitBuy.tag = HXDOrderStatusButtonTypeWaitingBuy;
    _waitBuy.subTitleLabel.text = @"待付款";
    _waitBuy.subTitleLabel.font = [UIFont systemFontOfSize:12];
    _waitBuy.iconImageView.image = [UIImage imageNamed:@"lis1_daifukuan"];
    [_waitBuy addTarget:self action:@selector(jumpToVCWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_waitBuy];
    
    _waitFahuo = [[HXSPersonalCellButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_waitBuy.frame)+5, CGRectGetMaxY(seeView.frame)+10, width, height)];
    _waitFahuo.valueLabel.adjustsFontSizeToFitWidth = YES;
    _waitFahuo.tag = HXDOrderStatusButtonTypeWaitingFahuo;
    _waitFahuo.subTitleLabel.text = @"待发货";
    _waitFahuo.subTitleLabel.font = [UIFont systemFontOfSize:12];
    _waitFahuo.iconImageView.image = [UIImage imageNamed:@"lis1_daifahuo"];
    [_waitFahuo addTarget:self action:@selector(jumpToVCWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_waitFahuo];
    
    _waitShouhuo = [[HXSPersonalCellButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_waitFahuo.frame)+5, CGRectGetMaxY(seeView.frame)+10, width, height)];
    _waitShouhuo.valueLabel.adjustsFontSizeToFitWidth = YES;
    _waitShouhuo.tag = HXDOrderStatusButtonTypeWaitingshouhuo;
    _waitShouhuo.subTitleLabel.text = @"待收货";
    _waitShouhuo.subTitleLabel.font = [UIFont systemFontOfSize:12];
    _waitShouhuo.iconImageView.image = [UIImage imageNamed:@"lis1_daishouhuo"];
    [_waitShouhuo addTarget:self action:@selector(jumpToVCWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_waitShouhuo];
    
    _waitCommment = [[HXSPersonalCellButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_waitShouhuo.frame)+5, CGRectGetMaxY(seeView.frame)+10, width, height)];
    _waitCommment.valueLabel.adjustsFontSizeToFitWidth = YES;
    _waitCommment.tag = HXDOrderStatusButtonTypeWaitingComment;
    _waitCommment.subTitleLabel.text = @"待评价";
    _waitCommment.subTitleLabel.font = [UIFont systemFontOfSize:12];
    _waitCommment.iconImageView.image = [UIImage imageNamed:@"lis1_daipingjia"];
    [_waitCommment addTarget:self action:@selector(jumpToVCWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_waitCommment];
    
    _waitTuikuan = [[HXSPersonalCellButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_waitCommment.frame)+5, CGRectGetMaxY(seeView.frame)+10, width, height)];
    _waitTuikuan.valueLabel.adjustsFontSizeToFitWidth = YES;
    _waitTuikuan.tag = HXDOrderStatusButtonTypeTuikuan;
    _waitTuikuan.subTitleLabel.text = @"退款/售后";
    _waitTuikuan.subTitleLabel.adjustsFontSizeToFitWidth = YES;
    _waitTuikuan.subTitleLabel.font = [UIFont systemFontOfSize:12];
    _waitTuikuan.iconImageView.image = [UIImage imageNamed:@"lis1_shouhou"];
    [_waitTuikuan addTarget:self action:@selector(jumpToVCWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_waitTuikuan];
    

}
- (void)jumpToVCWithBtn:(HXSPersonalCellButton *)currentBtn{

    if ([self.delegate respondsToSelector:@selector(clickHXDOrderStatusButtonTypeButtonType:)]) {
        [self.delegate clickHXDOrderStatusButtonTypeButtonType:currentBtn.tag];
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
