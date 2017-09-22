//
//  HXSGoodsInfoCell.m
//  store
//
//  Created by 格格 on 16/8/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSGoodsInfoCell.h"

@interface HXSGoodsInfoCell ()

@property (nonatomic, weak) IBOutlet UIImageView *goodsImageView;   // 商品图片
@property (nonatomic, weak) IBOutlet UILabel     *goodsTitleLabel;  // 商品名称
@property (nonatomic, weak) IBOutlet UILabel     *detialLabel;      // 描述
@property (nonatomic, weak) IBOutlet UILabel     *priceLabel;       // 单价
@property (nonatomic, weak) IBOutlet UILabel     *numLabel;         // 商品数量
@property (nonatomic, weak) IBOutlet UILabel     *oriPriceLabel;    // 原价

@end

@implementation HXSGoodsInfoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.goodsImageView.layer.cornerRadius = 4;
    self.goodsImageView.layer.borderColor = [UIColor colorWithRGBHex:0xf1f2f3].CGColor;
    self.goodsImageView.layer.borderWidth = 1.0;
    self.goodsImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (instancetype)goodsInfoCell
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

- (void)refresh
{
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:self.myOrderItem.imgStr]];
    self.goodsTitleLabel.text = self.myOrderItem.nameStr;
    self.detialLabel.text = self.myOrderItem.specStr;
    self.priceLabel.text = [self.myOrderItem.priceDecNum yuanString];
    self.numLabel.text = [NSString stringWithFormat:@"x%@",self.myOrderItem.quantityStr];
    
    if (NSOrderedDescending == [self.myOrderItem.oriPriceDecNum compare:self.myOrderItem.priceDecNum]) {
        
        self.oriPriceLabel.hidden = NO;
        
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        
        NSAttributedString *str = [[NSAttributedString alloc]initWithString:[self.myOrderItem.oriPriceDecNum yuanString] attributes:attribtDic];
        
        self.oriPriceLabel.attributedText = str;
    } else {
        self.oriPriceLabel.hidden = YES;
    }
    
}

- (void)setMyOrderItem:(HXSMyOrderItem *)myOrderItem
{
    _myOrderItem = myOrderItem;
    [self refresh];
}

@end
