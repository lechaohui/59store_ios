//
//  HXSDoodsCollectionViewCell.m
//  store
//
//  Created by caixinye on 2017/9/2.
//  Copyright © 2017年 huanxiao. All rights reserved.
//

#import "HXSDoodsCollectionViewCell.h"
@interface HXSDoodsCollectionViewCell()


@property (nonatomic,strong) UIView *bgView;

//图片
@property(nonatomic,strong)UIImageView *imgView;
//title
@property(nonatomic,strong)UILabel *titleLb;

//price
@property(nonatomic,strong)UILabel *priceLb;

//commentnum
@property(nonatomic,strong)UIButton *commentBut;



//cartBut
@property(nonatomic,strong)UIButton *carBut;






@end
@implementation HXSDoodsCollectionViewCell

-(id)initWithFrame:(CGRect)frame {
    if ( !(self = [super initWithFrame:frame]) ) return nil;
    [self creatUI];
    return self;
}

- (void)creatUI{

    
//    self.bgView = [UIView new];
//    self.bgView.backgroundColor =[UIColor redColor];
//    [self addSubview:self.bgView];
    self.backgroundColor = [UIColor whiteColor];
    //图片
    self.imgView = [[UIImageView alloc] init];
    [self.imgView setImage:[UIImage imageNamed:@"about_us"]];
    [self addSubview:self.imgView];
    
    //title
    self.titleLb = [Maker makeLb:CGRectZero title:@"迪士尼草莓饼干" alignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13] textColor:[UIColor blackColor]];
    [self addSubview:self.titleLb];
    
    
    //price
    self.priceLb = [Maker makeLb:CGRectZero title:@"¥ 16.88" alignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:13] textColor:[UIColor blackColor]];
    [self addSubview:self.priceLb];
    
    //commentBut
    self.commentBut = [Maker makeBtn:CGRectZero title:@"5条评论，好评率100%" img:nil font:[UIFont systemFontOfSize:10] target:self action:@selector(commentButAction:)];
    [self.commentBut.titleLabel sizeToFit];
    [self addSubview:self.commentBut];
    
    
    //cartBut
     self.carBut = [Maker makeBtn:CGRectZero title:@"购物车" img:nil font:[UIFont systemFontOfSize:14] target:self action:@selector(addCartAction:)];
    [self addSubview:self.carBut];
    [self.carBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.carBut setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [self.carBut setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    
    
    //frame
//    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self.mas_top);
//        make.left.equalTo(self.mas_left).offset(0);
//        make.bottom.equalTo(self.mas_bottom);
//        make.right.equalTo(self.mas_right);
//        
//    }];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(self.mas_top).offset(5);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(self.bounds.size.width-20, 120));
        
    }];
    
    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left).offset(14);
        make.top.mas_equalTo(_imgView.mas_bottom).offset(5);
       // make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(20);
        
        
    }];
    [_priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_titleLb.mas_bottom).offset(10);
        //make.centerX.mas_equalTo(self.mas_centerX);
        make.left.mas_equalTo(self.mas_left).offset(14);
        make.height.mas_equalTo(20);
        
    }];
    [_commentBut mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.left.mas_equalTo(self.mas_left).offset(14);
         make.top.mas_equalTo(_priceLb.mas_bottom).offset(5);
         //make.right.mas_equalTo(self.carBut.mas_left).offset(-10);
         make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
         make.height.mas_equalTo(@(15));
         make.width.mas_equalTo((self.bounds.size.width-14-20)*2/3);
    
        
    }];
    
    [_carBut mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_commentBut.mas_right).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.bottom.mas_equalTo(_commentBut.mas_bottom).offset(0);
        make.height.mas_equalTo(@(15));
        
    }];


}
- (void)setModel:(HXSStoreAppEntryEntity *)model{

    //根据model的字段进行赋值
    _model = model;
    
    if (model.imageURLStr) {
       [_imgView sd_setImageWithURL:[NSURL URLWithString:model.imageURLStr] placeholderImage:[UIImage imageNamed:@"about_us"]];
    }
    //先判断是否有食品的名字
    if (model.titleStr) {
      
        _titleLb.text = model.titleStr;
    }
    
    //购物车是否加入model里面有个字段判断是否已经加入购物车
//    if (model.notcart) {
//       //没加入
//        _carBut.selected = NO;
//        
//    }else{
//    
//        _carBut.selected = YES;
//    }
//    

}
- (void)addCartAction:(UIButton *)sender{



    if (self.delegate&&[self.delegate respondsToSelector:@selector(onCartButtonClick:)]) {
        
        
        [self.delegate onCartButtonClick:self];
        
    }

}
- (void)commentButAction:(UIButton *)sender{




    
    



}
@end
