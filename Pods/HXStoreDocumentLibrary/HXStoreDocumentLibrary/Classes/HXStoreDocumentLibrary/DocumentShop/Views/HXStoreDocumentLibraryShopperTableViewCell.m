//
//  HXStoreMyDocumentLibraryTableViewCell.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/24.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibraryShopperTableViewCell.h"

//model
#import "HXStoreDocumentLibraryViewModel.h"

//other
#import "NSDecimalNumber+StringTools.h"

@interface HXStoreDocumentLibraryShopperTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView    *docIconImageView;
@property (weak, nonatomic) IBOutlet UILabel        *docNameLabel;
@property (weak, nonatomic) IBOutlet UILabel        *docProvisionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel        *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel        *priceLabel;
@property (nonatomic, strong) HXStoreDocumentLibraryViewModel   *viewModel;

@end

@implementation HXStoreDocumentLibraryShopperTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - init

- (void)initDocumentLibraryShopperCellWithDocModel:(HXStoreDocumentLibraryDocumentModel *)docModel
{
    [self matchingImageViewWithModel:docModel];
    
    [_docNameLabel setText:docModel.docTitleStr == nil ? @"" : docModel.docTitleStr];

    [_docProvisionNameLabel setText:docModel.docProvisionNameStr == nil ? @"" : docModel.docProvisionNameStr];
    
    [self settingTimeLabel:docModel];
    
    [self settingPriceLabel:docModel];
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
    _priceLabel.layer.borderColor = [UIColor colorWithRGBHex:0xF9A502].CGColor;
    _priceLabel.layer.borderWidth = 0.5;
    [_priceLabel.layer setMasksToBounds:YES];
    [_priceLabel setBackgroundColor:[UIColor clearColor]];
    
    if([docModel.typeNum isEqualToNumber:@(HXSLibraryDocumentTypeBuy)]
       && docModel.priceDecNum) {
        NSDecimalNumber *priceNum = [docModel.priceDecNum twoDecimalPlacesDecimalNumber];
        NSString *priceStr = [NSString stringWithFormat:@"¥%@",priceNum.stringValue];
        
        [_priceLabel setText:priceStr];
        [_priceLabel setBackgroundColor:[UIColor clearColor]];
        if([docModel.hasRightsNum boolValue]) {
            [_priceLabel setBackgroundColor:[UIColor colorWithRGBHex:0xfff1d6]];
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:priceStr];
            [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                    value:@2
                                    range:NSMakeRange(0, [attributeString length])];
            [_priceLabel setAttributedText:attributeString];
        }
        
    } else {
        [_priceLabel setText:@"免费"];
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


#pragma mark - getter

- (HXStoreDocumentLibraryViewModel *)viewModel
{
    if(nil == _viewModel) {
        _viewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
    }
    
    return _viewModel;
}

@end
