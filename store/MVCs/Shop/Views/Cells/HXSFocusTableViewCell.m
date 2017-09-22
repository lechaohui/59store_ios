//
//  HXSFocusTableViewCell.m
//  store
//
//  Created by 格格 on 16/10/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSFocusTableViewCell.h"
#import "HXSStoreAppEntryEntity.h"

@interface HXSFocusTableViewCell()

@property (nonatomic, weak) IBOutlet UIView *leftContaonerView;
@property (nonatomic, weak) IBOutlet UIImageView *leftImageView;
@property (nonatomic, weak) IBOutlet UILabel *leftTitleLabel;
@property (nonatomic, weak) IBOutlet UIButton *leftButton;

@property (nonatomic, weak) IBOutlet UIView *rightContaonerView;
@property (nonatomic, weak) IBOutlet UIImageView *rightImageView;
@property (nonatomic, weak) IBOutlet UILabel *rightTitleLabel;
@property (nonatomic, weak) IBOutlet UIButton *rightButton;



@end

@implementation HXSFocusTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.leftContaonerView setBackgroundColor:[UIColor whiteColor]];
    self.leftImageView.layer.cornerRadius = 4;
    self.leftImageView.layer.masksToBounds = YES;
    
    [self.rightContaonerView setBackgroundColor:[UIColor whiteColor]];
    self.rightImageView.layer.cornerRadius = 4;
    self.rightImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setFouceEntity1:(HXSStoreAppEntryEntity *)fouceEntity1
{
    _fouceEntity1 = fouceEntity1;
    
    if (nil == fouceEntity1) {
        
        self.leftContaonerView.hidden = YES;
        return;
    }
    
    self.leftContaonerView.hidden = NO;
    
    // title颜色后台可配置
    if (nil != fouceEntity1.titleColor) {
        [self.leftTitleLabel setTextColor:fouceEntity1.titleColor];
    } else {
        [self.leftTitleLabel setTextColor:[UIColor colorWithRGBHex:0x333333]];
    }
    self.leftTitleLabel.text = fouceEntity1.titleStr;
    
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:fouceEntity1.imageURLStr]
                          placeholderImage:[UIImage imageNamed:@"ic_drom_no_data"]];

}

- (void)setFouceEntity2:(HXSStoreAppEntryEntity *)fouceEntity2
{
    _fouceEntity2 = fouceEntity2;
    
    if (nil == fouceEntity2) {
        
        self.rightContaonerView.hidden = YES;
        return;
    }
    
    self.rightContaonerView.hidden = NO;
    
    // title颜色后台可配置
    if (nil != fouceEntity2.titleColor) {
        [self.rightTitleLabel setTextColor:fouceEntity2.titleColor];
    } else {
        [self.rightTitleLabel setTextColor:[UIColor colorWithRGBHex:0x333333]];
    }
    self.rightTitleLabel.text = fouceEntity2.titleStr;
    
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:fouceEntity2.imageURLStr]
                          placeholderImage:[UIImage imageNamed:@"ic_drom_no_data"]];
}

- (IBAction)buttonClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(foucsItemClicked:)]) {
        
        if (sender == self.leftButton) {
            [self.delegate foucsItemClicked:self.fouceEntity1];
        } else {
            [self.delegate foucsItemClicked:self.fouceEntity2];
        }
    }

}

@end
