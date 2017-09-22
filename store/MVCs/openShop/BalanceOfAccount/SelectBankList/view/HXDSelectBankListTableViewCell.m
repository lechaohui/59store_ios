//
//  HXDSelectBankListTableViewCell.m
//  59dorm
//
//  Created by J006 on 16/3/3.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXDSelectBankListTableViewCell.h"

@interface HXDSelectBankListTableViewCell()

@property (nonatomic, strong) HXDBankEntity         *currentEntity;
@property (weak, nonatomic) IBOutlet UIImageView    *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel        *titleLabel;

@end

@implementation HXDSelectBankListTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark init

- (void)initSelectBankListTableViewCellWith:(HXDBankEntity *)entity
{
    _currentEntity = entity;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_currentEntity.bankImageStr]];
    [_titleLabel setText:_currentEntity.bankNameStr];
}

@end
