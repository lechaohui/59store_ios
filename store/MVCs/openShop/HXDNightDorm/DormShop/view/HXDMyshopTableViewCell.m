
//
//  HXDMyshopTableViewCell.m
//  store
//
//  Created by caixinye on 2017/9/12.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXDMyshopTableViewCell.h"

@implementation HXDMyshopTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    if(self==[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor colorWithHexString:@"eeeeee"];
        [self createUI];
    }
    return self;
    
    
    
    
}
- (void)createUI{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 140)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5.0;
    [self.contentView addSubview:backView];
    
    //常用设置
    UILabel *setLb = [Maker makeLb:CGRectMake(15, 10, CGRectGetWidth(backView.frame)-30, 30) title:@"常用功能" alignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor]];
    [backView addSubview:setLb];
    
    //line
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(setLb.frame)+10, CGRectGetWidth(backView.frame), 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [backView addSubview:line];
    
    CGFloat width = (CGRectGetWidth(backView.frame)-30-40)/3.0;
    CGFloat height = 50;
    CGFloat ypos = CGRectGetMaxY(line.frame)+5;
    //_ShopSettingBut
    _ShopSettingBut = [[HXSPersonalCellButton alloc] initWithFrame:CGRectMake(15, ypos, width,height)];
    _ShopSettingBut.valueLabel.adjustsFontSizeToFitWidth = YES;
    _ShopSettingBut.tag = HXDPersonCellButtonShopSetting;
    [backView addSubview:_ShopSettingBut];
    _ShopSettingBut.subTitleLabel.text = @"店铺设置";
    _ShopSettingBut.iconImageView.image = [UIImage imageNamed:@"qianbi_icon"];
    _ShopSettingBut.subTitleLabel.textColor = [UIColor blackColor];
    [_ShopSettingBut addTarget:self action:@selector(jumpToVC:) forControlEvents:UIControlEventTouchUpInside];
    
    //_ShopIdeaBut
    _ShopIdeaBut = [[HXSPersonalCellButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_ShopSettingBut.frame)+20, ypos, width,height)];
    _ShopIdeaBut.valueLabel.adjustsFontSizeToFitWidth = YES;
    _ShopIdeaBut.tag = HXDPersonCellOpenShopIdea;
    [backView addSubview:_ShopIdeaBut];
    _ShopIdeaBut.subTitleLabel.text = @"开店攻略";
    _ShopIdeaBut.iconImageView.image = [UIImage imageNamed:@"qianbi_icon"];
    
    _ShopIdeaBut.subTitleLabel.textColor = [UIColor blackColor];
    [_ShopIdeaBut addTarget:self action:@selector(jumpToVC:) forControlEvents:UIControlEventTouchUpInside];
    
    //_ShouyinTaiBut
    _ShouyinTaiBut = [[HXSPersonalCellButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_ShopIdeaBut.frame)+20, ypos, width,height)];
    _ShouyinTaiBut.valueLabel.adjustsFontSizeToFitWidth = YES;
    _ShouyinTaiBut.tag = HXDPersonCellShouyinTai;
    [backView addSubview:_ShouyinTaiBut];
    _ShouyinTaiBut.subTitleLabel.text = @"收银台";
    _ShouyinTaiBut.iconImageView.image = [UIImage imageNamed:@"qianbi_icon"];
    _ShouyinTaiBut.subTitleLabel.textColor = [UIColor blackColor];
    [_ShouyinTaiBut addTarget:self action:@selector(jumpToVC:) forControlEvents:UIControlEventTouchUpInside];
    
    
    


}
#pragma mark - target
- (void)jumpToVC:(HXSPersonalMenuButton *)currentBtn{

    if ([self.delegate respondsToSelector:@selector(clickPersonCellButtonType:)]) {
        [self.delegate clickPersonCellButtonType:currentBtn.tag];
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
