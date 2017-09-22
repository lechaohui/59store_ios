//
//  HXSGoodsFreePostageCell.m
//  store
//
//  Created by 格格 on 16/10/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSGoodsFreePostageCell.h"

@interface HXSGoodsFreePostageCell ()

@property (nonatomic, weak) IBOutlet UIImageView *bannerImage;

@end

@implementation HXSGoodsFreePostageCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setAppEntryEntity:(HXSStoreAppEntryEntity *)appEntryEntity
{
    _appEntryEntity = appEntryEntity;
    
    [self.bannerImage sd_setImageWithURL:[NSURL URLWithString:_appEntryEntity.imageURLStr]];
}

@end
