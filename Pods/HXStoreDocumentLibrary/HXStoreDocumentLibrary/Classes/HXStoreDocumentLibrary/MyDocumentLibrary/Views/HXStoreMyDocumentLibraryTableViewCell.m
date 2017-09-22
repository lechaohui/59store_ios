//
//  HXStoreMyDocumentLibraryTableViewCell.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/24.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreMyDocumentLibraryTableViewCell.h"

//model
#import "HXStoreDocumentLibraryViewModel.h"

//others
#import "NSDecimalNumber+StringTools.h"

@interface HXStoreMyDocumentLibraryTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView    *docIconImageView;
@property (weak, nonatomic) IBOutlet UILabel        *docNameLabel;
@property (weak, nonatomic) IBOutlet UILabel        *docProvisionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel        *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel        *readCountsLabel;
@property (weak, nonatomic) IBOutlet UILabel        *priceLabel;
@property (nonatomic, strong) HXStoreDocumentLibraryViewModel   *viewModel;
@property (weak, nonatomic) IBOutlet UIView         *readsBackGroundView;
@property (weak, nonatomic) IBOutlet UILabel        *checkingLabel;
@property (weak, nonatomic) IBOutlet UILabel        *reviewsLabel;
@property (weak, nonatomic) IBOutlet UIImageView    *checkingFailImageView;

@end

@implementation HXStoreMyDocumentLibraryTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - init

- (void)initMyDocumentLibraryCellWithDocModel:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    [self matchingImageViewWithModel:docModel];
    
    [_docNameLabel setText:docModel.docTitleStr == nil ? @"" : docModel.docTitleStr];

    [_docProvisionNameLabel setText:docModel.docProvisionNameStr == nil ? @"" : docModel.docProvisionNameStr];
    
    [self settingTimeLabel:docModel];
    
    switch (docModel.verifyStatusNum.integerValue)
    {
        case HXSLibraryDocumentVerifyStatusChecking:
        {
            [_readsBackGroundView   setHidden:NO];
            [_checkingFailImageView setHidden:YES];
            [_checkingLabel     setHidden:NO];
            [_readCountsLabel   setHidden:YES];
            [_reviewsLabel      setHidden:YES];
            [self settingReadCountsLabel:docModel];
        }
            break;
            
        case HXSLibraryDocumentVerifyStatusPass:
        {
            [_readsBackGroundView setHidden:NO];
            [_checkingFailImageView setHidden:YES];
            [_checkingLabel     setHidden:YES];
            [_readCountsLabel   setHidden:NO];
            [_reviewsLabel      setHidden:NO];
            [self settingReadCountsLabel:docModel];
        }
            break;
            
        default:
        {
            [_readsBackGroundView setHidden:YES];
            [_checkingFailImageView setHidden:NO];
        }
            
            break;
    }
    
    [self settingPriceLabel:docModel];
}

/**
 *  设置浏览次数
 *
 *  @param docModel
 */
- (void)settingReadCountsLabel:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    _readsBackGroundView.layer.cornerRadius = 3;
    _readsBackGroundView.layer.borderColor = [UIColor colorWithRGBHex:0x666666].CGColor;
    _readsBackGroundView.layer.borderWidth = 0.5;
    [_readsBackGroundView.layer setMasksToBounds:YES];
    
    NSInteger counts = [docModel.readCountNum integerValue];
    NSString *readContent;
    
    if(counts < 10000) {
        readContent = [NSString stringWithFormat:@"%zd",docModel.readCountNum == nil ? 0 : counts];
    } else {
        if(counts % 10000 == 0) {
            readContent = [NSString stringWithFormat:@"%zd万",counts / 10000];
        } else {
            readContent = [NSString stringWithFormat:@"%.1f万",counts / 10000.0];
        }
    }
    
    [_readCountsLabel setText:readContent];
}

/**
 *  设置时间
 *
 *  @param docModel
 */
- (void)settingTimeLabel:(HXStoreDocumentLibraryDocumentModel *)docModel
{    
    [_createTimeLabel setText:docModel.createTimestampStr == nil ? @"" : [self.viewModel createUploadTimeYearMonthDayWithTimeStamp:docModel.createTimestampStr]];
}

- (void)settingPriceLabel:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    _priceLabel.layer.cornerRadius = 3;
    _priceLabel.layer.borderWidth  = 0.5;
    _priceLabel.layer.borderColor = [UIColor colorWithRGBHex:0xF9A502].CGColor;
    [_priceLabel.layer setMasksToBounds:YES];
    
    if([docModel.typeNum isEqualToNumber:@(HXSLibraryDocumentTypeBuy)]
       && docModel.priceDecNum) {
        [_priceLabel setHidden:NO];
        NSDecimalNumber *priceNum = [docModel.priceDecNum twoDecimalPlacesDecimalNumber];
        [_priceLabel setText:[NSString stringWithFormat:@"¥%@",priceNum.stringValue]];
    } else {
        [_priceLabel removeFromSuperview];
    }
}

/**
 *  根据文档原始格式匹配图片icon
 *
 *  @param docModel
 */
- (void)matchingImageViewWithModel:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    [self.viewModel setImageForIconImageView:_docIconImageView withModel:docModel];
}

#pragma mark - Getter

- (HXStoreDocumentLibraryViewModel *)viewModel
{
    if(nil == _viewModel) {
        _viewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
    }
    
    return _viewModel;
}

@end
