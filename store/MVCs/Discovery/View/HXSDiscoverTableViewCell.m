//
//  HXSDiscoverTableViewCell.m
//  store
//
//  Created by ArthurWang on 16/9/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDiscoverTableViewCell.h"

@interface HXSDiscoverTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (nonatomic, strong) HXSStoreAppEntryEntity *leftBannerEntity;
@property (nonatomic, strong) HXSStoreAppEntryEntity *rightBannerEntity;
@property (nonatomic, weak  ) id<HXSDiscoverTableViewCellDelegate> delegate;

@end

@implementation HXSDiscoverTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(onClickLeftBannerImage)];
    [self.leftImageView addGestureRecognizer:leftTap];
    
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(onClickRightBannerImage)];
    
    [self.rightImageView addGestureRecognizer:rightTap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - Public Methods

+ (CGFloat)heightOfCellWithEntity:(HXSStoreAppEntryEntity *)entryEntity
{
    if (nil == entryEntity) {
        return 0.1f;
    }
    
    CGFloat horizontalPadding = 1;
    CGFloat verticalPadding = 10;
    
    CGFloat width = (SCREEN_WIDTH - horizontalPadding) / 2.0f;
    
    CGSize size = CGSizeMake(entryEntity.imageWidthIntNum.floatValue, entryEntity.imageHeightIntNum.floatValue);
    CGFloat scaleOfSize = size.height/size.width;
    if (isnan(scaleOfSize)
        || isinf(scaleOfSize)) {
        scaleOfSize = 1.0;
    }
    
    CGFloat height = width * scaleOfSize;
    
    return height + verticalPadding;
}

- (void)setupCellWithLeftBanner:(HXSStoreAppEntryEntity *)leftBannerEntity
                    rightBanner:(HXSStoreAppEntryEntity *)rightBannerEntity
                       delegate:(id<HXSDiscoverTableViewCellDelegate>)delegate
{
    self.leftBannerEntity  = leftBannerEntity;
    self.rightBannerEntity = rightBannerEntity;
    self.delegate          = delegate;
    
    if (nil != leftBannerEntity) {
        [self.leftImageView setHidden:NO];
        
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:leftBannerEntity.imageURLStr] placeholderImage:[UIImage imageNamed:@"img_kp_banner_cat"]];
    } else {
        [self.leftImageView setHidden:YES];
    }
    
    if (nil != rightBannerEntity) {
        [self.rightImageView setHidden:NO];
        
        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:rightBannerEntity.imageURLStr] placeholderImage:[UIImage imageNamed:@"img_kp_banner_cat"]];
    } else {
        [self.rightImageView setHidden:YES];
    }
}


#pragma mark - Target Methods

- (void)onClickLeftBannerImage
{
    if ([self.delegate respondsToSelector:@selector(didSelectedLink:)]) {
        [self.delegate didSelectedLink:self.leftBannerEntity.linkURLStr];
    }
}

- (void)onClickRightBannerImage
{
    if ([self.delegate respondsToSelector:@selector(didSelectedLink:)]) {
        [self.delegate didSelectedLink:self.rightBannerEntity.linkURLStr];
    }
}

@end
