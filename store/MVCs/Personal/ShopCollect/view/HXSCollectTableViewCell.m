//
//  HXSCollectTableViewCell.m
//  store
//
//  Created by caixinye on 2017/9/15.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXSCollectTableViewCell.h"

@interface HXSCollectTableViewCell ()


@property (strong, nonatomic)  UIImageView *shopNameImg;

@property (strong, nonatomic)  UILabel *nameLb;
@property (strong, nonatomic)  UILabel *subTitleLb;


@end
@implementation HXSCollectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
        
    }
    return self;
}

- (void)setupSubViews{
    
    _shopNameImg = [Maker makeImgView:CGRectMake(10, 10, 60, 60) img:@"ic_shop_logo"];
    _shopNameImg.layer.masksToBounds = YES;
    _shopNameImg.layer.cornerRadius = 30;
    [self.contentView addSubview:_shopNameImg];
   
    _nameLb = [Maker makeLb:CGRectMake(CGRectGetMaxX(_shopNameImg.frame)+10, 15, 70, 20) title:@"店铺名字" alignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13] textColor:[UIColor colorWithHexString:@"333333"]];
    _nameLb.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_nameLb];
    
    _subTitleLb = [Maker makeLb:CGRectMake(CGRectGetMaxX(_shopNameImg.frame)+10, CGRectGetMaxY(_nameLb.frame)+10, 100, 30) title:@"走过不要错过" alignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"999999"]];
    _subTitleLb.numberOfLines = 0;
    [self.contentView addSubview:_subTitleLb];
    
    _enterButton = [Maker makeBtn:CGRectMake(SCREEN_WIDTH-70, 20, 60, 30) title:@"进入店铺" img:nil font:[UIFont systemFontOfSize:13] target:self action:@selector(enterShopAction:)];
    [_enterButton setBackgroundColor:[UIColor colorWithHexString:@"fde25c"]];
    _enterButton.layer.cornerRadius = 5.0;
    [self.contentView addSubview:_enterButton];
    

}

- (void)enterShopAction:(UIButton *)sender{


    if(self.enterBtnDidClickdBlock)
        self.enterBtnDidClickdBlock(sender);

}
- (void)setupCellWithEntity:(HXSShopEntity *)entity;{
    
    // shop image
    [self.shopNameImg sd_setImageWithURL:[NSURL URLWithString:entity.shopLogoURLStr]
                        placeholderImage:[UIImage imageNamed:@"ic_shop_logo"]];
    
    // name
    self.nameLb.text = entity.shopNameStr;
    
    
    //subtitile
    self.subTitleLb.text = entity.noticeStr;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
